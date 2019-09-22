Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8946BBA7FB
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392416AbfIVTAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436695AbfIVTAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AEAC21907;
        Sun, 22 Sep 2019 19:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178841;
        bh=e9BSFUibeBe+oRteLZzZcuFsV4x7EMeuZV+E0L70dd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds5So0Uq/X3sedcPqzlvj6Vuo9XEZfSlxVI9ksPfOoVSvUk6Ik1RTVFpxbaPS0JDY
         5wQxlPE4evZufPfs5lgWesdPqjCCCx4IN74rV2e6DOUfI8KMYhLJGpYXA9htSD6EaE
         FZYpPr4lHoW1YcP6mlAtdOKbhVysUD8QPTQY+tP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 49/60] s390/crypto: xts-aes-s390 fix extra run-time crypto self tests finding
Date:   Sun, 22 Sep 2019 14:59:22 -0400
Message-Id: <20190922185934.4305-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 9e323d45ba94262620a073a3f9945ca927c07c71 ]

With 'extra run-time crypto self tests' enabled, the selftest
for s390-xts fails with

  alg: skcipher: xts-aes-s390 encryption unexpectedly succeeded on
  test vector "random: len=0 klen=64"; expected_error=-22,
  cfg="random: inplace use_digest nosimd src_divs=[2.61%@+4006,
  84.44%@+21, 1.55%@+13, 4.50%@+344, 4.26%@+21, 2.64%@+27]"

This special case with nbytes=0 is not handled correctly and this
fix now makes sure that -EINVAL is returned when there is en/decrypt
called with 0 bytes to en/decrypt.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 591cbdf615af0..1a906dd7ca7d9 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -572,6 +572,9 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	if (unlikely(!xts_ctx->fc))
 		return xts_fallback_encrypt(desc, dst, src, nbytes);
 
@@ -586,6 +589,9 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	if (unlikely(!xts_ctx->fc))
 		return xts_fallback_decrypt(desc, dst, src, nbytes);
 
-- 
2.20.1

