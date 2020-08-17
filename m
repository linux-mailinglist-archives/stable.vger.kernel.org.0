Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13562470AC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390504AbgHQSMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388250AbgHQQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EEE920825;
        Mon, 17 Aug 2020 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680435;
        bh=mrbheoATsrbhzw2PLBNKRGTGDT9ilIlU620jlQuqv0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVjFh3Ctb4z7TGKTwiVwTmpE5wXDZVKlcUi5uJFrTa6/mu2pvpr/xIM56FbyJHzoW
         /l4q5e+sqK752IbcNW+MtouK2iqZBipKFxIZTUvG4aPNSx36RfssAxNZzHt79Eyj0J
         NrZW54q/lQh5Kzh37PmK7A+quzDQgh96Goyup0V8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/270] cpufreq: ap806: fix cpufreq driver needs ap cpu clk
Date:   Mon, 17 Aug 2020 17:16:26 +0200
Message-Id: <20200817143805.032667045@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 8c37ad2f523396e15cf002b29f8f796447c71932 ]

The Armada 8K cpufreq driver needs the Armada AP CPU CLK
to work. This dependency is currently not satisfied and
the ARMADA_AP_CPU_CLK can not be selected independently.

Add it to the cpufreq Armada8k driver.

Fixes: f525a670533d ("cpufreq: ap806: add cpufreq driver for Armada 8K")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.arm | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index a905796f7f856..25f11e9ec3587 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -41,6 +41,7 @@ config ARM_ARMADA_37XX_CPUFREQ
 config ARM_ARMADA_8K_CPUFREQ
 	tristate "Armada 8K CPUFreq driver"
 	depends on ARCH_MVEBU && CPUFREQ_DT
+	select ARMADA_AP_CPU_CLK
 	help
 	  This enables the CPUFreq driver support for Marvell
 	  Armada8k SOCs.
-- 
2.25.1



