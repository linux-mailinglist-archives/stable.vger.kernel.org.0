Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E321D15ADB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfEGFk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728317AbfEGFk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B489B214AE;
        Tue,  7 May 2019 05:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207626;
        bh=vHZe3uduaFSrPSwGHGXSIurZ6mFW3HgdPpMWiMpWwxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tH46lFajqXfjyVjNf+etMMQ2e+VLoAoOPtxPS8HSJ58k3IzvESr4n84VpxlsfZ0SJ
         nqXuvNoHQ0qa5BVXS8jDSF7WOg/tLZUkoxJmntSjgLJfEzHDHcvGDMSmoUwTiJvJa0
         esJGHb1XH7adwPDAlSxjCtzihYSqVuMUH9I8PzR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 64/95] crypto: testmgr - add AES-CFB tests
Date:   Tue,  7 May 2019 01:37:53 -0400
Message-Id: <20190507053826.31622-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

[ Upstream commit 7da66670775d201f633577f5b15a4bbeebaaa2b0 ]

Add AES128/192/256-CFB testvectors from NIST SP800-38A.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 crypto/tcrypt.c  |  5 ++++
 crypto/testmgr.c |  7 +++++
 crypto/testmgr.h | 76 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f7affe7cf0b4..76df552f099b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1099,6 +1099,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		ret += tcrypt_test("xts(aes)");
 		ret += tcrypt_test("ctr(aes)");
 		ret += tcrypt_test("rfc3686(ctr(aes))");
+		ret += tcrypt_test("cfb(aes)");
 		break;
 
 	case 11:
@@ -1422,6 +1423,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				speed_template_16_24_32);
 		test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
+		test_cipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_cipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
 		break;
 
 	case 201:
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d91278c01ea8..e65c8228ea47 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2631,6 +2631,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.dec = __VECS(aes_ccm_dec_tv_template)
 			}
 		}
+	}, {
+		.alg = "cfb(aes)",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = __VECS(aes_cfb_tv_template)
+		},
 	}, {
 		.alg = "chacha20",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 12835f072614..5bd9c1400fee 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -16071,6 +16071,82 @@ static const struct cipher_testvec aes_cbc_dec_tv_template[] = {
 	},
 };
 
+static const struct cipher_testvec aes_cfb_tv_template[] = {
+	{ /* From NIST SP800-38A */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\xc8\xa6\x45\x37\xa0\xb3\xa9\x3f"
+			  "\xcd\xe3\xcd\xad\x9f\x1c\xe5\x8b"
+			  "\x26\x75\x1f\x67\xa3\xcb\xb1\x40"
+			  "\xb1\x80\x8c\xf1\x87\xa4\xf4\xdf"
+			  "\xc0\x4b\x05\x35\x7c\x5d\x1c\x0e"
+			  "\xea\xc4\xc6\x6f\x9f\xf7\xf2\xe6",
+		.len	= 64,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
+			  "\x34\xc2\x59\x09\xc9\x9a\x41\x74"
+			  "\x67\xce\x7f\x7f\x81\x17\x36\x21"
+			  "\x96\x1a\x2b\x70\x17\x1d\x3d\x7a"
+			  "\x2e\x1e\x8a\x1d\xd5\x9b\x88\xb1"
+			  "\xc8\xe6\x0f\xed\x1e\xfa\xc4\xc9"
+			  "\xc0\x5f\x9f\x9c\xa9\x83\x4f\xa0"
+			  "\x42\xae\x8f\xba\x58\x4b\x09\xff",
+		.len	= 64,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
+			  "\x7e\xcd\x84\x86\x98\x5d\x38\x60"
+			  "\x39\xff\xed\x14\x3b\x28\xb1\xc8"
+			  "\x32\x11\x3c\x63\x31\xe5\x40\x7b"
+			  "\xdf\x10\x13\x24\x15\xe5\x4b\x92"
+			  "\xa1\x3e\xd0\xa8\x26\x7a\xe2\xf9"
+			  "\x75\xa3\x85\x74\x1a\xb9\xce\xf8"
+			  "\x20\x31\x62\x3d\x55\xb1\xe4\x71",
+		.len	= 64,
+	},
+};
+
 static const struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
 	{ /* Input data from RFC 2410 Case 1 */
 #ifdef __LITTLE_ENDIAN
-- 
2.20.1

