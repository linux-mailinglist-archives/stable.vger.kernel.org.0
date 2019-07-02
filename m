Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC885CBD0
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfGBID7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfGBIDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DB9221479;
        Tue,  2 Jul 2019 08:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054634;
        bh=AUw/e8DAeEZVsRY/zAXPjh9h8Bv7yd0wNjaqHTRNU9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9FzxrRSfVURLnfEInxMG2XsLoPkj5qenmWM1eB7yuSxO43frJwcto+1AmjTXGBj+
         apooVwG71RR41mtEtAeWKZJUTOjk2EPNULH0EdHmsi2CKGeRup8T4NQ1fYyrIHKRL4
         UN0fdqD6uYj9yU6Saw+9ZQxN7ifHFIFM2UbwmBg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.1 07/55] clk: tegra210: Fix default rates for HDA clocks
Date:   Tue,  2 Jul 2019 10:01:15 +0200
Message-Id: <20190702080124.431646492@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 9caec6620f25b6d15646bbdb93062c872ba3b56f upstream.

Currently the default clock rates for the HDA and HDA2CODEC_2X clocks
are both 19.2MHz. However, the default rates for these clocks should
actually be 51MHz and 48MHz, respectively. The current clock settings
results in a distorted output during audio playback. Correct the default
clock rates for these clocks by specifying them in the clock init table
for Tegra210.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/tegra/clk-tegra210.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3377,6 +3377,8 @@ static struct tegra_clk_init_table init_
 	{ TEGRA210_CLK_I2S3_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA210_CLK_I2S4_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA210_CLK_VIMCLK_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_HDA, TEGRA210_CLK_PLL_P, 51000000, 0 },
+	{ TEGRA210_CLK_HDA2CODEC_2X, TEGRA210_CLK_PLL_P, 48000000, 0 },
 	/* This MUST be the last entry. */
 	{ TEGRA210_CLK_CLK_MAX, TEGRA210_CLK_CLK_MAX, 0, 0 },
 };


