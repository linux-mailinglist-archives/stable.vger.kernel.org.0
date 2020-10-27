Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77DF29C160
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775792AbgJ0OxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772587AbgJ0OuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90F620709;
        Tue, 27 Oct 2020 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810221;
        bh=UXWVw92xD2IiNl8i0Lbk5m04/x79jJuEpl26RVJC2EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F59iYNgkXt1CP1zQ54wOu1e1qs3KqM20OguD50fX4Xaf6OgnwIBesY19b8v/IBMPo
         7BTVTCH4ZLWHj1t1x6Jmz3NRF/QXwMe/22KiU+CntRASxuJYRcQPnL8E8MF0QpdcD3
         S9TFXCWdaBPy8tn0CMuUd82ZMcolOlpIckRMcGUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.8 063/633] cifs: Return the error from crypt_message when enc/dec key not found.
Date:   Tue, 27 Oct 2020 14:46:46 +0100
Message-Id: <20201027135525.652582033@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 0bd294b55a5de442370c29fa53bab17aef3ff318 upstream.

In crypt_message, when smb2_get_enc_key returns error, we need to
return the error back to the caller. If not, we end up processing
the message further, causing a kernel oops due to unwarranted access
of memory.

Call Trace:
smb3_receive_transform+0x120/0x870 [cifs]
cifs_demultiplex_thread+0xb53/0xc20 [cifs]
? cifs_handle_standard+0x190/0x190 [cifs]
kthread+0x116/0x130
? kthread_park+0x80/0x80
ret_from_fork+0x1f/0x30

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3924,7 +3924,7 @@ crypt_message(struct TCP_Server_Info *se
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
 			 enc ? "en" : "de");
-		return 0;
+		return rc;
 	}
 
 	rc = smb3_crypto_aead_allocate(server);


