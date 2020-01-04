Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86013008E
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 04:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgADDg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 22:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbgADDg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7439724649;
        Sat,  4 Jan 2020 03:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578108988;
        bh=b2eOfSgSncfP0ixbUgB0onIfccQpoxK4H/MyNkW/f1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCJOhuDaah9GZsup960QIhaZVOgliiJhr2LtQf2LubZumZ1Tdm998HjYwp1YizPG+
         w6VmsLDPfOAmEP7dZx52d2jSQivLr+DoPjn5zAP0nsPps25R0bK7V3z3EAXM9eiul9
         0aT1+H6BxXNd8HQeNjIAp/nb2BrkaaLP+Ui7z5g8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Dmitry Osipenko <digetx@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/10] PM / devfreq: tegra: Add COMMON_CLK dependency
Date:   Fri,  3 Jan 2020 22:36:15 -0500
Message-Id: <20200104033620.10977-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033620.10977-1-sashal@kernel.org>
References: <20200104033620.10977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5fdb0684b5b0f41402161f068d3d84bf6ed1c3f4 ]

Compile-testing this driver fails if CONFIG_COMMON_CLK is not set:

drivers/devfreq/tegra30-devfreq.o: In function `tegra_devfreq_target':
tegra30-devfreq.c:(.text+0x164): undefined reference to `clk_set_min_rate'

Fixes: 35f8dbc72721 ("PM / devfreq: tegra: Enable COMPILE_TEST for the driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index defe1d438710..af4a3ccb96b3 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -99,6 +99,7 @@ config ARM_TEGRA_DEVFREQ
 		ARCH_TEGRA_210_SOC || \
 		COMPILE_TEST
 	select PM_OPP
+	depends on COMMON_CLK
 	help
 	  This adds the DEVFREQ driver for the Tegra family of SoCs.
 	  It reads ACTMON counters of memory controllers and adjusts the
-- 
2.20.1

