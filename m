Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0436CC486
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjC1PFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjC1PFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA9E055
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF3BCB81D78
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29070C433D2;
        Tue, 28 Mar 2023 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015839;
        bh=kZ0lxMcCD2KgU5i3G2fiSNndQERm1XYuJUfZUivf2N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+UT92u8wYx/ikeSBS396Bgeqksu1cJusWqGLJcRXkUO/uh0TjjGv3TxYsZ+e3N7k
         XBjLbdWcsPiTJXx9RJBpPL41zmy9FYrqJEFzI9Va9FZOCQol17arJNTXjwEhLtTres
         wELxBfBwtoGloKu/WCqmfTKS2UVqBzLkPGF5sAjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve French <stfrench@microsoft.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 195/224] ksmbd: return unsupported error on smb1 mount
Date:   Tue, 28 Mar 2023 16:43:11 +0200
Message-Id: <20230328142625.506236842@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 39b291b86b5988bf8753c3874d5c773399d09b96 upstream.

ksmbd disconnect connection when mounting with vers=smb1.
ksmbd should send smb1 negotiate response to client for correct
unsupported error return. This patch add needed SMB1 macros and fill
NegProt part of the response for smb1 negotiate response.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    7 ++-----
 fs/ksmbd/smb_common.c |   23 ++++++++++++++++++++---
 fs/ksmbd/smb_common.h |   30 ++++++++----------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -319,13 +319,10 @@ int ksmbd_conn_handler_loop(void *p)
 		}
 
 		/*
-		 * Check if pdu size is valid (min : smb header size,
-		 * max : 0x00FFFFFF).
+		 * Check maximum pdu size(0x00FFFFFF).
 		 */
-		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
-		    pdu_size > MAX_STREAM_PROT_LEN) {
+		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
-		}
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct k
 {
 	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
 
-	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
-	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
-	return -EINVAL;
+	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
+
+	/*
+	 * Remove 4 byte direct TCP header, add 2 byte bcc and
+	 * 2 byte DialectIndex.
+	 */
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
+	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
+
+	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
+	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
+	neg_rsp->hdr.Flags = SMBFLG_RESPONSE;
+	neg_rsp->hdr.Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
+		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
+
+	neg_rsp->hdr.WordCount = 1;
+	neg_rsp->DialectIndex = cpu_to_le16(work->conn->dialect);
+	neg_rsp->ByteCount = 0;
+	return 0;
 }
 
 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -158,8 +158,15 @@
 
 #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
-
 #define SMB1_CLIENT_GUID_SIZE		(16)
+
+#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
+
+#define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
+#define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
+#define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
+#define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
+
 struct smb_hdr {
 	__be32 smb_buf_length;
 	__u8 Protocol[4];
@@ -199,28 +206,7 @@ struct smb_negotiate_req {
 struct smb_negotiate_rsp {
 	struct smb_hdr hdr;     /* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__u8 SecurityMode;
-	__le16 MaxMpxCount;
-	__le16 MaxNumberVcs;
-	__le32 MaxBufferSize;
-	__le32 MaxRawSize;
-	__le32 SessionKey;
-	__le32 Capabilities;    /* see below */
-	__le32 SystemTimeLow;
-	__le32 SystemTimeHigh;
-	__le16 ServerTimeZone;
-	__u8 EncryptionKeyLength;
 	__le16 ByteCount;
-	union {
-		unsigned char EncryptionKey[8]; /* cap extended security off */
-		/* followed by Domain name - if extended security is off */
-		/* followed by 16 bytes of server GUID */
-		/* then security blob if cap_extended_security negotiated */
-		struct {
-			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[1];
-		} __packed extended_response;
-	} __packed u;
 } __packed;
 
 struct filesystem_attribute_info {


