Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568071F2C26
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgFIAVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729272AbgFHXRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A6B20823;
        Mon,  8 Jun 2020 23:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658268;
        bh=tVHUbJrmSj5WwA+U33l2RkVyEQK1iFhc957Equ35Qzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3KFgVHh7Vwsjb8DII3IIeOx3hlmoEjaqsulhpzrdQXeZRHH3xqCvCrwY2WH600nc
         bWdUkO5i043sAdMGErLoZusyEa2+s9QNAyPDD8RfNsqy2LXugWB9xkeSTwyPN84B+Z
         Oy9TbaAgIX5oj2lrMbdaxESYu83JNPa6y72q2yHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 275/606] riscv: Fix unmet direct dependencies built based on SOC_VIRT
Date:   Mon,  8 Jun 2020 19:06:40 -0400
Message-Id: <20200608231211.3363633-275-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

