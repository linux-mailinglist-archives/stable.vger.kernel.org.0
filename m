Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608632E7925
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgL3NG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgL3NF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A942226A;
        Wed, 30 Dec 2020 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333481;
        bh=bDaH0qxvKMZ3wwj/g24R05lfirUzzJc70cmssiyJNZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsjOpU4v4dmECqh/bBAgVpcYCrLT7NgzavDoGvMsVBLeDeFqlx0Aw7oigvk6BlQEK
         tYVVDUFrAYiN+LAgDgFpANQY82y4m1X61Nacs34qv+gCA6oE42/9sMF3Eh3x4laJ3f
         UoKYTRHjdzpUbRJpsoUgg6wtCHiooXE+0dKCXHGW4STRPsb9QdLeTat6O8szAipuYQ
         h5jBZxwVkLcK/ZJNZ74QLn2nOLtIOJB280D1Wo7/Gucgq7ExcbBuGOrO97/g0xNkB2
         eWjzjOb7a7IG+QnEDZplXD62yGOVFjT74FrdmFwAvrVM+RG9v3qOdySUUJSE80Xd1N
         VYktHQ/aAReYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 4/8] powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
Date:   Wed, 30 Dec 2020 08:04:32 -0500
Message-Id: <20201230130436.3637579-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130436.3637579-1-sashal@kernel.org>
References: <20201230130436.3637579-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit ffa1797040c5da391859a9556be7b735acbe1242 ]

I noticed that iounmap() of msgr_block_addr before return from
mpic_msgr_probe() in the error handling case is missing. So use
devm_ioremap() instead of just ioremap() when remapping the message
register block, so the mapping will be automatically released on
probe failure.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201028091551.136400-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/mpic_msgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/mpic_msgr.c b/arch/powerpc/sysdev/mpic_msgr.c
index 280e964e1aa88..497e86cfb12e0 100644
--- a/arch/powerpc/sysdev/mpic_msgr.c
+++ b/arch/powerpc/sysdev/mpic_msgr.c
@@ -196,7 +196,7 @@ static int mpic_msgr_probe(struct platform_device *dev)
 
 	/* IO map the message register block. */
 	of_address_to_resource(np, 0, &rsrc);
-	msgr_block_addr = ioremap(rsrc.start, resource_size(&rsrc));
+	msgr_block_addr = devm_ioremap(&dev->dev, rsrc.start, resource_size(&rsrc));
 	if (!msgr_block_addr) {
 		dev_err(&dev->dev, "Failed to iomap MPIC message registers");
 		return -EFAULT;
-- 
2.27.0

