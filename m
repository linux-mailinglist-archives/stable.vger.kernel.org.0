Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67832247570
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgHQTXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbgHQPfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D9E20882;
        Mon, 17 Aug 2020 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678500;
        bh=NgurdkAyS3ZCan68jj+yrGYmGwZI9CQBOjFPTO0lW1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6y1gmQkGyMhhuLsgLVj6DUqLJs7i3yQp6aGJJ+g1IGzxkbNaMtZGyRtObW383iwZ
         N52Ustqab1ED6xP53QE92xDnqniai36Eqq9cYgr3soeTrbRJOKRXP2UuOg5Ea+WHF2
         3d96iG7viyJ84/dK75oydZkHt73MtXNBegxCz3EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 324/464] cpufreq: ap806: fix cpufreq driver needs ap cpu clk
Date:   Mon, 17 Aug 2020 17:14:37 +0200
Message-Id: <20200817143849.312255244@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index c6cbfc8baf724..a967894c4613e 100644
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



