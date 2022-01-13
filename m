Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340CC48E149
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 00:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbiAMX4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 18:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiAMX4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 18:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8D6C061574;
        Thu, 13 Jan 2022 15:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C027461CF1;
        Thu, 13 Jan 2022 23:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF986C36AE3;
        Thu, 13 Jan 2022 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642118191;
        bh=Mp6gbaL894zOeNPb9/NhECPfC4xl3NlRjbmF7UoF8Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPG0e1lMdt7gHmBTJttZearTWDJuRYa1IawM1GtNWyuoVQmqmZoOgsc6/+P1e5RxO
         zXjV+i9zqOAscI/JKVulAAnUoi9Q9qcU+kIPHx6BMwL9sgL8Q+FgORgzHEN4EoEr+3
         9NY32XWfjvV2FT11+COIyHdbbsTC6CXNPnGvE8UoZerhUtxoydHxlIpqdMTl8f5U58
         3tThZhCce32q0Fvtql3TOKteDFsp1gEktdLR4nd5OKsiYOEVy8IaDMoxPeLYPRx4ey
         USoPf9QaooiFZGi15ab1XuWnd0Y56+BLSrvRs/9UPsKSItI0oUm52OZie9GIY/N86m
         cL1Nc7ufANswQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Denis Kenzior <denkenz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in extract_key_parameters()
Date:   Thu, 13 Jan 2022 15:54:38 -0800
Message-Id: <20220113235440.90439-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113235440.90439-1-ebiggers@kernel.org>
References: <20220113235440.90439-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

extract_key_parameters() can read past the end of the input buffer due
to buggy and missing bounds checks.  Fix it as follows:

- Before reading each key length field, verify that there are at least 4
  bytes remaining.

- Avoid integer overflows when validating size fields; 'sz + 12' and
  '4 + sz' overflowed if 'sz' is near U32_MAX.

- Before saving the pointer to the public key, check that it doesn't run
  past the end of the buffer.

Fixes: f8c54e1ac4b8 ("KEYS: asym_tpm: extract key size & public key [ver #2]")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/asym_tpm.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 0959613560b9..60d20d44c885 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -814,7 +814,6 @@ static int extract_key_parameters(struct tpm_key *tk)
 {
 	const void *cur = tk->blob;
 	uint32_t len = tk->blob_len;
-	const void *pub_key;
 	uint32_t sz;
 	uint32_t key_len;
 
@@ -845,14 +844,14 @@ static int extract_key_parameters(struct tpm_key *tk)
 		return -EBADMSG;
 
 	sz = get_unaligned_be32(cur + 8);
-	if (len < sz + 12)
-		return -EBADMSG;
 
 	/* Move to TPM_RSA_KEY_PARMS */
-	len -= 12;
 	cur += 12;
+	len -= 12;
 
 	/* Grab the RSA key length */
+	if (len < 4)
+		return -EBADMSG;
 	key_len = get_unaligned_be32(cur);
 
 	switch (key_len) {
@@ -866,29 +865,36 @@ static int extract_key_parameters(struct tpm_key *tk)
 	}
 
 	/* Move just past TPM_KEY_PARMS */
+	if (len < sz)
+		return -EBADMSG;
 	cur += sz;
 	len -= sz;
 
 	if (len < 4)
 		return -EBADMSG;
-
 	sz = get_unaligned_be32(cur);
-	if (len < 4 + sz)
-		return -EBADMSG;
+	cur += 4;
+	len -= 4;
 
 	/* Move to TPM_STORE_PUBKEY */
-	cur += 4 + sz;
-	len -= 4 + sz;
+	if (len < sz)
+		return -EBADMSG;
+	cur += sz;
+	len -= sz;
 
 	/* Grab the size of the public key, it should jive with the key size */
+	if (len < 4)
+		return -EBADMSG;
 	sz = get_unaligned_be32(cur);
+	cur += 4;
+	len -= 4;
 	if (sz > 256)
 		return -EINVAL;
-
-	pub_key = cur + 4;
+	if (len < sz)
+		return -EBADMSG;
 
 	tk->key_len = key_len;
-	tk->pub_key = pub_key;
+	tk->pub_key = cur;
 	tk->pub_key_len = sz;
 
 	return 0;
-- 
2.34.1

