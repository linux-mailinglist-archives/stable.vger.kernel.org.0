Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29726865E5
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 13:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjBAMZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 07:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjBAMZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 07:25:23 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845A447403
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 04:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=/gS+o52Nxg0TkWEyh5LB7+Cdq/QCMDiQwBueylw1go4=; b=uD62bWS4ted3NH9SrMUGEIG8NE
        k0IhVofaOJkq1yV7w1XqtAW/E1wv1KrAdyrELcXe4FTyzgLeSZhWjTp/2eipmVxLAUn8bJIv/iMYR
        ER7cJyeMmc2ROnzpb30GReSLc6FtFUhKX/TZUzcNn4rgysiaGjm5yxYWhwY5MZyj0R/Uiu2CLsr3Z
        rG8PFwF+xwF8MYmUWOtNdoEYuEs1pUmWRO8ibfqVgDXORtHD/E0oMr9LD2Z38yYZXKZTtG9Zi+Ltj
        ChOF7H2KN76yMdsTUxV60Ps+QEJDcRqf9r/bH9Y4QJlc6lJF+pWwWEHZg7rFXa5pCfBqg04BOMw4+
        WLTzjQu9DhySRzjoVgWdPTQd4yZCf3qfw3vuseTxLaq194E2Ga+KKp0kxlcnhQj+B5jkG2ePjLPeD
        kXg+pYlAtckLVbXAA3q14LL+A+ihE2rBSy/4IYxUxs/Odj+eSWziH/V7QTqngQaylZMYrT6EHTUc7
        i5+C5C4Q4JAl+hV4D0pJ38BB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNBry-00BE6R-Iv; Wed, 01 Feb 2023 12:05:42 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] cifs: don't try to use rdma offload on encrypted connections
Date:   Wed,  1 Feb 2023 13:04:43 +0100
Message-Id: <ef05bf50cbcd09fee2fc3f85be590b48f3d7f1a6.1675252643.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1675252643.git.metze@samba.org>
References: <cover.1675252643.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The aim of using encryption on a connection is to keep
the data confidential, so we must not use plaintext rdma offload
for that data!

It seems that current windows servers and ksmbd would allow
this, but that's no reason to expose the users data in plaintext!
And servers hopefully reject this in future.

Note modern windows servers support signed or encrypted offload,
see MS-SMB2 2.2.3.1.6 SMB2_RDMA_TRANSFORM_CAPABILITIES, but we don't
support that yet.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 fs/cifs/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6a4d621241dd..c5cb2639b3f1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4081,6 +4081,10 @@ static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
 	if (server->sign)
 		return false;
 
+	/* we don't support encrypted offload yet */
+	if (smb3_encryption_required(tcon))
+		return false;
+
 	/* offload also has its overhead, so only do it if desired */
 	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
 		return false;
-- 
2.34.1

