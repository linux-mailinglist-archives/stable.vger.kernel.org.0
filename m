Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3C15FFEF0
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJPLSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJPLSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA5B357E8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE7960A54
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3415C433D6;
        Sun, 16 Oct 2022 11:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665919102;
        bh=GL16GmkKKB+LhtXzkc9z6I7pgwhuBV+9oj6G0rti+qk=;
        h=Subject:To:Cc:From:Date:From;
        b=W7APdNNUsMq6opSY8bHKdHiWOnEV2FKFeblUCb2gv9rDEIjqoqUVkYHoFBikby+gN
         fEHhIAGaAzItZIP/TUsuNP1/OaGmrBJuz6MAaNNu7SIoIP44br3L+AP6mslxkJxlRQ
         QHP8KylJrI0bzmS5XMCO93S/Z+/KJ2yWlDWhiV7I=
Subject: FAILED: patch "[PATCH] fs: dlm: fix possible use after free if tracing" failed to apply to 6.0-stable tree
To:     aahringo@redhat.com, dan.carpenter@oracle.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:19:08 +0200
Message-ID: <16659191486169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3b7610302a75 ("fs: dlm: fix possible use after free if tracing")
7a3de7324c2b ("fs: dlm: trace user space callbacks")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b7610302a75fc1032a6c9462862bec6948f85c9 Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 1 Sep 2022 12:05:32 -0400
Subject: [PATCH] fs: dlm: fix possible use after free if tracing

This patch fixes a possible use after free if tracing for the specific
event is enabled. To avoid the use after free we introduce a out_put
label like all other user lock specific requests and safe in a boolean
to do a put or not which depends on the execution path of
dlm_user_request().

Cc: stable@vger.kernel.org
Fixes: 7a3de7324c2b ("fs: dlm: trace user space callbacks")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c830feb26384..94a72ede5764 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5835,6 +5835,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 {
 	struct dlm_lkb *lkb;
 	struct dlm_args args;
+	bool do_put = true;
 	int error;
 
 	dlm_lock_recovery(ls);
@@ -5851,9 +5852,8 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_NOFS);
 		if (!ua->lksb.sb_lvbptr) {
 			kfree(ua);
-			__put_lkb(ls, lkb);
 			error = -ENOMEM;
-			goto out_trace_end;
+			goto out_put;
 		}
 	}
 #ifdef CONFIG_DLM_DEPRECATED_API
@@ -5867,8 +5867,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		kfree(ua->lksb.sb_lvbptr);
 		ua->lksb.sb_lvbptr = NULL;
 		kfree(ua);
-		__put_lkb(ls, lkb);
-		goto out_trace_end;
+		goto out_put;
 	}
 
 	/* After ua is attached to lkb it will be freed by dlm_free_lkb().
@@ -5887,8 +5886,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		error = 0;
 		fallthrough;
 	default:
-		__put_lkb(ls, lkb);
-		goto out_trace_end;
+		goto out_put;
 	}
 
 	/* add this new lkb to the per-process list of locks */
@@ -5896,8 +5894,11 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	hold_lkb(lkb);
 	list_add_tail(&lkb->lkb_ownqueue, &ua->proc->locks);
 	spin_unlock(&ua->proc->locks_spin);
- out_trace_end:
+	do_put = false;
+ out_put:
 	trace_dlm_lock_end(ls, lkb, name, namelen, mode, flags, error, false);
+	if (do_put)
+		__put_lkb(ls, lkb);
  out:
 	dlm_unlock_recovery(ls);
 	return error;

