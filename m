Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096823C2EF5
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhGJCaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhGJC3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE84613F4;
        Sat, 10 Jul 2021 02:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883930;
        bh=1tBw5Zt9YPIrQK/9dRp5GoREl6y7xA8VRfsxmcF8F8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpqqBhtRDP1MZdvQObU42OqkWHjFjSAslm28T35diLCCnCiZrB0KxYpQrK5OqyUTw
         Vp+hPWm6S73xhcPG4sCk7caDEX2rCwN1Y97cqd+YewgOmm2FNQz/w9lUXbiHQ9Trml
         8qHPNwHpy003e+h2LiBxkCu5HoWSbtPJXhywVEa/Uq44I5Sngq4tv2vAbHmM4vrM5g
         0hxJFoXGY1PCvf+/nWdroTRk1xDvqFMxCnMQnF6+8XYosVwWrk1AEqOvYjoD/uxpZm
         OJgubjOT3o6dLiTu0XW1r+ymmN+3GYFKyhRn8nXnhszkcqzXNuEbVRlnNIK7RKR6Vw
         5RQm968xte23A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 47/93] ASoC: img: Fix PM reference leak in img_i2s_in_probe()
Date:   Fri,  9 Jul 2021 22:23:41 -0400
Message-Id: <20210710022428.3169839-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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

