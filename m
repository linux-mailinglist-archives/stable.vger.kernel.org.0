Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7629C314
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821359AbgJ0RnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460200AbgJ0OcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 373B7206DC;
        Tue, 27 Oct 2020 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809133;
        bh=1w0oQyMXds3QqX1ImPhu8MvaCOFm/wNUw+Zi0Nml0vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpYDIwQ9OgqambH9VxNZRzDVGbDw5vh0FlvcHZEpqUiEX26qocy3MuYWI8Ih2cL8m
         3f2olS0KlAJYEtjj7U7T2EXtfxANsyVPkCT3gEVeoXt3mpkCtW2edBzzQOv7DyKzqQ
         ea/1Oy7+m2n0edSV257it5ifp0MoZRD5paw9TZCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 047/408] SMB3: Resolve data corruption of TCP server info fields
Date:   Tue, 27 Oct 2020 14:49:45 +0100
Message-Id: <20201027135457.243746254@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 62593011247c8a8cfeb0c86aff84688b196727c2 upstream.

TCP server info field server->total_read is modified in parallel by
demultiplex thread and decrypt offload worker thread. server->total_read
is used in calculation to discard the remaining data of PDU which is
not read into memory.

Because of parallel modification, server->total_read can get corrupted
and can result in discarding the valid data of next PDU.

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org> #5.4+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3886,7 +3886,8 @@ smb3_is_transform_hdr(void *buf)
 static int
 decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct page **pages,
-		 unsigned int npages, unsigned int page_data_size)
+		 unsigned int npages, unsigned int page_data_size,
+		 bool is_offloaded)
 {
 	struct kvec iov[2];
 	struct smb_rqst rqst = {NULL};
@@ -3912,7 +3913,8 @@ decrypt_raw_data(struct TCP_Server_Info
 
 	memmove(buf, iov[1].iov_base, buf_data_size);
 
-	server->total_read = buf_data_size + page_data_size;
+	if (!is_offloaded)
+		server->total_read = buf_data_size + page_data_size;
 
 	return rc;
 }
@@ -4126,7 +4128,7 @@ static void smb2_decrypt_offload(struct
 	struct mid_q_entry *mid;
 
 	rc = decrypt_raw_data(dw->server, dw->buf, dw->server->vals->read_rsp_size,
-			      dw->ppages, dw->npages, dw->len);
+			      dw->ppages, dw->npages, dw->len, true);
 	if (rc) {
 		cifs_dbg(VFS, "error decrypting rc=%d\n", rc);
 		goto free_pages;
@@ -4232,7 +4234,7 @@ receive_encrypted_read(struct TCP_Server
 
 non_offloaded_decrypt:
 	rc = decrypt_raw_data(server, buf, server->vals->read_rsp_size,
-			      pages, npages, len);
+			      pages, npages, len, false);
 	if (rc)
 		goto free_pages;
 
@@ -4288,7 +4290,7 @@ receive_encrypted_standard(struct TCP_Se
 	server->total_read += length;
 
 	buf_size = pdu_length - sizeof(struct smb2_transform_hdr);
-	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0);
+	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0, false);
 	if (length)
 		return length;
 


