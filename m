Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4FD2E675C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbgL1QXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:23:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbgL1NLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C58208BA;
        Mon, 28 Dec 2020 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161056;
        bh=dXkCDmG6F/mAODuZ3uIxXPadXIBMnnqmj+jRl1Z/38E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEYkk4iwC59VFKZKp/c5SYy3qyB6iTbpSXi6yKBlVOtTC7DG/1mI7kj73BSu1z3di
         YcKO7qF8580ME+gTQ+fwDgAiaQarcGe+nlusJQmEO0uV57rCPU3hWJG3PeB6hYWKSM
         l/St3lFA/5SY67Wm/HUoRG+IOKTWkuf5RVL7FKhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/242] ASoC: wm8998: Fix PM disable depth imbalance on error
Date:   Mon, 28 Dec 2020 13:48:11 +0100
Message-Id: <20201228124908.929096754@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 193aa0a043645220d2a2f783ba06ae13d4601078 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes: 31833ead95c2c ("ASoC: arizona: Move request of speaker IRQs into bus probe")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20201111041326.1257558-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8998.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8998.c b/sound/soc/codecs/wm8998.c
index 44f447136e224..a94e0aeb2e198 100644
--- a/sound/soc/codecs/wm8998.c
+++ b/sound/soc/codecs/wm8998.c
@@ -1425,7 +1425,7 @@ static int wm8998_probe(struct platform_device *pdev)
 
 	ret = arizona_init_spk_irqs(arizona);
 	if (ret < 0)
-		return ret;
+		goto err_pm_disable;
 
 	ret = snd_soc_register_codec(&pdev->dev, &soc_codec_dev_wm8998,
 				     wm8998_dai, ARRAY_SIZE(wm8998_dai));
@@ -1438,6 +1438,8 @@ static int wm8998_probe(struct platform_device *pdev)
 
 err_spk_irqs:
 	arizona_free_spk_irqs(arizona);
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }
-- 
2.27.0



