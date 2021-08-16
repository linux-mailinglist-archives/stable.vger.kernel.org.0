Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEA23ED602
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbhHPNQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239773AbhHPNOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0DE632CA;
        Mon, 16 Aug 2021 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119493;
        bh=wYjX1uIz9dY61FTl9zBi/I5MZ9p181xglzO3/KxQhHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngDIc1jxoAHCS+nGeMiwuWyb3Cv0cdIkuAjPEqm9IOhOu1vZbV5yAORID+YRo3G+S
         gttmr/WaJ+ZEb4QagH64laIFd6luZOq6NDQ/IgJXcHRHuDYtwV0huKfhQFAp/2aYHZ
         DdTg5yPNGpLx/SUidELN+92BPUZQ1T+1E3TOWueM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/151] selftests/sgx: Fix Q1 and Q2 calculation in sigstruct.c
Date:   Mon, 16 Aug 2021 15:01:17 +0200
Message-Id: <20210816125445.617826430@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 567c39047dbee341244fe3bf79fea24ee0897ff9 ]

Q1 and Q2 are numbers with *maximum* length of 384 bytes. If the
calculated length of Q1 and Q2 is less than 384 bytes, things will
go wrong.

E.g. if Q2 is 383 bytes, then

1. The bytes of q2 are copied to sigstruct->q2 in calc_q1q2().
2. The entire sigstruct->q2 is reversed, which results it being
   256 * Q2, given that the last byte of sigstruct->q2 is added
   to before the bytes given by calc_q1q2().

Either change in key or measurement can trigger the bug. E.g. an
unmeasured heap could cause a devastating change in Q1 or Q2.

Reverse exactly the bytes of Q1 and Q2 in calc_q1q2() before returning
to the caller.

Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
Link: https://lore.kernel.org/linux-sgx/20210301051836.30738-1-tianjia.zhang@linux.alibaba.com/
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/sigstruct.c | 41 +++++++++++++------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index dee7a3d6c5a5..92bbc5a15c39 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -55,10 +55,27 @@ static bool alloc_q1q2_ctx(const uint8_t *s, const uint8_t *m,
 	return true;
 }
 
+static void reverse_bytes(void *data, int length)
+{
+	int i = 0;
+	int j = length - 1;
+	uint8_t temp;
+	uint8_t *ptr = data;
+
+	while (i < j) {
+		temp = ptr[i];
+		ptr[i] = ptr[j];
+		ptr[j] = temp;
+		i++;
+		j--;
+	}
+}
+
 static bool calc_q1q2(const uint8_t *s, const uint8_t *m, uint8_t *q1,
 		      uint8_t *q2)
 {
 	struct q1q2_ctx ctx;
+	int len;
 
 	if (!alloc_q1q2_ctx(s, m, &ctx)) {
 		fprintf(stderr, "Not enough memory for Q1Q2 calculation\n");
@@ -89,8 +106,10 @@ static bool calc_q1q2(const uint8_t *s, const uint8_t *m, uint8_t *q1,
 		goto out;
 	}
 
-	BN_bn2bin(ctx.q1, q1);
-	BN_bn2bin(ctx.q2, q2);
+	len = BN_bn2bin(ctx.q1, q1);
+	reverse_bytes(q1, len);
+	len = BN_bn2bin(ctx.q2, q2);
+	reverse_bytes(q2, len);
 
 	free_q1q2_ctx(&ctx);
 	return true;
@@ -152,22 +171,6 @@ static RSA *gen_sign_key(void)
 	return key;
 }
 
-static void reverse_bytes(void *data, int length)
-{
-	int i = 0;
-	int j = length - 1;
-	uint8_t temp;
-	uint8_t *ptr = data;
-
-	while (i < j) {
-		temp = ptr[i];
-		ptr[i] = ptr[j];
-		ptr[j] = temp;
-		i++;
-		j--;
-	}
-}
-
 enum mrtags {
 	MRECREATE = 0x0045544145524345,
 	MREADD = 0x0000000044444145,
@@ -367,8 +370,6 @@ bool encl_measure(struct encl *encl)
 	/* BE -> LE */
 	reverse_bytes(sigstruct->signature, SGX_MODULUS_SIZE);
 	reverse_bytes(sigstruct->modulus, SGX_MODULUS_SIZE);
-	reverse_bytes(sigstruct->q1, SGX_MODULUS_SIZE);
-	reverse_bytes(sigstruct->q2, SGX_MODULUS_SIZE);
 
 	EVP_MD_CTX_destroy(ctx);
 	RSA_free(key);
-- 
2.30.2



