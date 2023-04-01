Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2036D2D57
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjDABta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjDABs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:48:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4662443A;
        Fri, 31 Mar 2023 18:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CFCBB83314;
        Sat,  1 Apr 2023 01:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0935FC433D2;
        Sat,  1 Apr 2023 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313484;
        bh=PXrgjoxCAiyTLGkdrfEmudMLRAmtP2/RRWUBN2gPaso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnzs5qR188th4L+fTvAvX2nK9S/g+dIH4TLfsm0RZ6NjnUFMle11xbIMdP8Or/ni0
         jdP2u+ACfSfT6W0Xax1eIm32+HKtdsWfnlqWSa2G0UpD2SVC5h5z1cU0LmaPqW/6Qx
         G+rIHxWDTviI1OMgzb21e5N1eh0KJ5XSl/+x0o7YU1uZ3yeX3JGcrXy/LhFFvJok7O
         1VKSlckHbQErfmN+JTTUVwbveKQg5n0ciG/wBmyhNaj4JRrDzpAaDFozYml9tALxh7
         PuyFHj0LQ29O5wBJ/k2htHZyUBknXYDw3gPQ1zyAL1Lw9Q+u+74sW3XmAMMOaFAVLR
         rytAZC1LRw02A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robbie Harwood <rharwood@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        kexec@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net
Subject: [PATCH AUTOSEL 5.4 6/6] asymmetric_keys: log on fatal failures in PE/pkcs7
Date:   Fri, 31 Mar 2023 21:44:31 -0400
Message-Id: <20230401014431.3357345-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014431.3357345-1-sashal@kernel.org>
References: <20230401014431.3357345-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robbie Harwood <rharwood@redhat.com>

[ Upstream commit 3584c1dbfffdabf8e3dc1dd25748bb38dd01cd43 ]

These particular errors can be encountered while trying to kexec when
secureboot lockdown is in place.  Without this change, even with a
signed debug build, one still needs to reboot the machine to add the
appropriate dyndbg parameters (since lockdown blocks debugfs).

Accordingly, upgrade all pr_debug() before fatal error into pr_warn().

Signed-off-by: Robbie Harwood <rharwood@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jarkko Sakkinen <jarkko@kernel.org>
cc: Eric Biederman <ebiederm@xmission.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
cc: kexec@lists.infradead.org
Link: https://lore.kernel.org/r/20230220171254.592347-3-rharwood@redhat.com/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/pkcs7_verify.c  | 10 +++++-----
 crypto/asymmetric_keys/verify_pefile.c | 24 ++++++++++++------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index ce49820caa97f..01e54450c846f 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -79,16 +79,16 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		}
 
 		if (sinfo->msgdigest_len != sig->digest_size) {
-			pr_debug("Sig %u: Invalid digest size (%u)\n",
-				 sinfo->index, sinfo->msgdigest_len);
+			pr_warn("Sig %u: Invalid digest size (%u)\n",
+				sinfo->index, sinfo->msgdigest_len);
 			ret = -EBADMSG;
 			goto error;
 		}
 
 		if (memcmp(sig->digest, sinfo->msgdigest,
 			   sinfo->msgdigest_len) != 0) {
-			pr_debug("Sig %u: Message digest doesn't match\n",
-				 sinfo->index);
+			pr_warn("Sig %u: Message digest doesn't match\n",
+				sinfo->index);
 			ret = -EKEYREJECTED;
 			goto error;
 		}
@@ -488,7 +488,7 @@ int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
 			       const void *data, size_t datalen)
 {
 	if (pkcs7->data) {
-		pr_debug("Data already supplied\n");
+		pr_warn("Data already supplied\n");
 		return -EINVAL;
 	}
 	pkcs7->data = data;
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index c43b077ba37db..0701bb161b63f 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -74,7 +74,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 		break;
 
 	default:
-		pr_debug("Unknown PEOPT magic = %04hx\n", pe32->magic);
+		pr_warn("Unknown PEOPT magic = %04hx\n", pe32->magic);
 		return -ELIBBAD;
 	}
 
@@ -95,7 +95,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	ctx->certs_size = ddir->certs.size;
 
 	if (!ddir->certs.virtual_address || !ddir->certs.size) {
-		pr_debug("Unsigned PE binary\n");
+		pr_warn("Unsigned PE binary\n");
 		return -ENODATA;
 	}
 
@@ -127,7 +127,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	unsigned len;
 
 	if (ctx->sig_len < sizeof(wrapper)) {
-		pr_debug("Signature wrapper too short\n");
+		pr_warn("Signature wrapper too short\n");
 		return -ELIBBAD;
 	}
 
@@ -142,16 +142,16 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	 * rounded up since 0.110.
 	 */
 	if (wrapper.length > ctx->sig_len) {
-		pr_debug("Signature wrapper bigger than sig len (%x > %x)\n",
-			 ctx->sig_len, wrapper.length);
+		pr_warn("Signature wrapper bigger than sig len (%x > %x)\n",
+			ctx->sig_len, wrapper.length);
 		return -ELIBBAD;
 	}
 	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
-		pr_debug("Signature is not revision 2.0\n");
+		pr_warn("Signature is not revision 2.0\n");
 		return -ENOTSUPP;
 	}
 	if (wrapper.cert_type != WIN_CERT_TYPE_PKCS_SIGNED_DATA) {
-		pr_debug("Signature certificate type is not PKCS\n");
+		pr_warn("Signature certificate type is not PKCS\n");
 		return -ENOTSUPP;
 	}
 
@@ -164,7 +164,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	ctx->sig_offset += sizeof(wrapper);
 	ctx->sig_len -= sizeof(wrapper);
 	if (ctx->sig_len < 4) {
-		pr_debug("Signature data missing\n");
+		pr_warn("Signature data missing\n");
 		return -EKEYREJECTED;
 	}
 
@@ -198,7 +198,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 		return 0;
 	}
 not_pkcs7:
-	pr_debug("Signature data not PKCS#7\n");
+	pr_warn("Signature data not PKCS#7\n");
 	return -ELIBBAD;
 }
 
@@ -341,8 +341,8 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	digest_size = crypto_shash_digestsize(tfm);
 
 	if (digest_size != ctx->digest_len) {
-		pr_debug("Digest size mismatch (%zx != %x)\n",
-			 digest_size, ctx->digest_len);
+		pr_warn("Digest size mismatch (%zx != %x)\n",
+			digest_size, ctx->digest_len);
 		ret = -EBADMSG;
 		goto error_no_desc;
 	}
@@ -373,7 +373,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	 * PKCS#7 certificate.
 	 */
 	if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
-		pr_debug("Digest mismatch\n");
+		pr_warn("Digest mismatch\n");
 		ret = -EKEYREJECTED;
 	} else {
 		pr_debug("The digests match!\n");
-- 
2.39.2

