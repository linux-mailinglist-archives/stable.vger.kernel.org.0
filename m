Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D04371CCC
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhECQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234401AbhECQxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7074B61958;
        Mon,  3 May 2021 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060123;
        bh=zdyythD21HvJgoFCj/9ADYkiuDf0zulSgc++zqebsM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heYlbIjWjziNCi8v6z4XxiRaz1XJQnqQHniHAun5EMoIb89MD4XUf7pRsKaMJX+h9
         T+n3f2D8DkTZZIBZM7VnNCmBsRU8fl8j6MkK48P+jPMLEsODr4XX26yEr4PdIL4IZx
         pc/jcon9V42i15LdkCzSlkofClgB0hUD9bxDTZu7PqX+/ta8sli/L+z7dTPpIvbFe+
         8U8TerF8N2vWsW103VU9baWjTOILAFXl5CYwCw1xj+YhX5yx0YV2sjl9Zs1j+80mRR
         BbTpGbVYg0RAAH3h7LVZdEyyD/MRJaT2mBLSIYGvoIHv5kKKgs0zE6z+kpAiMWGzlC
         Ku1UQC2KX9I5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/35] s390/archrandom: add parameter check for s390_arch_random_generate
Date:   Mon,  3 May 2021 12:41:09 -0400
Message-Id: <20210503164109.2853838-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 28096067686c5a5cbd4c35b079749bd805df5010 ]

A review of the code showed, that this function which is exposed
within the whole kernel should do a parameter check for the
amount of bytes requested. If this requested bytes is too high
an unsigned int overflow could happen causing this function to
try to memcpy a really big memory chunk.

This is not a security issue as there are only two invocations
of this function from arch/s390/include/asm/archrandom.h and both
are not exposed to userland.

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/arch_random.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index dd95cdbd22ce..4cbb4b6d85a8 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -53,6 +53,10 @@ static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
 {
+	/* max hunk is ARCH_RNG_BUF_SIZE */
+	if (nbytes > ARCH_RNG_BUF_SIZE)
+		return false;
+
 	/* lock rng buffer */
 	if (!spin_trylock(&arch_rng_lock))
 		return false;
-- 
2.30.2

