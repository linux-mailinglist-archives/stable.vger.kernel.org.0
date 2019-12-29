Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C06112C86E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfL2Rym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732729AbfL2Ryk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F26B320718;
        Sun, 29 Dec 2019 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642079;
        bh=ZLwIHzi1b5Z8dT7Nzzujfrv3RFtNodl2dfwFpq/b1Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBUJMBbJlDad4JEXJvyhY9JD9AxyZPwHaFseIgZ3zfWqjYIapTPjZoaQpPGZv6WTL
         M/qP5gReYr7hbDu7bNHM1gUn/DRqeXTkJj+6Iiesl7a1KCD0HZbW4hcgEKfmaFtvlh
         9buVHPhL7oEl4fP/cYhJWTlHQNouL66fRAFOgy+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Joerg Schmidbauer <jschmidb@linux.vnet.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 334/434] s390/crypto: Fix unsigned variable compared with zero
Date:   Sun, 29 Dec 2019 18:26:27 +0100
Message-Id: <20191229172724.154790665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0398d4ab1677f7d8cd43aac2aa29a93dfcf9e2e3 ]

s390_crypto_shash_parmsize() return type is int, it
should not be stored in a unsigned variable, which
compared with zero.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 3c2eb6b76cab ("s390/crypto: Support for SHA3 via CPACF (MSA6)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Joerg Schmidbauer <jschmidb@linux.vnet.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/sha_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index d39e0f079217..686fe7aa192f 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -74,14 +74,17 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
 	u64 bits;
-	unsigned int n, mbl_offset;
+	unsigned int n;
+	int mbl_offset;
 
 	n = ctx->count % bsize;
 	bits = ctx->count * 8;
-	mbl_offset = s390_crypto_shash_parmsize(ctx->func) / sizeof(u32);
+	mbl_offset = s390_crypto_shash_parmsize(ctx->func);
 	if (mbl_offset < 0)
 		return -EINVAL;
 
+	mbl_offset = mbl_offset / sizeof(u32);
+
 	/* set total msg bit length (mbl) in CPACF parmblock */
 	switch (ctx->func) {
 	case CPACF_KLMD_SHA_1:
-- 
2.20.1



