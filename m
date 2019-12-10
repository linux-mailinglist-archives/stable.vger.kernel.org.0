Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F3119486
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfLJVNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbfLJVNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C50B6205C9;
        Tue, 10 Dec 2019 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012397;
        bh=vGhZFSEsZqCy533g7WLZ+OnLZ3qZFRbE9KzvE/bFCEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+w9wvtpHcl65h2iIDupZ0ngXqmN38V2BgXrrR0B9azZFYDCbLxkla+KDkxIUEZBX
         PjIKAFMXZQkEdo+zkVOUHM9DkXBa+/q3k29/fVLT1r7MV5a2e1gzF3dKX1MukAkkhu
         RnXiEHZ9bFxtZhx5sQqnWom8HcMtscz7ZmI7s9LQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Joerg Schmidbauer <jschmidb@linux.vnet.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 317/350] s390/crypto: Fix unsigned variable compared with zero
Date:   Tue, 10 Dec 2019 16:07:02 -0500
Message-Id: <20191210210735.9077-278-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d39e0f0792170..686fe7aa192f4 100644
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

