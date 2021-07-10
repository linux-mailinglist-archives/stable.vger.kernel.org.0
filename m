Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14373C3024
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhGJCdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhGJCbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B393D61413;
        Sat, 10 Jul 2021 02:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884067;
        bh=hau0c91h4BJ9V9i1sgzxQVHOLNVU2hgyRWuAw9aeMe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prx/qnzigWMBnlyJ2rSLOZ/5waHiX98SsZ4VDBP4ODh9VN3grlJArWu416pSPB/0s
         SjTLtv1XILZ8LJpeR+Vco7fY3vU/n0SoZtbRNuYrt2VKZtUatmM6GEmk9Fo1RxIEi6
         YK4NLPKBtaHv6y0sXkHLHdipH7K+SriuXK0lQVmi5l6mDw4wsV4xfLgIQQp5JKTbPr
         venA++bECiPoO5fcHBWJSJ0iWBSZ0QyGlvRyCEnG9lx2MttMV039DiaJrI4O5ClKwa
         ojhOuAGj8rLeCu3kuR7CyIzFAzzbG7DDX7mY4XyqB1v0EsVmUo3JCFuCbUIUGe2XE7
         /kXSn+GNerCdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 29/63] ASoC: img: Fix PM reference leak in img_i2s_in_probe()
Date:   Fri,  9 Jul 2021 22:26:35 -0400
Message-Id: <20210710022709.3170675-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index bb668551dd4b..243f916355ee 100644
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

