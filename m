Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138BD48DE22
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiAMTfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:35:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiAMTfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 14:35:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48B5AB82346;
        Thu, 13 Jan 2022 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E5CC36AEB;
        Thu, 13 Jan 2022 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642102521;
        bh=wYviKH9qH01/t9E4TtjTCCpdE0iv7ux6iBNVX8pYgIo=;
        h=From:To:Cc:Subject:Date:From;
        b=N6REC3rp+dUrAXlbK8nIB/9a4BxlbPU+N0eHfxlmqRsVs9zr87tezylMIO4zkSCKU
         iEVJ8PO2UzWtLIYvuwlrrhwfcDLijfUC/Jr0XglvM1mgpTeK+t0SXBu93ZU54ckiPj
         FcfyHKmWr6vgi03ZzdNOma4GHBBPf81N8LUsJtiMggXiMxJrqr+YJPvRKq16ucNu5a
         Vv8yyXfTL0X9rXTWJMwOpdUpjSxH8KYS9XoBTdsMt0VId2rWVzcpZloLoN8V3bssOB
         b8fkwN31xwL6rR1n9W1/ZgsP5iwi4Vpg8+58Ot9jCGJhs3ZitVRRcjMjsjGCJs67my
         blDKqJEJ7ZmEA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     keyrings@vger.kernel.org,
        Andrzej Zaborowski <andrew.zaborowski@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Thu, 13 Jan 2022 11:34:35 -0800
Message-Id: <20220113193435.64281-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The pkcs1pad template can be instantiated with an arbitrary akcipher
algorithm, which doesn't make sense; it is specifically an RSA padding
scheme.  Make it check that the underlying algorithm really is RSA.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8ac3e73e8ea6..1b3545781425 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -621,6 +621,11 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	rsa_alg = crypto_spawn_akcipher_alg(&ctx->spawn);
 
+	if (strcmp(rsa_alg->base.cra_name, "rsa") != 0) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	hash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name)) {

base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59
-- 
2.34.1

