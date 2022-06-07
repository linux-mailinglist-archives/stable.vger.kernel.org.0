Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7558C540F3D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353432AbiFGTEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353440AbiFGTCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8838D157E9E;
        Tue,  7 Jun 2022 11:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1454161804;
        Tue,  7 Jun 2022 18:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D508C385A5;
        Tue,  7 Jun 2022 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625097;
        bh=aSa0SYQQmIJoAcUp/KPB7tSfEcW5sKv3qHZSZ/MUdGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRdAVxb/VrdPlb0avnjUdsEqaUz08K/h4KfRoiKGYm2LD8cwEo68K/++LCj2K27RV
         ltQsdu7m//uqitDA7uOY3VO2RmWHBQunccK7wAvxZFIpZS6TsRSCtXjviU6sKknARG
         fu2A9+6G3G6s7sZxvw5UPWg06LiAAGz3ZKYzvmTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 563/667] dlm: fix missing lkb refcount handling
Date:   Tue,  7 Jun 2022 19:03:48 +0200
Message-Id: <20220607164951.581883999@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
@@ -1551,6 +1551,7 @@ static int _remove_from_waiters(struct d
 		lkb->lkb_wait_type = 0;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		goto out_del;
 	}
 
@@ -1577,6 +1578,7 @@ static int _remove_from_waiters(struct d
 		log_error(ls, "remwait error %x reply %d wait_type %d overlap",
 			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		lkb->lkb_wait_type = 0;
 	}
 
@@ -5310,11 +5312,16 @@ int dlm_recover_waiters_post(struct dlm_
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


