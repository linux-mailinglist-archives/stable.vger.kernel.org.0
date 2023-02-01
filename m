Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7CC686A25
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 16:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjBAPXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 10:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjBAPWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 10:22:45 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8A373756;
        Wed,  1 Feb 2023 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=/gS+o52Nxg0TkWEyh5LB7+Cdq/QCMDiQwBueylw1go4=; b=UsCJF2/D33Dz7Ve/J76UgOx5lI
        a5NRV+Xu38x6OaYNh1pTzLLHTab1CM1S20mXz8ai1Fp2gS08skLJErOkAbHGZDd7LUMpuKr39t+KQ
        tEYBpQqws63oqEgUWqSfY5ILgO+zAJSpRFl7KqMsJO2431RSWPC/Uwsee/0WQETfulbqa83m7PYEg
        Huh89eornzWzB78chAlZ4RSytooVJJq+4GHSGLokPo1xiJ53XkODfUhAsgBUP50FFXfzBuKT2LCdi
        isO7YtgopheKc73iPve48Akoq/QmoS90XHv1mWDzxYHe/siCebOlcLcAY1cv3RsgjcXo9Y0lpXo6p
        tFJmnwRAFIgEvu8Yk4MwOI9ytcOASTiHrEKzGjrk1PFX8+B1T1DulOhjjsMeGjcoLhleZe/VesBhJ
        ZJkosSmDQr05kt31UyzKmjpHqmJSj5iksE7yYOJuZt5X7ZJ7Acwon1iFPLdQHApLSw7xJgkqELCni
        w957rjgP3fmbkZmWIqgsHNJN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNEwC-00BFaB-O5; Wed, 01 Feb 2023 15:22:16 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/3] cifs: don't try to use rdma offload on encrypted connections
Date:   Wed,  1 Feb 2023 16:21:41 +0100
Message-Id: <cd26594054b0c291e01b1da20f974245d3f494c3.1675264648.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1675264648.git.metze@samba.org>
References: <cover.1675264648.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

