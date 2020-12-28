Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813E12E6502
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbgL1Nee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391142AbgL1Ned (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE75207B2;
        Mon, 28 Dec 2020 13:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162458;
        bh=O9qS/MAmnFhi9/af/HnY3Uf21tkvjHdUH0xv1zmydWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmjWvoxszdqRSi27Udtmi+mu8s4MQ3yRZAAUD/c6fw1g58k14dGq/DXXau+GY3OTw
         oBJoXwJTC9GHen3Ml3lj3LjqsV+vnZM7T+HPccdIySI9o6U/8hR1kB/Ok7SemEbLWI
         bvtb1uptmod6oP8CSkp9GPK0Rgkqauef6ixM3/GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 310/346] SMB3.1.1: do not log warning message if server doesnt populate salt
Date:   Mon, 28 Dec 2020 13:50:29 +0100
Message-Id: <20201228124934.778573319@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 7955f105afb6034af344038d663bc98809483cdd upstream.

In the negotiate protocol preauth context, the server is not required
to populate the salt (although it is done by most servers) so do
not warn on mount.

We retain the checks (warn) that the preauth context is the minimum
size and that the salt does not exceed DataLength of the SMB response.
Although we use the defaults in the case that the preauth context
response is invalid, these checks may be useful in the future
as servers add support for additional mechanisms.

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    7 +++++--
 fs/cifs/smb2pdu.h |   14 +++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -406,8 +406,8 @@ build_preauth_ctxt(struct smb2_preauth_n
 	pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
 	pneg_ctxt->DataLength = cpu_to_le16(38);
 	pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
-	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
-	get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
+	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_LINUX_CLIENT_SALT_SIZE);
+	get_random_bytes(pneg_ctxt->Salt, SMB311_LINUX_CLIENT_SALT_SIZE);
 	pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
 }
 
@@ -461,6 +461,9 @@ static void decode_preauth_context(struc
 	if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
 		printk_once(KERN_WARNING "server sent bad preauth context\n");
 		return;
+	} else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength)) {
+		pr_warn_once("server sent invalid SaltLength\n");
+		return;
 	}
 	if (le16_to_cpu(ctxt->HashAlgorithmCount) != 1)
 		printk_once(KERN_WARNING "illegal SMB3 hash algorithm count\n");
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -257,12 +257,20 @@ struct smb2_neg_context {
 	/* Followed by array of data */
 } __packed;
 
-#define SMB311_SALT_SIZE			32
+#define SMB311_LINUX_CLIENT_SALT_SIZE			32
 /* Hash Algorithm Types */
 #define SMB2_PREAUTH_INTEGRITY_SHA512	cpu_to_le16(0x0001)
 #define SMB2_PREAUTH_HASH_SIZE 64
 
-#define MIN_PREAUTH_CTXT_DATA_LEN	(SMB311_SALT_SIZE + 6)
+/*
+ * SaltLength that the server send can be zero, so the only three required
+ * fields (all __le16) end up six bytes total, so the minimum context data len
+ * in the response is six bytes which accounts for
+ *
+ *      HashAlgorithmCount, SaltLength, and 1 HashAlgorithm.
+ */
+#define MIN_PREAUTH_CTXT_DATA_LEN 6
+
 struct smb2_preauth_neg_context {
 	__le16	ContextType; /* 1 */
 	__le16	DataLength;
@@ -270,7 +278,7 @@ struct smb2_preauth_neg_context {
 	__le16	HashAlgorithmCount; /* 1 */
 	__le16	SaltLength;
 	__le16	HashAlgorithms; /* HashAlgorithms[0] since only one defined */
-	__u8	Salt[SMB311_SALT_SIZE];
+	__u8	Salt[SMB311_LINUX_CLIENT_SALT_SIZE];
 } __packed;
 
 /* Encryption Algorithms Ciphers */


