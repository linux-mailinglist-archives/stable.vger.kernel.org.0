Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242A328625
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbhCARE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236652AbhCAQ6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC05264DE8;
        Mon,  1 Mar 2021 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616623;
        bh=CWi+XpQQMlRwddXt0ntRHIpxYRl+O2snV1ZSwFvDal0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbp88d+abQlngDYum72UFYXEyUrgEbrJuRV1bUwxpCGPm1TG66+Xwl7TyB03hpOm2
         n8gFNUMfOyqNRbOe0LUyyWKqcnckH1ZxsgBvq3+PMv0i35MI7JVPtdHMiXe+Sr6PbX
         sUA8W+mNZmGlKgAl/oDTGeNPa3DNRPSjlzfwK/zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/247] cpufreq: brcmstb-avs-cpufreq: Free resources in error path
Date:   Mon,  1 Mar 2021 17:10:59 +0100
Message-Id: <20210301161033.595842430@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 05f456286fd489558c72a4711d22a5612c965685 ]

If 'cpufreq_register_driver()' fails, we must release the resources
allocated in 'brcm_avs_prepare_init()' as already done in the remove
function.

To do that, introduce a new function 'brcm_avs_prepare_uninit()' in order
to avoid code duplication. This also makes the code more readable (IMHO).

Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ Viresh: Updated Subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index 77b0e5d0fb134..1514c9846c5d5 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -566,6 +566,16 @@ unmap_base:
 	return ret;
 }
 
+static void brcm_avs_prepare_uninit(struct platform_device *pdev)
+{
+	struct private_data *priv;
+
+	priv = platform_get_drvdata(pdev);
+
+	iounmap(priv->avs_intr_base);
+	iounmap(priv->base);
+}
+
 static int brcm_avs_cpufreq_init(struct cpufreq_policy *policy)
 {
 	struct cpufreq_frequency_table *freq_table;
@@ -701,21 +711,22 @@ static int brcm_avs_cpufreq_probe(struct platform_device *pdev)
 
 	brcm_avs_driver.driver_data = pdev;
 
-	return cpufreq_register_driver(&brcm_avs_driver);
+	ret = cpufreq_register_driver(&brcm_avs_driver);
+	if (ret)
+		brcm_avs_prepare_uninit(pdev);
+
+	return ret;
 }
 
 static int brcm_avs_cpufreq_remove(struct platform_device *pdev)
 {
-	struct private_data *priv;
 	int ret;
 
 	ret = cpufreq_unregister_driver(&brcm_avs_driver);
 	if (ret)
 		return ret;
 
-	priv = platform_get_drvdata(pdev);
-	iounmap(priv->base);
-	iounmap(priv->avs_intr_base);
+	brcm_avs_prepare_uninit(pdev);
 
 	return 0;
 }
-- 
2.27.0



