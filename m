Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DBF24BC96
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgHTMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgHTJpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCDD22D02;
        Thu, 20 Aug 2020 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916661;
        bh=bk/x8Y10EKdsRTQUjwNWHxsSDrm6J2y97JLT8GSLSUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16k6JOYfwu4KjWiIyVjp0EB4EM25AB+lAXEpyoVZ9MqmWManCDyDOUohKCiLX2Jzy
         aJFl2bg+bG4/+fNnN69O3+xuF/qxxywMumVj/rMmiU7VQahhlO7DeK9WVP62Kmx/dk
         cahWtR5cWnV0NJquHID/a5zdZhEOjc7lDplVzKUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.7 192/204] ASoC: tegra: Enable audio mclk during tegra_asoc_utils_init()
Date:   Thu, 20 Aug 2020 11:21:29 +0200
Message-Id: <20200820091615.784375033@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit ff5d18cb04f4ecccbcf05b7f83ab6df2a0d95c16 upstream.

Tegra PMC clock clk_out_1 is dedicated for audio mclk from Tegra30
through Tegra210 and currently Tegra clock driver keeps the audio mclk
enabled.

With the move of PMC clocks from clock driver into pmc driver, audio
mclk enable from clock driver is removed and this should be taken care
of by the audio driver.

tegra_asoc_utils_init() calls tegra_asoc_utils_set_rate() and audio mclk
rate configuration is not needed during init and the rate is actually
set during the ->hw_params() callback.

So, this patch removes tegra_asoc_utils_set_rate() call and just leaves
the audio mclk enabled.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_asoc_utils.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/sound/soc/tegra/tegra_asoc_utils.c
+++ b/sound/soc/tegra/tegra_asoc_utils.c
@@ -205,9 +205,16 @@ int tegra_asoc_utils_init(struct tegra_a
 		data->clk_cdev1 = clk_out_1;
 	}
 
-	ret = tegra_asoc_utils_set_rate(data, 44100, 256 * 44100);
-	if (ret)
+	/*
+	 * FIXME: There is some unknown dependency between audio mclk disable
+	 * and suspend-resume functionality on Tegra30, although audio mclk is
+	 * only needed for audio.
+	 */
+	ret = clk_prepare_enable(data->clk_cdev1);
+	if (ret) {
+		dev_err(data->dev, "Can't enable cdev1: %d\n", ret);
 		return ret;
+	}
 
 	return 0;
 }


