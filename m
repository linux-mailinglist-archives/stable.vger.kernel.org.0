Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6319E2E791A
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgL3NGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbgL3NFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7672229C;
        Wed, 30 Dec 2020 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333491;
        bh=33cfiLhGaMFBothKabuOH/iWOXURCY/eCLu5OMkW/Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z94Sqzqi3lb/CZ8qDieLbdfVgA1D55fEbTdtBokJZ22MGcuqP/Pa5l71MQS912RRn
         iGLPRgmbmXsE585rf6Dm96AZoIQnb05yu2gYSIA9qIM/PiemF/RG4wnPqFrxvpeO1A
         aLzWXOwfJ65JpI1P52CuZ+QVBsAdNRUdgYobVXHxolIFmIpgbjuGMM+dlSmE8fkmMm
         Ca8tIMoh9DFioI3PtjNIVq9iPmC+xMwpFTvOsx17c1frVgJmvMSzRFhJ8OH4FAD4K4
         nCl+FssZy/RWpezW9nrVhElwdPWWJOA6jd4R7EgUs4tgM5Se0LjtKNAd6TZkpQnspQ
         k+MUe3B7U8Ncg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 3/5] powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
Date:   Wed, 30 Dec 2020 08:04:45 -0500
Message-Id: <20201230130447.3637694-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130447.3637694-1-sashal@kernel.org>
References: <20201230130447.3637694-1-sashal@kernel.org>
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
index 47fb336741d43..e26552708a281 100644
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

