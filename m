Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A6395C49
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhEaNbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhEaN3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F63C6141C;
        Mon, 31 May 2021 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467345;
        bh=AntsJn5K1JGcw8CHzaMqfPpszhE8EdYJ8zX/JaKVMzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGb8ZNw9eo5TUPspZGPBr5fnI6SF5l7ORqwu8JCNUusW492/MxRFqV4zR08T4xH8G
         e1KEgUjLU7a/kXXU5rGWtMKUKYtDf52p6hRcjvwCpY8MSQq/5/5lJNvfwopvxxU8u4
         T88sEn1OZs/ohaMuLS0w8jPJgWt6JeFc0v11XW3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 004/116] cifs: set server->cipher_type to AES-128-CCM for SMB3.0
Date:   Mon, 31 May 2021 15:13:00 +0200
Message-Id: <20210531130640.285446333@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit 6d2fcfe6b517fe7cbf2687adfb0a16cdcd5d9243 upstream.

SMB3.0 doesn't have encryption negotiate context but simply uses
the SMB2_GLOBAL_CAP_ENCRYPTION flag.

When that flag is present in the neg response cifs.ko uses AES-128-CCM
which is the only cipher available in this context.

cipher_type was set to the server cipher only when parsing encryption
negotiate context (SMB3.1.1).

For SMB3.0 it was set to 0. This means cipher_type value can be 0 or 1
for AES-128-CCM.

Fix this by checking for SMB3.0 and encryption capability and setting
cipher_type appropriately.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -791,6 +791,13 @@ SMB2_negotiate(const unsigned int xid, s
 	/* Internal types */
 	server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
 
+	/*
+	 * SMB3.0 supports only 1 cipher and doesn't have a encryption neg context
+	 * Set the cipher type manually.
+	 */
+	if (server->dialect == SMB30_PROT_ID && (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
+
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
 					       (struct smb2_sync_hdr *)rsp);
 	/*


