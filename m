Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB5328AAD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhCASV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239276AbhCASQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:16:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27ADF65158;
        Mon,  1 Mar 2021 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618337;
        bh=RZ2lNrtk/ruHMYhO3IkOoY0gjuJVD5j4yXHhcUwXC4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XR5rbowy8b/qd0RJPU+46T3fIqh8spgizrsXX5QlB0Z+ID9q2yFyYctuK5T0OUMXw
         81l3lev+WMcQ2Ash/+v4wxI9gY9MVqcDL7L+eRbVGqs2XJf9tTASXxjok7uiJQW571
         6g+sjJwP/ifB95Na2ZXlesASpcm9vlC1tsCMmqtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/663] cpufreq: brcmstb-avs-cpufreq: Free resources in error path
Date:   Mon,  1 Mar 2021 17:04:58 +0100
Message-Id: <20210301161144.239962265@linuxfoundation.org>
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
index 3e31e5d28b79c..e25ccb744187d 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -597,6 +597,16 @@ unmap_base:
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
@@ -732,21 +742,22 @@ static int brcm_avs_cpufreq_probe(struct platform_device *pdev)
 
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



