Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5632E4228
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437239AbgL1PRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437237AbgL1OD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4E69207B6;
        Mon, 28 Dec 2020 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164197;
        bh=FhgL4NSFiftiIalFpRGQKVHGGB5E5Yh+LOmWqffFtCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdZYAg1Cpp8Vsc3fIs6Mux5fm96i1wm/eEZGnHTUGXZrxHJ3Dno0mTehQJlpwUnx0
         z/MoqzQOjiqMWIRtZepyDd5UzR35h0BbDix3CPKZUOscSVQucsoQT5LbEQYGab6Ton
         KrJ92DtSx7YZHIbGL5cSyqCecUgmeSzCa2c0mceY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/717] ASoC: wm8998: Fix PM disable depth imbalance on error
Date:   Mon, 28 Dec 2020 13:41:33 +0100
Message-Id: <20201228125025.527830427@linuxfoundation.org>
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
index f6c5cc80c970b..5413254295b70 100644
--- a/sound/soc/codecs/wm8998.c
+++ b/sound/soc/codecs/wm8998.c
@@ -1375,7 +1375,7 @@ static int wm8998_probe(struct platform_device *pdev)
 
 	ret = arizona_init_spk_irqs(arizona);
 	if (ret < 0)
-		return ret;
+		goto err_pm_disable;
 
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &soc_component_dev_wm8998,
@@ -1390,6 +1390,8 @@ static int wm8998_probe(struct platform_device *pdev)
 
 err_spk_irqs:
 	arizona_free_spk_irqs(arizona);
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }
-- 
2.27.0



