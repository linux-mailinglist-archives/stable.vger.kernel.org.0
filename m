Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D6F29B095
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901201AbgJ0OVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901166AbgJ0OUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516D4206D4;
        Tue, 27 Oct 2020 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808453;
        bh=EnhCOGvf50KfqqZMLJe0Y8ImuXpH9gYsVVB77JDRqMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuFhcEHlqacgnFQSvXhD1m12s+Gq287YiG82I9mLGZjijFUL5LeFexhM/uWvdykBs
         55dXWTndclh/u+qD70a97qNntn90xG/GIeIMLaVXnpHLKJfRjmzHdxF88mTvOja5eL
         ZmglbB6zkEDBW1ALrj1gXDGXwF5P/lUyzBEwT0Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/264] cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE
Date:   Tue, 27 Oct 2020 14:52:35 +0100
Message-Id: <20201027135435.251886995@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c942d1542f1bc5001216fabce9cb8ffbe515777e ]

CONFIG_ARM_ARMADA_37XX_CPUFREQ is tristate option and therefore this
cpufreq driver can be compiled as a module. This patch adds missing
MODULE_DEVICE_TABLE which generates correct modalias for automatic
loading of this cpufreq driver when is compiled as an external module.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 92ce45fb875d7 ("cpufreq: Add DVFS support for Armada 37xx")
[ Viresh: Added __maybe_unused ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index c5f98cafc25c9..9b0b490d70ff4 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -486,6 +486,12 @@ static int __init armada37xx_cpufreq_driver_init(void)
 /* late_initcall, to guarantee the driver is loaded after A37xx clock driver */
 late_initcall(armada37xx_cpufreq_driver_init);
 
+static const struct of_device_id __maybe_unused armada37xx_cpufreq_of_match[] = {
+	{ .compatible = "marvell,armada-3700-nb-pm" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, armada37xx_cpufreq_of_match);
+
 MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
 MODULE_DESCRIPTION("Armada 37xx cpufreq driver");
 MODULE_LICENSE("GPL");
-- 
2.25.1



