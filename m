Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B223CD25CA
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387555AbfJJIiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387552AbfJJIiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF96A218AC;
        Thu, 10 Oct 2019 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696691;
        bh=97i0xSG3GJrklWHJTdUUtBp+ba4xe8mwqXSsvezLn/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jj50YZzuVdcvly6QJNUuukl0F6dgPjfiTG3s16kOMxKno9VUep07Zaw6cSsTMPOZi
         /VufHsV9j5meLnzRvwMgmcE8qbyBW2uHjXy0uadqaACrUsF9mkHMHhiY0Sn7GCeIMn
         x7OSnVnK/smKLG4hqQ0+O5DfJ9NNuYal9voQiwJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 5.3 018/148] PM / devfreq: tegra: Fix kHz to Hz conversion
Date:   Thu, 10 Oct 2019 10:34:39 +0200
Message-Id: <20191010083612.213619499@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 62bacb06b9f08965c4ef10e17875450490c948c0 upstream.

The kHz to Hz is incorrectly converted in a few places in the code,
this results in a wrong frequency being calculated because devfreq core
uses OPP frequencies that are given in Hz to clamp the rate, while
tegra-devfreq gives to the core value in kHz and then it also expects to
receive value in kHz from the core. In a result memory freq is always set
to a value which is close to ULONG_MAX because of the bug. Hence the EMC
frequency is always capped to the maximum and the driver doesn't do
anything useful. This patch was tested on Tegra30 and Tegra124 SoC's, EMC
frequency scaling works properly now.

Cc: <stable@vger.kernel.org> # 4.14+
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/devfreq/tegra-devfreq.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/devfreq/tegra-devfreq.c
+++ b/drivers/devfreq/tegra-devfreq.c
@@ -474,11 +474,11 @@ static int tegra_devfreq_target(struct d
 {
 	struct tegra_devfreq *tegra = dev_get_drvdata(dev);
 	struct dev_pm_opp *opp;
-	unsigned long rate = *freq * KHZ;
+	unsigned long rate;
 
-	opp = devfreq_recommended_opp(dev, &rate, flags);
+	opp = devfreq_recommended_opp(dev, freq, flags);
 	if (IS_ERR(opp)) {
-		dev_err(dev, "Failed to find opp for %lu KHz\n", *freq);
+		dev_err(dev, "Failed to find opp for %lu Hz\n", *freq);
 		return PTR_ERR(opp);
 	}
 	rate = dev_pm_opp_get_freq(opp);
@@ -487,8 +487,6 @@ static int tegra_devfreq_target(struct d
 	clk_set_min_rate(tegra->emc_clock, rate);
 	clk_set_rate(tegra->emc_clock, 0);
 
-	*freq = rate;
-
 	return 0;
 }
 
@@ -498,7 +496,7 @@ static int tegra_devfreq_get_dev_status(
 	struct tegra_devfreq *tegra = dev_get_drvdata(dev);
 	struct tegra_devfreq_device *actmon_dev;
 
-	stat->current_frequency = tegra->cur_freq;
+	stat->current_frequency = tegra->cur_freq * KHZ;
 
 	/* To be used by the tegra governor */
 	stat->private_data = tegra;
@@ -553,7 +551,7 @@ static int tegra_governor_get_target(str
 		target_freq = max(target_freq, dev->target_freq);
 	}
 
-	*freq = target_freq;
+	*freq = target_freq * KHZ;
 
 	return 0;
 }


