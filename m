Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB348DE43
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiAMTps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:45:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38202 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiAMTps (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 14:45:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4D1F61DA6;
        Thu, 13 Jan 2022 19:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4087C36AE9;
        Thu, 13 Jan 2022 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642103147;
        bh=qUIz564hA58GlcmritwUGxqMiLjCVu3CSYxmP8ZeheE=;
        h=From:To:Cc:Subject:Date:From;
        b=cpqEDmLTi1J3H7onY8OaCcJ9ZaXItc6LVmOJGUMcjrs2hCrCwco4Fdrz+2JBxRzfR
         SpigUYpylvdrLejYhJErcLlKRCzK0xP1af6o0b2U/TzJQEdh+oKh84IPGQsWt/xlOh
         TGAi6JhHgdir8rAe3VyokdAZBtMy6QdFr1hHpOtogH1zb1pklkwHtA/rv/0ZZ7aE/h
         m+rmHgTDSgr+l9dIdPimIIq59SReqlNkbSU/CZ3UR9gF27mOx76WSLdQV2N9Wy+XsQ
         /BkrhpubPPD+sBsmtH7ZHYBpySs3RD/wg3G6MzKJiTeE4CodCnXmqny6FRaad4DsFz
         xRevbhX1XeWiw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH] ima: fix reference leak in asymmetric_verify()
Date:   Thu, 13 Jan 2022 11:44:38 -0800
Message-Id: <20220113194438.69202-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Don't leak a reference to the key if its algorithm is unknown.

Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/integrity/digsig_asymmetric.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 23240d793b07..895f4b9ce8c6 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -109,22 +109,25 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 
 	pk = asymmetric_key_public_key(key);
 	pks.pkey_algo = pk->pkey_algo;
-	if (!strcmp(pk->pkey_algo, "rsa"))
+	if (!strcmp(pk->pkey_algo, "rsa")) {
 		pks.encoding = "pkcs1";
-	else if (!strncmp(pk->pkey_algo, "ecdsa-", 6))
+	} else if (!strncmp(pk->pkey_algo, "ecdsa-", 6)) {
 		/* edcsa-nist-p192 etc. */
 		pks.encoding = "x962";
-	else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
-		   !strcmp(pk->pkey_algo, "sm2"))
+	} else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
+		   !strcmp(pk->pkey_algo, "sm2")) {
 		pks.encoding = "raw";
-	else
-		return -ENOPKG;
+	} else {
+		ret = -ENOPKG;
+		goto out;
+	}
 
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
 	pks.s_size = siglen;
 	ret = verify_signature(key, &pks);
+out:
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;

base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59
-- 
2.34.1

