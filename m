Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58804095D1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241505AbhIMOph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347632AbhIMOmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721C861250;
        Mon, 13 Sep 2021 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541389;
        bh=YaizDK3+8aCcaeOv0UjPwQK6/YhwKWk2h9k12AOdSCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WEaq/LkrVlwFT6OgVZjszVtNZ4qw4nv65YES38475F0fECTQxNSCK1NxerVGHfhF
         HDQVytKM6SsBgyTGaOmC7Epjr+Ksy6d4Zxemy14h+HXmDMrfX2NoiWOVCS+xp36bvk
         KOnMBOnSqluxCw8iHJO5AP/nCDj9f06e0/XbzV/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 245/334] octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1
Date:   Mon, 13 Sep 2021 15:14:59 +0200
Message-Id: <20210913131121.684410505@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 623da5ca70b70f01cd483585f5cd4c463cf2f2da ]

RVU SMMU widget stores the final translated PA at
RVU_AF_SMMU_TLN_FLIT0<57:18> instead of FLIT1 register. This patch
fixes the address translation logic to use the correct register.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 28dcce7d575a..dbe9149a215e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -82,10 +82,10 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 		dev_err(rvu->dev, "%s LMTLINE iova transulation failed err:%llx\n", __func__, val);
 		return -EIO;
 	}
-	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT1[60:21]
+	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT0[57:18]
 	 * PA[11:0] = IOVA[11:0]
 	 */
-	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT1) >> 21;
+	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT0) >> 18;
 	pa &= GENMASK_ULL(39, 0);
 	*lmt_addr = (pa << 12) | (iova  & 0xFFF);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 8b01ef6e2c99..4215841c9f86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -53,7 +53,7 @@
 #define RVU_AF_SMMU_TXN_REQ		    (0x6008)
 #define RVU_AF_SMMU_ADDR_RSP_STS	    (0x6010)
 #define RVU_AF_SMMU_ADDR_TLN		    (0x6018)
-#define RVU_AF_SMMU_TLN_FLIT1		    (0x6030)
+#define RVU_AF_SMMU_TLN_FLIT0		    (0x6020)
 
 /* Admin function's privileged PF/VF registers */
 #define RVU_PRIV_CONST                      (0x8000000)
-- 
2.30.2



