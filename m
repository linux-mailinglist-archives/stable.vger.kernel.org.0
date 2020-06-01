Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A492F1EAB0F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbgFASOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731426AbgFASOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:14:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DEA2065C;
        Mon,  1 Jun 2020 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035240;
        bh=tVHUbJrmSj5WwA+U33l2RkVyEQK1iFhc957Equ35Qzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXr1Ib1Lc7QpJ6mPFMUy7KEB2L08+Zh2NPOsA4/TWgP9blEm6uWzmUENma2M7EpW6
         Z5+v25T9VrIzW4Lg6/++2/BNL5Cgq3oed/+PwbuXoeQ5SRCdkXd+mqY4SdsbJHveJo
         GL8FOYnAKX8gtOUGN1E7MDHC9PIlR5ZarEFR/P2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 070/177] riscv: Fix unmet direct dependencies built based on SOC_VIRT
Date:   Mon,  1 Jun 2020 19:53:28 +0200
Message-Id: <20200601174054.751640954@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit ab7fbad0c7d7a4f9b320a059a171a92a34b6d409 ]

Fix unmet direct dependencies Warning and fix Kconfig indent.

WARNING: unmet direct dependencies detected for POWER_RESET_SYSCON
  Depends on [n]: POWER_RESET [=n] && OF [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - SOC_VIRT [=y]

WARNING: unmet direct dependencies detected for POWER_RESET_SYSCON_POWEROFF
  Depends on [n]: POWER_RESET [=n] && OF [=y] && HAS_IOMEM [=y]
  Selected by [y]:
  - SOC_VIRT [=y]

WARNING: unmet direct dependencies detected for RTC_DRV_GOLDFISH
  Depends on [n]: RTC_CLASS [=n] && OF [=y] && HAS_IOMEM [=y] && (GOLDFISH [=y] || COMPILE_TEST [=n])
  Selected by [y]:
  - SOC_VIRT [=y]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig.socs | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index a131174a0a77..f310ad8ffcf7 100644
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -11,13 +11,14 @@ config SOC_SIFIVE
 	  This enables support for SiFive SoC platform hardware.
 
 config SOC_VIRT
-       bool "QEMU Virt Machine"
-       select POWER_RESET_SYSCON
-       select POWER_RESET_SYSCON_POWEROFF
-       select GOLDFISH
-       select RTC_DRV_GOLDFISH
-       select SIFIVE_PLIC
-       help
-         This enables support for QEMU Virt Machine.
+	bool "QEMU Virt Machine"
+	select POWER_RESET
+	select POWER_RESET_SYSCON
+	select POWER_RESET_SYSCON_POWEROFF
+	select GOLDFISH
+	select RTC_DRV_GOLDFISH if RTC_CLASS
+	select SIFIVE_PLIC
+	help
+	  This enables support for QEMU Virt Machine.
 
 endmenu
-- 
2.25.1



