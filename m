Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A374A45218B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbhKPBFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245544AbhKOTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E2B6357B;
        Mon, 15 Nov 2021 18:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001390;
        bh=PVzCkzR2KcBAtiWs5F6WH84HlpRwm8pe9mrUe2LF/w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWVGQgX5RoKtp6Rg2ZfQJdCyJUYHk1Ien+4MpxZyxOX895rjYef055piQS+kUUIrm
         XO7R0JRz1cvfBHkZIb4PAnt9TrPFRFvtA1HzxBmMVVkujLKCBkyumaggxTVyvHO7v8
         RahfN/wYohKN3M3wGAlyhppwS4OTqp5mCQiTMhVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 173/917] ksmbd: set unique value to volume serial field in FS_VOLUME_INFORMATION
Date:   Mon, 15 Nov 2021 17:54:28 +0100
Message-Id: <20211115165434.641045247@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5d2f0b1083eb158bdff01dd557e2c25046c0a7d2 upstream.

Steve French reported ksmbd set fixed value to volume serial field in
FS_VOLUME_INFORMATION. Volume serial value needs to be set to a unique
value for client fscache. This patch set crc value that is generated
with share name, path name and netbios name to volume serial.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15
Reported-by: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/Kconfig   |    1 +
 fs/ksmbd/server.c  |    1 +
 fs/ksmbd/smb2pdu.c |    9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -19,6 +19,7 @@ config SMB_SERVER
 	select CRYPTO_GCM
 	select ASN1
 	select OID_REGISTRY
+	select CRC32
 	default n
 	help
 	  Choose Y here if you want to allow SMB3 compliant clients
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -632,5 +632,6 @@ MODULE_SOFTDEP("pre: sha512");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
+MODULE_SOFTDEP("pre: crc32");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4891,11 +4891,18 @@ static int smb2_get_info_filesystem(stru
 	{
 		struct filesystem_vol_info *info;
 		size_t sz;
+		unsigned int serial_crc = 0;
 
 		info = (struct filesystem_vol_info *)(rsp->Buffer);
 		info->VolumeCreationTime = 0;
+		serial_crc = crc32_le(serial_crc, share->name,
+				      strlen(share->name));
+		serial_crc = crc32_le(serial_crc, share->path,
+				      strlen(share->path));
+		serial_crc = crc32_le(serial_crc, ksmbd_netbios_name(),
+				      strlen(ksmbd_netbios_name()));
 		/* Taking dummy value of serial number*/
-		info->SerialNumber = cpu_to_le32(0xbc3ac512);
+		info->SerialNumber = cpu_to_le32(serial_crc);
 		len = smbConvertToUTF16((__le16 *)info->VolumeLabel,
 					share->name, PATH_MAX,
 					conn->local_nls, 0);


