Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960A0328DC3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbhCATQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240583AbhCATMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E338765156;
        Mon,  1 Mar 2021 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618340;
        bh=OZuN+qcrBJbB+zxg9JPmF27aqYQR+pzbSOPDRZ9gXyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9KEfcZzc/ql2BHfD5cY1dMV/ltH5qUpKZAUlAZ+4Iu1sPY3V4I4Rfc+TEYl0ZRzO
         ZhEA2EXBVt39vjETdQPu8S0Sw80uZ7zs9/EsT2Tjmo9Hr95lf3fBS+Ww+UN6P9D7XL
         3xs5wXsyZ5c5hdFWBAN7t57BaW5X/Kz9pXv8Z4pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/663] cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()
Date:   Mon,  1 Mar 2021 17:04:59 +0100
Message-Id: <20210301161144.289379120@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3657f729b6fb5f2c0bf693742de2dcd49c572aa1 ]

If 'cpufreq_unregister_driver()' fails, just WARN and continue, so that
other resources are freed.

Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ Viresh: Updated Subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index e25ccb744187d..4153150e20db5 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -754,8 +754,7 @@ static int brcm_avs_cpufreq_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = cpufreq_unregister_driver(&brcm_avs_driver);
-	if (ret)
-		return ret;
+	WARN_ON(ret);
 
 	brcm_avs_prepare_uninit(pdev);
 
-- 
2.27.0



