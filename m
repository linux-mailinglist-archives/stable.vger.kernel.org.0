Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF72E1681
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgLWCTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgLWCTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DD5F229C5;
        Wed, 23 Dec 2020 02:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689952;
        bh=y4Yf4nMDHlDva8VK0qSvEb9qVjG00BlVP8FH46u0Dxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCGYjBhhwooxJFexTLNgGbS3AWqR5w1Dy0j0yJ5BOqFYaq1iU0uSrq8RAtv9glwEW
         oh42Of0QadGADEW6+dl3+T38yYe35Moxx2FGVAdARve5+YKUJ6cm+TbnqERRM2K3os
         bwYw8jVulvWLhu4eN4Q66RrwAxI6MPBBjsB/yYL5ynbYico+cpRSerKZZi/J9s/0Yh
         uedyOlWNgl5ZpukYJ3x9I1NlBGUVHRM1YnbdpvKC3yZMTiBigbix+k0HlvSbMk0toc
         KOYHCOkLp5Eg15Aqa3IQm+9Ps4z/lIM5O/PKvj+L/ASLg92YyE8bcBI8UK2qAS9l5y
         zr2bMBp0Mkjyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Liang <zhengliang6@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 045/130] mmc: mediatek: fix mem leak in msdc_drv_probe
Date:   Tue, 22 Dec 2020 21:16:48 -0500
Message-Id: <20201223021813.2791612-45-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Liang <zhengliang6@huawei.com>

[ Upstream commit bbba85fae44134e00c493705bd5604fd63958315 ]

It should use mmc_free_host to free mem in error patch of
msdc_drv_probe.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Link: https://lore.kernel.org/r/20201112092530.32446-1-zhengliang6@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 9d47a2bd2546b..3c11bd5a3b86c 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2242,8 +2242,10 @@ static int msdc_drv_probe(struct platform_device *pdev)
 
 	host->reset = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								"hrst");
-	if (IS_ERR(host->reset))
-		return PTR_ERR(host->reset);
+	if (IS_ERR(host->reset)) {
+		ret = PTR_ERR(host->reset);
+		goto host_free;
+	}
 
 	host->irq = platform_get_irq(pdev, 0);
 	if (host->irq < 0) {
-- 
2.27.0

