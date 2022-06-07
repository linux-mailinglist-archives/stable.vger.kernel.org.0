Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAE4541E3D
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379970AbiFGW1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382490AbiFGWYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:24:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07F226D37B;
        Tue,  7 Jun 2022 12:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10FB60A1D;
        Tue,  7 Jun 2022 19:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AF5C385A2;
        Tue,  7 Jun 2022 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629758;
        bh=+DFhx/+zMYy9AJgFEs5i0jMWEHc2bLU2fzKwpiStgNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Qkh6MafUN658oH/PBRmdKIptxqnb37TVVPiskiOg3wU5x9WgnEwnc8zJ2hbFNW+V
         57iTv7w4W9EarY4df/8VAUyaaFXkqMUQHshJp3a6GO2W4zs2eMTWuFcK1+yJeXvLxM
         woAgunQ9wubFbtKuqGg2vSG/U9Jv9U9/Z1rDG+mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.18 766/879] dlm: fix missing lkb refcount handling
Date:   Tue,  7 Jun 2022 19:04:44 +0200
Message-Id: <20220607165025.097431083@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 1689c169134f4b5a39156122d799b7dca76d8ddb upstream.

We always call hold_lkb(lkb) if we increment lkb->lkb_wait_count.
So, we always need to call unhold_lkb(lkb) if we decrement
lkb->lkb_wait_count. This patch will add missing unhold_lkb(lkb) if we
decrement lkb->lkb_wait_count. In case of setting lkb->lkb_wait_count to
zero we need to countdown until reaching zero and call unhold_lkb(lkb).
The waiters list unhold_lkb(lkb) can be removed because it's done for
the last lkb_wait_count decrement iteration as it's done in
_remove_from_waiters().

This issue was discovered by a dlm gfs2 test case which use excessively
dlm_unlock(LKF_CANCEL) feature. Probably the lkb->lkb_wait_count value
never reached above 1 if this feature isn't used and so it was not
discovered before.

The testcase ended in a rsb on the rsb keep data structure with a
refcount of 1 but no lkb was associated with it, which is itself
an invalid behaviour. A side effect of that was a condition in which
the dlm was sending remove messages in a looping behaviour. With this
patch that has not been reproduced.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1559,6 +1559,7 @@ static int _remove_from_waiters(struct d
 		lkb->lkb_wait_type = 0;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		goto out_del;
 	}
 
@@ -1585,6 +1586,7 @@ static int _remove_from_waiters(struct d
 		log_error(ls, "remwait error %x reply %d wait_type %d overlap",
 			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		lkb->lkb_wait_type = 0;
 	}
 
@@ -5331,11 +5333,16 @@ int dlm_recover_waiters_post(struct dlm_
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_type = 0;
-		lkb->lkb_wait_count = 0;
+		/* drop all wait_count references we still
+		 * hold a reference for this iteration.
+		 */
+		while (lkb->lkb_wait_count) {
+			lkb->lkb_wait_count--;
+			unhold_lkb(lkb);
+		}
 		mutex_lock(&ls->ls_waiters_mutex);
 		list_del_init(&lkb->lkb_wait_reply);
 		mutex_unlock(&ls->ls_waiters_mutex);
-		unhold_lkb(lkb); /* for waiters list */
 
 		if (oc || ou) {
 			/* do an unlock or cancel instead of resending */


