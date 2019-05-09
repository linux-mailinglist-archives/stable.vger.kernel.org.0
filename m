Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ADD191C4
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfEISv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfEISv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E142183E;
        Thu,  9 May 2019 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427886;
        bh=oyTjSecDC36hOUXR6U4y+GsvDs0eI8Nz8IgZeszoFVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFeKjP8kHScmtBjEFZpb5rps2+YQTsWEs+++LBvRq1gx1lz/02GxjU+BjDiHXYFXn
         jLiNC0UmMakjf11SwI2KWZBuj5LT2C/vS8LkSyLya29Co1fd60dthiIFYZbTcTpNTy
         iaEfZ7TupiIrE90EF+kdhq8Ngozg/s505lSypbc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sugar Zhang <sugar.zhang@rock-chips.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 41/95] ASoC: rockchip: pdm: fix regmap_ops hang issue
Date:   Thu,  9 May 2019 20:41:58 +0200
Message-Id: <20190509181312.254338219@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c85064435fe7a216ec0f0238ef2b8f7cd850a450 ]

This is because set_fmt ops maybe called when PD is off,
and in such case, regmap_ops will lead system hang.
enale PD before doing regmap_ops.

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 400e29edb1c9c..8a2e3bbce3a16 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -208,7 +208,9 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
+	pm_runtime_get_sync(cpu_dai->dev);
 	regmap_update_bits(pdm->regmap, PDM_CLK_CTRL, mask, val);
+	pm_runtime_put(cpu_dai->dev);
 
 	return 0;
 }
-- 
2.20.1



