Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC92C9DB2
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390992AbgLAJ0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388076AbgLAJDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF9121D46;
        Tue,  1 Dec 2020 09:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813354;
        bh=Gu96mcO+nGWy8bt29fA43kKSGfZAAzgtLim6dgv0Ptw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KoQDcAlrS5Z+lPUskPUN1wuv2cefVdogIGB8iPGbds9CxtdSrJYMlHdRVuvV2Lh7/
         oCLUXwsIcZWmm+xSRfq6EaonsQeQa6L0mZ9+Rpz6BRR8Bh/QzsznfTl2wk2BeY3GR0
         xR/XS2wiZ4EerP5vMl3gygastzQ6OsNh8L+FwAVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 11/98] smb3: Avoid Mid pending list corruption
Date:   Tue,  1 Dec 2020 09:52:48 +0100
Message-Id: <20201201084654.168120858@linuxfoundation.org>
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

commit ac873aa3dc21707c47db5db6608b38981c731afe upstream.

When reconnect happens Mid queue can be corrupted when both
demultiplex and offload thread try to dequeue the MID from the
pending list.

These patches address a problem found during decryption offload:
         CIFS: VFS: trying to dequeue a deleted mid
that could cause a refcount use after free:
         Workqueue: smb3decryptd smb2_decrypt_offload [cifs]

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org> #5.4+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |   55 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 9 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -259,7 +259,7 @@ smb2_revert_current_mid(struct TCP_Serve
 }
 
 static struct mid_q_entry *
-smb2_find_mid(struct TCP_Server_Info *server, char *buf)
+__smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 {
 	struct mid_q_entry *mid;
 	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
@@ -276,6 +276,10 @@ smb2_find_mid(struct TCP_Server_Info *se
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
 			kref_get(&mid->refcount);
+			if (dequeue) {
+				list_del_init(&mid->qhead);
+				mid->mid_flags |= MID_DELETED;
+			}
 			spin_unlock(&GlobalMid_Lock);
 			return mid;
 		}
@@ -284,6 +288,18 @@ smb2_find_mid(struct TCP_Server_Info *se
 	return NULL;
 }
 
+static struct mid_q_entry *
+smb2_find_mid(struct TCP_Server_Info *server, char *buf)
+{
+	return __smb2_find_mid(server, buf, false);
+}
+
+static struct mid_q_entry *
+smb2_find_dequeue_mid(struct TCP_Server_Info *server, char *buf)
+{
+	return __smb2_find_mid(server, buf, true);
+}
+
 static void
 smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 {
@@ -4028,7 +4044,10 @@ handle_read_data(struct TCP_Server_Info
 		cifs_dbg(FYI, "%s: server returned error %d\n",
 			 __func__, rdata->result);
 		/* normal error on read response */
-		dequeue_mid(mid, false);
+		if (is_offloaded)
+			mid->mid_state = MID_RESPONSE_RECEIVED;
+		else
+			dequeue_mid(mid, false);
 		return 0;
 	}
 
@@ -4052,7 +4071,10 @@ handle_read_data(struct TCP_Server_Info
 		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
 			 __func__, data_offset);
 		rdata->result = -EIO;
-		dequeue_mid(mid, rdata->result);
+		if (is_offloaded)
+			mid->mid_state = MID_RESPONSE_MALFORMED;
+		else
+			dequeue_mid(mid, rdata->result);
 		return 0;
 	}
 
@@ -4068,21 +4090,30 @@ handle_read_data(struct TCP_Server_Info
 			cifs_dbg(FYI, "%s: data offset (%u) beyond 1st page of response\n",
 				 __func__, data_offset);
 			rdata->result = -EIO;
-			dequeue_mid(mid, rdata->result);
+			if (is_offloaded)
+				mid->mid_state = MID_RESPONSE_MALFORMED;
+			else
+				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 
 		if (data_len > page_data_size - pad_len) {
 			/* data_len is corrupt -- discard frame */
 			rdata->result = -EIO;
-			dequeue_mid(mid, rdata->result);
+			if (is_offloaded)
+				mid->mid_state = MID_RESPONSE_MALFORMED;
+			else
+				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 
 		rdata->result = init_read_bvec(pages, npages, page_data_size,
 					       cur_off, &bvec);
 		if (rdata->result != 0) {
-			dequeue_mid(mid, rdata->result);
+			if (is_offloaded)
+				mid->mid_state = MID_RESPONSE_MALFORMED;
+			else
+				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 
@@ -4097,7 +4128,10 @@ handle_read_data(struct TCP_Server_Info
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
 		rdata->result = -EIO;
-		dequeue_mid(mid, rdata->result);
+		if (is_offloaded)
+			mid->mid_state = MID_RESPONSE_MALFORMED;
+		else
+			dequeue_mid(mid, rdata->result);
 		return 0;
 	}
 
@@ -4108,7 +4142,10 @@ handle_read_data(struct TCP_Server_Info
 	if (length < 0)
 		return length;
 
-	dequeue_mid(mid, false);
+	if (is_offloaded)
+		mid->mid_state = MID_RESPONSE_RECEIVED;
+	else
+		dequeue_mid(mid, false);
 	return length;
 }
 
@@ -4137,7 +4174,7 @@ static void smb2_decrypt_offload(struct
 	}
 
 	dw->server->lstrp = jiffies;
-	mid = smb2_find_mid(dw->server, dw->buf);
+	mid = smb2_find_dequeue_mid(dw->server, dw->buf);
 	if (mid == NULL)
 		cifs_dbg(FYI, "mid not found\n");
 	else {


