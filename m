Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C012E421E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437149AbgL1OD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437147AbgL1OD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241042063A;
        Mon, 28 Dec 2020 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164191;
        bh=IenCtjW8f0OaR6AvdVX/H0MYaKeqgP2awSBAtDkT5bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nshB7PMXapCTKCn9A+18VSXUyfJPnyatKpnGSC+nbk+EYbxbQou6zpLS/OUShbG/S
         SwPcS842xeWWIhW0S6/nPclWnE7cCkAZl1X5AzWuLiwzmfk0GKHw8Xs0OjhwxqBxFn
         hSOLtA1DshMyU3NiT20hzIHzGHTo8w/HIN/WsJ48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/717] ASoC: wm8994: Fix PM disable depth imbalance on error
Date:   Mon, 28 Dec 2020 13:41:32 +0100
Message-Id: <20201228125025.480001876@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b8161cbe55a1892a19a318eaebbda92438fa708c ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Fixes: 57e265c8d71fb ("ASoC: wm8994: Move runtime PM init to platform device init")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20201111041326.1257558-2-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index fc9ea198ac799..f57884113406b 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4645,8 +4645,12 @@ static int wm8994_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	return devm_snd_soc_register_component(&pdev->dev, &soc_component_dev_wm8994,
+	ret = devm_snd_soc_register_component(&pdev->dev, &soc_component_dev_wm8994,
 			wm8994_dai, ARRAY_SIZE(wm8994_dai));
+	if (ret < 0)
+		pm_runtime_disable(&pdev->dev);
+
+	return ret;
 }
 
 static int wm8994_remove(struct platform_device *pdev)
-- 
2.27.0



