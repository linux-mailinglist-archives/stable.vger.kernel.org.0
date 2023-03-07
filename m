Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04526AF17B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjCGSoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjCGSoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:44:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E08B5A9F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A112E61545
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98935C433D2;
        Tue,  7 Mar 2023 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213988;
        bh=wdddd97lNEsy7Qh7KtufU0XtlIg1UTyiH9R6gbRW7/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfcg7PJfZ4+FPDsXYniqKGoyMGSmBd38yVygtRs19DREyXaJc/P2BnBRUtb15B+vM
         Knc2Qwt4BXXSrSkOo5dmHE5OPK13ETy9HXEiYWorDOp11JoLgUX3rXg5ioGpRgCnMs
         DN2zvWeQ3JYwIbju+yVDXzgjD4M4wY+BUw8tdDwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangyu Hua <hbh25y@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 685/885] ksmbd: fix possible memory leak in smb2_lock()
Date:   Tue,  7 Mar 2023 18:00:19 +0100
Message-Id: <20230307170031.875792007@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit d3ca9f7aeba793d74361d88a8800b2f205c9236b upstream.

argv needs to be free when setup_async_work fails or when the current
process is woken up.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c   |   28 +++++++++++++---------------
 fs/ksmbd/vfs_cache.c |    5 ++---
 2 files changed, 15 insertions(+), 18 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6642,7 +6642,7 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
-	struct ksmbd_work *cancel_work = NULL, *iter;
+	struct ksmbd_work *iter;
 	struct list_head *command_list;
 
 	ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
@@ -6664,7 +6664,9 @@ int smb2_cancel(struct ksmbd_work *work)
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
@@ -6683,18 +6685,12 @@ int smb2_cancel(struct ksmbd_work *work)
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
@@ -7055,6 +7051,14 @@ skip:
 
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
@@ -7063,9 +7067,6 @@ skip:
 					locks_free_lock(flock);
 
 					if (work->state == KSMBD_WORK_CANCELLED) {
-						spin_lock(&fp->f_lock);
-						list_del(&work->fp_entry);
-						spin_unlock(&fp->f_lock);
 						rsp->hdr.Status =
 							STATUS_CANCELLED;
 						kfree(smb_lock);
@@ -7087,9 +7088,6 @@ skip:
 				list_del(&smb_lock->clist);
 				spin_unlock(&work->conn->llist_lock);
 
-				spin_lock(&fp->f_lock);
-				list_del(&work->fp_entry);
-				spin_unlock(&fp->f_lock);
 				goto retry;
 			} else if (!rc) {
 				spin_lock(&work->conn->llist_lock);
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -364,12 +364,11 @@ static void __put_fd_final(struct ksmbd_
 
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


