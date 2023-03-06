Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31D6ABE2B
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 12:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCFLag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 06:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFLaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 06:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B22367F
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 03:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DB2B80D70
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 11:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB97CC433EF;
        Mon,  6 Mar 2023 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678102231;
        bh=W6lqmQPPFV5LqHUJhLkNMTaS5TQfF6KQXRNlCeCpY34=;
        h=Subject:To:Cc:From:Date:From;
        b=Apqe66OJ5R9svtoXj9C5AWl5272l+EcFvZvgf3KwvcnvaBM7PeoXny6xPbOwylHWj
         cKfRFE4+uPE7hDzcLlAIx0pJnXduR35l3vryGEtE5SA0LAdL43IeCYhSMXc67+7cWc
         akuSoAf1xvcFVcaMemvi/syMOReo2FRAT9APpQ40=
Subject: FAILED: patch "[PATCH] ksmbd: fix possible memory leak in smb2_lock()" failed to apply to 5.15-stable tree
To:     hbh25y@gmail.com, linkinjeon@kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 12:30:28 +0100
Message-ID: <16781022287459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x d3ca9f7aeba793d74361d88a8800b2f205c9236b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781022287459@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

d3ca9f7aeba7 ("ksmbd: fix possible memory leak in smb2_lock()")
edf5f0548fbb ("ksmbd: replace usage of found with dedicated list iterator variable")
cb4517201b8a ("ksmbd: remove smb2_buf_length in smb2_hdr")
341b16014bf8 ("ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3ca9f7aeba793d74361d88a8800b2f205c9236b Mon Sep 17 00:00:00 2001
From: Hangyu Hua <hbh25y@gmail.com>
Date: Fri, 17 Feb 2023 22:29:34 +0900
Subject: [PATCH] ksmbd: fix possible memory leak in smb2_lock()

argv needs to be free when setup_async_work fails or when the current
process is woken up.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a225727d4bc1..33cfc8d80c2c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6626,7 +6626,7 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
-	struct ksmbd_work *cancel_work = NULL, *iter;
+	struct ksmbd_work *iter;
 	struct list_head *command_list;
 
 	ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
@@ -6648,7 +6648,9 @@ int smb2_cancel(struct ksmbd_work *work)
 				    "smb2 with AsyncId %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->Id.AsyncId),
 				    le16_to_cpu(chdr->Command));
-			cancel_work = iter;
+			iter->state = KSMBD_WORK_CANCELLED;
+			if (iter->cancel_fn)
+				iter->cancel_fn(iter->cancel_argv);
 			break;
 		}
 		spin_unlock(&conn->request_lock);
@@ -6667,18 +6669,12 @@ int smb2_cancel(struct ksmbd_work *work)
 				    "smb2 with mid %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->MessageId),
 				    le16_to_cpu(chdr->Command));
-			cancel_work = iter;
+			iter->state = KSMBD_WORK_CANCELLED;
 			break;
 		}
 		spin_unlock(&conn->request_lock);
 	}
 
-	if (cancel_work) {
-		cancel_work->state = KSMBD_WORK_CANCELLED;
-		if (cancel_work->cancel_fn)
-			cancel_work->cancel_fn(cancel_work->cancel_argv);
-	}
-
 	/* For SMB2_CANCEL command itself send no response*/
 	work->send_no_response = 1;
 	return 0;
@@ -7043,6 +7039,14 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_vfs_posix_lock_wait(flock);
 
+				spin_lock(&work->conn->request_lock);
+				spin_lock(&fp->f_lock);
+				list_del(&work->fp_entry);
+				work->cancel_fn = NULL;
+				kfree(argv);
+				spin_unlock(&fp->f_lock);
+				spin_unlock(&work->conn->request_lock);
+
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
 					spin_lock(&work->conn->llist_lock);
@@ -7051,9 +7055,6 @@ int smb2_lock(struct ksmbd_work *work)
 					locks_free_lock(flock);
 
 					if (work->state == KSMBD_WORK_CANCELLED) {
-						spin_lock(&fp->f_lock);
-						list_del(&work->fp_entry);
-						spin_unlock(&fp->f_lock);
 						rsp->hdr.Status =
 							STATUS_CANCELLED;
 						kfree(smb_lock);
@@ -7075,9 +7076,6 @@ int smb2_lock(struct ksmbd_work *work)
 				list_del(&smb_lock->clist);
 				spin_unlock(&work->conn->llist_lock);
 
-				spin_lock(&fp->f_lock);
-				list_del(&work->fp_entry);
-				spin_unlock(&fp->f_lock);
 				goto retry;
 			} else if (!rc) {
 				spin_lock(&work->conn->llist_lock);
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index da9163b00350..0ae5dd0829e9 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -364,12 +364,11 @@ static void __put_fd_final(struct ksmbd_work *work, struct ksmbd_file *fp)
 
 static void set_close_state_blocked_works(struct ksmbd_file *fp)
 {
-	struct ksmbd_work *cancel_work, *ctmp;
+	struct ksmbd_work *cancel_work;
 
 	spin_lock(&fp->f_lock);
-	list_for_each_entry_safe(cancel_work, ctmp, &fp->blocked_works,
+	list_for_each_entry(cancel_work, &fp->blocked_works,
 				 fp_entry) {
-		list_del(&cancel_work->fp_entry);
 		cancel_work->state = KSMBD_WORK_CLOSED;
 		cancel_work->cancel_fn(cancel_work->cancel_argv);
 	}

