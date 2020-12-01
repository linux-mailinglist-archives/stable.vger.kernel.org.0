Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7EF2C9DB8
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389379AbgLAJ0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:26:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbgLAJDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745DE22240;
        Tue,  1 Dec 2020 09:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813351;
        bh=GE38RW3cyb11YTcBubEzhHDxwtUqFWKbY7kY78FjdLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDE2WloVEKYzI0htbQlWTc0M2G6mfE0uu2+4KXRuNUSphlBQwwQVyr6BOj3aCJCeP
         OU1h1u9amGLwcmJhZ62ZI2/XlBCKP8rXfdxVXZDI6GxPETVqQu2P2WzNMX7ULhMpW0
         lyGf+vEMZAQKU415h15CQ5mwICNJk7+bJivkMxCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 10/98] smb3: Call cifs reconnect from demultiplex thread
Date:   Tue,  1 Dec 2020 09:52:47 +0100
Message-Id: <20201201084654.041599418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit de9ac0a6e9efdffc8cde18781f48fb56ca4157b7 upstream.

cifs_reconnect needs to be called only from demultiplex thread.
skip cifs_reconnect in offload thread. So, cifs_reconnect will be
called by demultiplex thread in subsequent request.

These patches address a problem found during decryption offload:
     CIFS: VFS: trying to dequeue a deleted mid
that can cause a refcount use after free:

[ 1271.389453] Workqueue: smb3decryptd smb2_decrypt_offload [cifs]
[ 1271.389456] RIP: 0010:refcount_warn_saturate+0xae/0xf0
[ 1271.389457] Code: fa 1d 6a 01 01 e8 c7 44 b1 ff 0f 0b 5d c3 80 3d e7 1d 6a 01 00 75 91 48 c7 c7 d8 be 1d a2 c6 05 d7 1d 6a 01 01 e8 a7 44 b1 ff <0f> 0b 5d c3 80 3d c5 1d 6a 01 00 0f 85 6d ff ff ff 48 c7 c7 30 bf
[ 1271.389458] RSP: 0018:ffffa4cdc1f87e30 EFLAGS: 00010286
[ 1271.389458] RAX: 0000000000000000 RBX: ffff9974d2809f00 RCX: ffff9974df898cc8
[ 1271.389459] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9974df898cc0
[ 1271.389460] RBP: ffffa4cdc1f87e30 R08: 0000000000000004 R09: 00000000000002c0
[ 1271.389460] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9974b7fdb5c0
[ 1271.389461] R13: ffff9974d2809f00 R14: ffff9974ccea0a80 R15: ffff99748e60db80
[ 1271.389462] FS:  0000000000000000(0000) GS:ffff9974df880000(0000) knlGS:0000000000000000
[ 1271.389462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1271.389463] CR2: 000055c60f344fe4 CR3: 0000001031a3c002 CR4: 00000000003706e0
[ 1271.389465] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1271.389465] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1271.389466] Call Trace:
[ 1271.389483]  cifs_mid_q_entry_release+0xce/0x110 [cifs]
[ 1271.389499]  smb2_decrypt_offload+0xa9/0x1c0 [cifs]
[ 1271.389501]  process_one_work+0x1e8/0x3b0
[ 1271.389503]  worker_thread+0x50/0x370
[ 1271.389504]  kthread+0x12f/0x150
[ 1271.389506]  ? process_one_work+0x3b0/0x3b0
[ 1271.389507]  ? __kthread_bind_mask+0x70/0x70
[ 1271.389509]  ret_from_fork+0x22/0x30

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org> #5.4+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3979,7 +3979,8 @@ init_read_bvec(struct page **pages, unsi
 static int
 handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		 char *buf, unsigned int buf_len, struct page **pages,
-		 unsigned int npages, unsigned int page_data_size)
+		 unsigned int npages, unsigned int page_data_size,
+		 bool is_offloaded)
 {
 	unsigned int data_offset;
 	unsigned int data_len;
@@ -4001,7 +4002,8 @@ handle_read_data(struct TCP_Server_Info
 
 	if (server->ops->is_session_expired &&
 	    server->ops->is_session_expired(buf)) {
-		cifs_reconnect(server);
+		if (!is_offloaded)
+			cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -1;
 	}
@@ -4142,7 +4144,8 @@ static void smb2_decrypt_offload(struct
 		mid->decrypted = true;
 		rc = handle_read_data(dw->server, mid, dw->buf,
 				      dw->server->vals->read_rsp_size,
-				      dw->ppages, dw->npages, dw->len);
+				      dw->ppages, dw->npages, dw->len,
+				      true);
 		mid->callback(mid);
 		cifs_mid_q_entry_release(mid);
 	}
@@ -4246,7 +4249,7 @@ non_offloaded_decrypt:
 		(*mid)->decrypted = true;
 		rc = handle_read_data(server, *mid, buf,
 				      server->vals->read_rsp_size,
-				      pages, npages, len);
+				      pages, npages, len, false);
 	}
 
 free_pages:
@@ -4391,7 +4394,7 @@ smb3_handle_read_data(struct TCP_Server_
 	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
 
 	return handle_read_data(server, mid, buf, server->pdu_size,
-				NULL, 0, 0);
+				NULL, 0, 0, false);
 }
 
 static int


