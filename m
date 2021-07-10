Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634EB3C2E2A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhGJC03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhGJCZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F68613EC;
        Sat, 10 Jul 2021 02:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883782;
        bh=1tBw5Zt9YPIrQK/9dRp5GoREl6y7xA8VRfsxmcF8F8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOEpe/HulsGkBKcjfy/0WvTWFGdB5J+x+BKAE7nOJFPBA01MWlWjlvrkKn6iDcvPK
         HrQB48wpBk/AOJeil6GgYO2t4m7VZ1G1atF2NDXe9XThCUskB7cEqzKDxj9fYPxRq8
         T7+XNhlarJ4jef3McBtnGbOv/6jBYEp+Z1oWgTw/edCAdFy1k/SsATd7XmJjaAqASV
         arymNa7lcCkFG8nGC/QqGWDXoXPtbNQMtb9S3tDym+TTkPiRJWOzXwhXayoSMsAjDW
         RG6j3OgJu+GXxFBy0gjZsziNhK3bJLBBU+NNvGdAS6ZSeUMgFCUwcAvlS08UYSGZNm
         fHldJUL+8Ck1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 050/104] ASoC: img: Fix PM reference leak in img_i2s_in_probe()
Date:   Fri,  9 Jul 2021 22:21:02 -0400
Message-Id: <20210710022156.3168825-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 81aad47278539f02de808bcc8251fed0ad3d6f55 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Link: https://lore.kernel.org/r/20210524093521.612176-1-yuyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-i2s-in.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.c
index 0843235d73c9..fd3432a1d6ab 100644
--- a/sound/soc/img/img-i2s-in.c
+++ b/sound/soc/img/img-i2s-in.c
@@ -464,7 +464,7 @@ static int img_i2s_in_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_pm_disable;
 	}
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		goto err_suspend;
 
-- 
2.30.2

