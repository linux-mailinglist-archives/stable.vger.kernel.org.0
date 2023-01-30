Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B42B68120F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbjA3OSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbjA3ORl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2A73CE11
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21B886104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260EAC4339B;
        Mon, 30 Jan 2023 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088228;
        bh=WVLyatBJW/tzgI7JOERmnuF54z+Zc/94C9CHoOx1eRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXHUPykESKIrk8tS/NWxLTZ7a02QfUe5OXhU/ngnzDOVuNDWN3Zppz+xTkyqqV0Go
         jzueqY8UIwxb6aNqiNIfXDomjzZ+zEO2lcqprcaLXsWmb+fh1NBjLlA+VO+Blw76wX
         ezRAVTjLK97iPaoA6B3RDn/xwLI9z9GQ1EutJiGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 158/204] ksmbd: limit pdu length size according to connection status
Date:   Mon, 30 Jan 2023 14:52:03 +0100
Message-Id: <20230130134323.488865623@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 62c487b53a7ff31e322cf2874d3796b8202c54a5 upstream.

Stream protocol length will never be larger than 16KB until session setup.
After session setup, the size of requests will not be larger than
16KB + SMB2 MAX WRITE size. This patch limits these invalidly oversized
requests and closes the connection immediately.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18259
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |   17 +++++++++++++++--
 fs/ksmbd/smb2pdu.h    |    5 +++--
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -274,7 +274,7 @@ int ksmbd_conn_handler_loop(void *p)
 {
 	struct ksmbd_conn *conn = (struct ksmbd_conn *)p;
 	struct ksmbd_transport *t = conn->transport;
-	unsigned int pdu_size;
+	unsigned int pdu_size, max_allowed_pdu_size;
 	char hdr_buf[4] = {0,};
 	int size;
 
@@ -299,13 +299,26 @@ int ksmbd_conn_handler_loop(void *p)
 		pdu_size = get_rfc1002_len(hdr_buf);
 		ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
 
+		if (conn->status == KSMBD_SESS_GOOD)
+			max_allowed_pdu_size =
+				SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
+		else
+			max_allowed_pdu_size = SMB3_MAX_MSGSIZE;
+
+		if (pdu_size > max_allowed_pdu_size) {
+			pr_err_ratelimited("PDU length(%u) excceed maximum allowed pdu size(%u) on connection(%d)\n",
+					pdu_size, max_allowed_pdu_size,
+					conn->status);
+			break;
+		}
+
 		/*
 		 * Check if pdu size is valid (min : smb header size,
 		 * max : 0x00FFFFFF).
 		 */
 		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
 		    pdu_size > MAX_STREAM_PROT_LEN) {
-			continue;
+			break;
 		}
 
 		/* 4 for rfc1002 length field */
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -113,8 +113,9 @@
 #define SMB21_DEFAULT_IOSIZE	(1024 * 1024)
 #define SMB3_DEFAULT_IOSIZE	(4 * 1024 * 1024)
 #define SMB3_DEFAULT_TRANS_SIZE	(1024 * 1024)
-#define SMB3_MIN_IOSIZE	(64 * 1024)
-#define SMB3_MAX_IOSIZE	(8 * 1024 * 1024)
+#define SMB3_MIN_IOSIZE		(64 * 1024)
+#define SMB3_MAX_IOSIZE		(8 * 1024 * 1024)
+#define SMB3_MAX_MSGSIZE	(4 * 4096)
 
 /*
  * SMB2 Header Definition


