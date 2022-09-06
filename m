Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E255AEB16
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiIFNu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbiIFNs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:48:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8FA7F27D;
        Tue,  6 Sep 2022 06:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98E11CE1780;
        Tue,  6 Sep 2022 13:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA4EC433D7;
        Tue,  6 Sep 2022 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471503;
        bh=Zk48IUKtQINSipB806vFhlCrnAEYhLzY44m4JbLhUNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QK0thbc/mNB79dn6HfQ2YoRxFUNQbf+eLye4USFCoA2panTlA9V8sFxS7EUJ/bip9
         39Hms+r0YWhtIQ3vpN32BugWQmtR/AsMne4eQdgKEheURD9DefeUnZ+HGDll5wje55
         orLgzsfNu1o1AGTXl5ywkKcx2L5241PAjIeV3xMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 048/107] cifs: fix small mempool leak in SMB2_negotiate()
Date:   Tue,  6 Sep 2022 15:30:29 +0200
Message-Id: <20220906132823.873166010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 27893dfc1285f80f80f46b3b8c95f5d15d2e66d0 upstream.

In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
the request is sent, the checks would return -EIO when they should be
rather setting rc = -EIO and jumping to neg_exit to free the response
buffer from mempool.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -933,16 +933,17 @@ SMB2_negotiate(const unsigned int xid, s
 	} else if (rc != 0)
 		goto neg_exit;
 
+	rc = -EIO;
 	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb311_operations;
@@ -953,7 +954,7 @@ SMB2_negotiate(const unsigned int xid, s
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb21_operations;
@@ -967,7 +968,7 @@ SMB2_negotiate(const unsigned int xid, s
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
 				le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
@@ -985,9 +986,10 @@ SMB2_negotiate(const unsigned int xid, s
 	else {
 		cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
 				le16_to_cpu(rsp->DialectRevision));
-		rc = -EIO;
 		goto neg_exit;
 	}
+
+	rc = 0;
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	/*


