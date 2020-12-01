Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65B2C9D26
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390602AbgLAJTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389607AbgLAJJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC3C221FD;
        Tue,  1 Dec 2020 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813757;
        bh=cRe5mJBKoQHBJb+J5qMIuqEBsxPrftHbP3xrSHAiY0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlPLFZbjNOGYjVVdFs97zewP85+Vqs04uKZmeg37074KGZwp+85VMic3sjo79Kakj
         rE0heoSF5EqDX/ovQ8kzKFB0T2AlgiSe1rXOeNXVNJiCIVWOGmN1h82PWRPUwF69gh
         wGkhNEwbcgRP7I3tfnp+qJZhr/76s/WCAwXrE57c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 018/152] smb3: Handle error case during offload read path
Date:   Tue,  1 Dec 2020 09:52:13 +0100
Message-Id: <20201201084714.265683626@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 1254100030b3377e8302f9c75090ab191d73ee7c upstream.

Mid callback needs to be called only when valid data is
read into pages.

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
 fs/cifs/smb2ops.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4415,7 +4415,25 @@ static void smb2_decrypt_offload(struct
 				      dw->server->vals->read_rsp_size,
 				      dw->ppages, dw->npages, dw->len,
 				      true);
-		mid->callback(mid);
+		if (rc >= 0) {
+#ifdef CONFIG_CIFS_STATS2
+			mid->when_received = jiffies;
+#endif
+			mid->callback(mid);
+		} else {
+			spin_lock(&GlobalMid_Lock);
+			if (dw->server->tcpStatus == CifsNeedReconnect) {
+				mid->mid_state = MID_RETRY_NEEDED;
+				spin_unlock(&GlobalMid_Lock);
+				mid->callback(mid);
+			} else {
+				mid->mid_state = MID_REQUEST_SUBMITTED;
+				mid->mid_flags &= ~(MID_DELETED);
+				list_add_tail(&mid->qhead,
+					&dw->server->pending_mid_q);
+				spin_unlock(&GlobalMid_Lock);
+			}
+		}
 		cifs_mid_q_entry_release(mid);
 	}
 


