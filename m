Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8186AEC0B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjCGRvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjCGRv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0530CACBB8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F5CCB819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA39C433EF;
        Tue,  7 Mar 2023 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211160;
        bh=hPf/kPwIPaQmNn2CIkpl9z0o/IBZfAH9dySUz6Ry2KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGLjOYL6OnFMrJPOib5+cIThgN19lJgw5y3LJbWmpPvy8DGTBpgxvM/YV5yucJmg8
         dfgb3OFNBymzYV0ftaY4W/hLhhZkvb59xuLojpiAl1jTKnTsHc2u2grnffTLpNqE+Y
         x2id25MBX07OliA61jRzsQvtDzTW2Af3mwMw6YLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0773/1001] cifs: fix mount on old smb servers
Date:   Tue,  7 Mar 2023 17:59:05 +0100
Message-Id: <20230307170055.301446468@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

commit d99e86ebde2d7b3a04190f8d14de5bf6814bf10f upstream.

The client was sending rfc1002 session request packet with a wrong
length field set, therefore failing to mount shares against old SMB
servers over port 139.

Fix this by calculating the correct length as specified in rfc1002.

Fixes: d7173623bf0b ("cifs: use ALIGN() and round_up() macros")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |  104 ++++++++++++++++++++----------------------------------
 1 file changed, 40 insertions(+), 64 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2843,72 +2843,48 @@ ip_rfc1001_connect(struct TCP_Server_Inf
 	 * negprot - BB check reconnection in case where second
 	 * sessinit is sent but no second negprot
 	 */
-	struct rfc1002_session_packet *ses_init_buf;
-	unsigned int req_noscope_len;
-	struct smb_hdr *smb_buf;
-
-	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
-			       GFP_KERNEL);
-
-	if (ses_init_buf) {
-		ses_init_buf->trailer.session_req.called_len = 32;
-
-		if (server->server_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      server->server_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      DEFAULT_CIFS_CALLED_NAME,
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.calling_len = 32;
-
-		/*
-		 * calling name ends in null (byte 16) from old smb
-		 * convention.
-		 */
-		if (server->workstation_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      server->workstation_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      "LINUX_CIFS_CLNT",
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.scope1 = 0;
-		ses_init_buf->trailer.session_req.scope2 = 0;
-		smb_buf = (struct smb_hdr *)ses_init_buf;
-
-		/* sizeof RFC1002_SESSION_REQUEST with no scopes */
-		req_noscope_len = sizeof(struct rfc1002_session_packet) - 2;
-
-		/* == cpu_to_be32(0x81000044) */
-		smb_buf->smb_buf_length =
-			cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | req_noscope_len);
-		rc = smb_send(server, smb_buf, 0x44);
-		kfree(ses_init_buf);
-		/*
-		 * RFC1001 layer in at least one server
-		 * requires very short break before negprot
-		 * presumably because not expecting negprot
-		 * to follow so fast.  This is a simple
-		 * solution that works without
-		 * complicating the code and causes no
-		 * significant slowing down on mount
-		 * for everyone else
-		 */
-		usleep_range(1000, 2000);
-	}
+	struct rfc1002_session_packet req = {};
+	struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
+	unsigned int len;
+
+	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
+
+	if (server->server_RFC1001_name[0] != 0)
+		rfc1002mangle(req.trailer.session_req.called_name,
+			      server->server_RFC1001_name,
+			      RFC1001_NAME_LEN_WITH_NULL);
+	else
+		rfc1002mangle(req.trailer.session_req.called_name,
+			      DEFAULT_CIFS_CALLED_NAME,
+			      RFC1001_NAME_LEN_WITH_NULL);
+
+	req.trailer.session_req.calling_len = sizeof(req.trailer.session_req.calling_name);
+
+	/* calling name ends in null (byte 16) from old smb convention */
+	if (server->workstation_RFC1001_name[0] != 0)
+		rfc1002mangle(req.trailer.session_req.calling_name,
+			      server->workstation_RFC1001_name,
+			      RFC1001_NAME_LEN_WITH_NULL);
+	else
+		rfc1002mangle(req.trailer.session_req.calling_name,
+			      "LINUX_CIFS_CLNT",
+			      RFC1001_NAME_LEN_WITH_NULL);
+
+	/*
+	 * As per rfc1002, @len must be the number of bytes that follows the
+	 * length field of a rfc1002 session request payload.
+	 */
+	len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
+
+	smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
+	rc = smb_send(server, smb_buf, len);
 	/*
-	 * else the negprot may still work without this
-	 * even though malloc failed
+	 * RFC1001 layer in at least one server requires very short break before
+	 * negprot presumably because not expecting negprot to follow so fast.
+	 * This is a simple solution that works without complicating the code
+	 * and causes no significant slowing down on mount for everyone else
 	 */
+	usleep_range(1000, 2000);
 
 	return rc;
 }


