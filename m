Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5BC3A8465
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhFOPuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFOPuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FFBE6162C;
        Tue, 15 Jun 2021 15:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772112;
        bh=/4qA9Gz7Yw2MDT2xfMW43+5+10S3nLL/FwGV37M7M2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6K3bOM4kObnFHUaxIDfDygQEDveSq1Jcl5hQWC+rdi2+YhMiO3lxp5xR40mntPsp
         /iYgz2Wqpnm2qPnKsoe3PiJZlKadz5sU1/bPKwjtEZ/YRMXbllg3K7Jj7IW49tCJdc
         FUYoLh6tWAmlvkNFgRx5bgV3Gf9S5mIHcXu77QhiILheEdjnJJGa546iG0Bz/ZmTBv
         qfH3nSxIoFb43XYXmEF41uLYJrotwLxCBfbjUNgn+FKgdPdlwtsjnurci7okA6T8+2
         hGvjjsHR2znRHq3SyfjsqdOck0RI+7Ku5YNURh4VoEj5EQvuXT9+ogXtsPDK5IpJ3k
         TGmS0JBba8zmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 06/33] phy: phy-mtk-tphy: Fix some resource leaks in mtk_phy_init()
Date:   Tue, 15 Jun 2021 11:47:57 -0400
Message-Id: <20210615154824.62044-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit aaac9a1bd370338ce372669eb9a6059d16b929aa ]

Use clk_disable_unprepare() in the error path of mtk_phy_init() to fix
some resource leaks.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1621420659-15858-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-tphy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/mediatek/phy-mtk-tphy.c b/drivers/phy/mediatek/phy-mtk-tphy.c
index cdbcc49f7115..731c483a04de 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -949,6 +949,8 @@ static int mtk_phy_init(struct phy *phy)
 		break;
 	default:
 		dev_err(tphy->dev, "incompatible PHY type\n");
+		clk_disable_unprepare(instance->ref_clk);
+		clk_disable_unprepare(instance->da_ref_clk);
 		return -EINVAL;
 	}
 
-- 
2.30.2

