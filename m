Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98DA549075
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbiFMKV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbiFMKUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A371EC69;
        Mon, 13 Jun 2022 03:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7652B80E2D;
        Mon, 13 Jun 2022 10:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1E0C34114;
        Mon, 13 Jun 2022 10:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115431;
        bh=4CnfZTVIakF7H6BgXbf61/Vv64C1smXXvBhssH3OVKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rh0BFQlEReYcOKkJmTtMBzpw2oiQZftU4Ae6QUNrWckSykhAnRPS1gw/5djvc13wc
         06FIxG6llEyS10r7Ibq5q+A3yTr2gopeVGOYceLU8J/zplYhRSQTkwz3Bd7N/K7SNg
         pv3BfarjLVwNHSWgQPmFAQzHH+mI6hsOUkjph3Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 4.9 082/167] dlm: fix missing lkb refcount handling
Date:   Mon, 13 Jun 2022 12:09:16 +0200
Message-Id: <20220613094900.120461254@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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
@@ -1555,6 +1555,7 @@ static int _remove_from_waiters(struct d
 		lkb->lkb_wait_type = 0;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		goto out_del;
 	}
 
@@ -1581,6 +1582,7 @@ static int _remove_from_waiters(struct d
 		log_error(ls, "remwait error %x reply %d wait_type %d overlap",
 			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		lkb->lkb_wait_type = 0;
 	}
 
@@ -5314,11 +5316,16 @@ int dlm_recover_waiters_post(struct dlm_
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


