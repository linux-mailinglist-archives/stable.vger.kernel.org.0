Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2832EA061
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfJ3P4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfJ3P4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:56:08 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D89217D9;
        Wed, 30 Oct 2019 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450968;
        bh=eK03D9qDn2tTGcCq3GV9jpYR+3ahyJ+u39Vf1XxYdwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn86h3Se8QUA3zxnXm68w/WTO0NbcgK3tKjsRVWKPNXjszDllGJw7UzXKX9FmrgSr
         hI0TzbpeLn8DCqcMda+r7FwBr5LSJNUTqS+3L2kgwnwpCVlMh2HZiMbRD/3rPe5+ve
         4k/arD3WNzPvS3AGA2cEfeKQk6aIagRFIXp1lvPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 05/24] ASoc: rockchip: i2s: Fix RPM imbalance
Date:   Wed, 30 Oct 2019 11:55:36 -0400
Message-Id: <20191030155555.10494-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155555.10494-1-sashal@kernel.org>
References: <20191030155555.10494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit b1e620e7d32f5aad5353cc3cfc13ed99fea65d3a ]

If rockchip_pcm_platform_register() fails, e.g. upon deferring to wait
for an absent DMA channel, we return without disabling RPM, which makes
subsequent re-probe attempts scream with errors about the unbalanced
enable. Don't do that.

Fixes: ebb75c0bdba2 ("ASoC: rockchip: i2s: Adjust devm usage")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/bcb12a849a05437fb18372bc7536c649b94bdf07.1570029862.git.robin.murphy@arm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 66fc13a2396a0..0e07e3dea7de4 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -676,7 +676,7 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 	ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register PCM\n");
-		return ret;
+		goto err_suspend;
 	}
 
 	return 0;
-- 
2.20.1

