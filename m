Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383FE6DC500
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDJJUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDJJUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E554EC2
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD9DA61543
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C64C433EF;
        Mon, 10 Apr 2023 09:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681118444;
        bh=ucDLaDXJRmIufmJuwuYVTXYLqEL+QXAzNxDVF0gD3VM=;
        h=Subject:To:Cc:From:Date:From;
        b=Q2sOrBlr3AMXxERTq2SfhXmzq+t30HMU7w4UvLDwyU+K1Ig6qVdrgi2V/SCK7fUNu
         nBc6dPdyKywejZSRmV6OQkUG8M/sd272XvcUzSJNpcGFmt/8whuph86Z55YMzVQ2Zi
         uG/vY7oMsSLTifRRU2DXc4HX2wtumK2TPy6pZ2eU=
Subject: FAILED: patch "[PATCH] ksmbd: delete asynchronous work from list" failed to apply to 6.2-stable tree
To:     linkinjeon@kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 11:20:36 +0200
Message-ID: <2023041036-algebra-landmark-936e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 3a9b557f44ea8f216aab515a7db20e23f0eb51b9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041036-algebra-landmark-936e@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

3a9b557f44ea ("ksmbd: delete asynchronous work from list")
d3ca9f7aeba7 ("ksmbd: fix possible memory leak in smb2_lock()")
f8d6e7442aa7 ("ksmbd: fix typo, syncronous->synchronous")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a9b557f44ea8f216aab515a7db20e23f0eb51b9 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 31 Mar 2023 08:42:12 +0900
Subject: [PATCH] ksmbd: delete asynchronous work from list

When smb2_lock request is canceled by smb2_cancel or smb2_close(),
ksmbd is missing deleting async_request_entry async_requests list.
Because calling init_smb2_rsp_hdr() in smb2_lock() mark ->synchronous
as true and then it will not be deleted in
ksmbd_conn_try_dequeue_request(). This patch add release_async_work() to
release the ones allocated for async work.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 3f5dfebaa041..365ac32af505 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -112,10 +112,8 @@ void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct list_head *requests_queue = NULL;
 
-	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE) {
+	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE)
 		requests_queue = &conn->requests;
-		work->synchronous = true;
-	}
 
 	if (requests_queue) {
 		atomic_inc(&conn->req_running);
@@ -136,14 +134,14 @@ int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 
 	if (!work->multiRsp)
 		atomic_dec(&conn->req_running);
-	spin_lock(&conn->request_lock);
 	if (!work->multiRsp) {
+		spin_lock(&conn->request_lock);
 		list_del_init(&work->request_entry);
-		if (!work->synchronous)
-			list_del_init(&work->async_request_entry);
+		spin_unlock(&conn->request_lock);
+		if (work->asynchronous)
+			release_async_work(work);
 		ret = 0;
 	}
-	spin_unlock(&conn->request_lock);
 
 	wake_up_all(&conn->req_running_q);
 	return ret;
diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
index 3234f2cf6327..f8ae6144c0ae 100644
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -68,7 +68,7 @@ struct ksmbd_work {
 	/* Request is encrypted */
 	bool                            encrypted:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
-	bool                            synchronous:1;
+	bool                            asynchronous:1;
 	bool                            need_invalidate_rkey:1;
 
 	unsigned int                    remote_key;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 97c9d1b5bcc0..3656ccac06e3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -498,12 +498,6 @@ int init_smb2_rsp_hdr(struct ksmbd_work *work)
 	rsp_hdr->SessionId = rcv_hdr->SessionId;
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 
-	work->synchronous = true;
-	if (work->async_id) {
-		ksmbd_release_id(&conn->async_ida, work->async_id);
-		work->async_id = 0;
-	}
-
 	return 0;
 }
 
@@ -644,7 +638,7 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 		pr_err("Failed to alloc async message id\n");
 		return id;
 	}
-	work->synchronous = false;
+	work->asynchronous = true;
 	work->async_id = id;
 	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 
@@ -664,6 +658,24 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 	return 0;
 }
 
+void release_async_work(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+
+	spin_lock(&conn->request_lock);
+	list_del_init(&work->async_request_entry);
+	spin_unlock(&conn->request_lock);
+
+	work->asynchronous = 0;
+	work->cancel_fn = NULL;
+	kfree(work->cancel_argv);
+	work->cancel_argv = NULL;
+	if (work->async_id) {
+		ksmbd_release_id(&conn->async_ida, work->async_id);
+		work->async_id = 0;
+	}
+}
+
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
@@ -7045,13 +7057,9 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_vfs_posix_lock_wait(flock);
 
-				spin_lock(&work->conn->request_lock);
 				spin_lock(&fp->f_lock);
 				list_del(&work->fp_entry);
-				work->cancel_fn = NULL;
-				kfree(argv);
 				spin_unlock(&fp->f_lock);
-				spin_unlock(&work->conn->request_lock);
 
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
@@ -7069,6 +7077,7 @@ int smb2_lock(struct ksmbd_work *work)
 						work->send_no_response = 1;
 						goto out;
 					}
+
 					init_smb2_rsp_hdr(work);
 					smb2_set_err_rsp(work);
 					rsp->hdr.Status =
@@ -7081,7 +7090,7 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_lock(&work->conn->llist_lock);
 				list_del(&smb_lock->clist);
 				spin_unlock(&work->conn->llist_lock);
-
+				release_async_work(work);
 				goto retry;
 			} else if (!rc) {
 				spin_lock(&work->conn->llist_lock);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 0c8a770fe318..9420dd2813fb 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -486,6 +486,7 @@ int find_matching_smb2_dialect(int start_index, __le16 *cli_dialects,
 struct file_lock *smb_flock_init(struct file *f);
 int setup_async_work(struct ksmbd_work *work, void (*fn)(void **),
 		     void **arg);
+void release_async_work(struct ksmbd_work *work);
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status);
 struct channel *lookup_chann_list(struct ksmbd_session *sess,
 				  struct ksmbd_conn *conn);

