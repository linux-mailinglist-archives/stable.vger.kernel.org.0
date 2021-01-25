Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D6303391
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbhAZE6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbhAYSuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9712067B;
        Mon, 25 Jan 2021 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600589;
        bh=p1zvHNvX4mBTOFr0HwcT/Szj2x4F0eoll/67TJiUa4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QRLTk4rlRgWE5pyJYliEqfNatALrSdrmBVaak1Dzy8UY8WX2xfdMIxYV/aEaakEz
         4Dl+zvr6cc8sro1pls9M2XDYZ/V6Dl3OSbkRaLm4bmT4bzSNoBXrpXensx4MyXRtl1
         cpd2b4Yq+i1y5GGI2G7OOzhGroaClO88ZGXGIbxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/199] RISC-V: Fix maximum allowed phsyical memory for RV32
Date:   Mon, 25 Jan 2021 19:38:16 +0100
Message-Id: <20210125183219.391097351@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



