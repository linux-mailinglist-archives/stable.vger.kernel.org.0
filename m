Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB7B2FC7EE
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbhATC3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730101AbhATB2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D70723340;
        Wed, 20 Jan 2021 01:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106022;
        bh=p1zvHNvX4mBTOFr0HwcT/Szj2x4F0eoll/67TJiUa4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbAisGcOMP21BrtTr/9HhpyUwjRa+RjvBj+tPuZn/eB+rDVeSLEeK8xveTg6P8TmZ
         e+ei4RsHiTCYj48OdYDyqzX2hRNAEnobQpLvmZlu6PjvE7VeEeBkyi+ac6PrvWZvWr
         ynChJOUEWYIdkQcc3Tkk32abfWal2WqnLYzdsH1+Zfl0iIi7ZK4tKSCe+iUr9Q3/SC
         wt+dMRhp3vTwcYxMcXjQAzeccbmFc6ayhI2P5BAR1iwO7eCoaW4wzr9A2ljOsXsfRu
         Ji8n1agqX/nb3Idw9vWz93iLYSQcOfvjHUvOk+R+IpXwuGK2WVC5t34tRg/LqNfwtA
         kNVgi6rqGXneQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 45/45] RISC-V: Fix maximum allowed phsyical memory for RV32
Date:   Tue, 19 Jan 2021 20:26:02 -0500
Message-Id: <20210120012602.769683-45-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit e557793799c5a8406afb08aa170509619f7eac36 ]

Linux kernel can only map 1GB of address space for RV32 as the page offset
is set to 0xC0000000. The current description in the Kconfig is confusing
as it indicates that RV32 can support 2GB of physical memory. That is
simply not true for current kernel. In future, a 2GB split support can be
added to allow 2GB physical address space.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 44377fd7860e4..234a21d26f674 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -134,7 +134,7 @@ config PA_BITS
 
 config PAGE_OFFSET
 	hex
-	default 0xC0000000 if 32BIT && MAXPHYSMEM_2GB
+	default 0xC0000000 if 32BIT && MAXPHYSMEM_1GB
 	default 0x80000000 if 64BIT && !MMU
 	default 0xffffffff80000000 if 64BIT && MAXPHYSMEM_2GB
 	default 0xffffffe000000000 if 64BIT && MAXPHYSMEM_128GB
@@ -247,10 +247,12 @@ config MODULE_SECTIONS
 
 choice
 	prompt "Maximum Physical Memory"
-	default MAXPHYSMEM_2GB if 32BIT
+	default MAXPHYSMEM_1GB if 32BIT
 	default MAXPHYSMEM_2GB if 64BIT && CMODEL_MEDLOW
 	default MAXPHYSMEM_128GB if 64BIT && CMODEL_MEDANY
 
+	config MAXPHYSMEM_1GB
+		bool "1GiB"
 	config MAXPHYSMEM_2GB
 		bool "2GiB"
 	config MAXPHYSMEM_128GB
-- 
2.27.0

