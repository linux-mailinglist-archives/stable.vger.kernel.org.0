Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5C2F79EC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbhAOMie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388190AbhAOMic (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968E6221FA;
        Fri, 15 Jan 2021 12:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714297;
        bh=+/2suSKv+zzxX1xVoY3PrAEt4cMCRhs8SvIfPEsngX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR291+f09Dx2lun7QYnNV4q7l37bwV1d09JknL03bhkaNieEX6Ye+029DOj5OcFUC
         V0Q4yE/Dbx7yvPpxCpeZL2MmDf4VDEy2WmY5AEZgLGrcJ43Vv7giRGyLw/F/+5nLou
         UJ3eZdisgaoB8Qt2/aW+N/vtxEakuT2l6yX/Aybw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 073/103] arm64: mm: Fix ARCH_LOW_ADDRESS_LIMIT when !CONFIG_ZONE_DMA
Date:   Fri, 15 Jan 2021 13:28:06 +0100
Message-Id: <20210115122009.562861650@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 095507dc1350b3a2b8b39fdc05edba0c10859eca upstream.

Systems configured with CONFIG_ZONE_DMA32, CONFIG_ZONE_NORMAL and
!CONFIG_ZONE_DMA will fail to properly setup ARCH_LOW_ADDRESS_LIMIT. The
limit will default to ~0ULL, effectively spanning the whole memory,
which is too high for a configuration that expects low memory to be
capped at 4GB.

Fix ARCH_LOW_ADDRESS_LIMIT by falling back to arm64_dma32_phys_limit
when arm64_dma_phys_limit isn't set. arm64_dma32_phys_limit will honour
CONFIG_ZONE_DMA32, or span the entire memory when not enabled.

Fixes: 1a8e1cef7603 ("arm64: use both ZONE_DMA and ZONE_DMA32")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20201218163307.10150-1-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/processor.h |    3 ++-
 arch/arm64/mm/init.c               |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -96,7 +96,8 @@
 #endif /* CONFIG_ARM64_FORCE_52BIT */
 
 extern phys_addr_t arm64_dma_phys_limit;
-#define ARCH_LOW_ADDRESS_LIMIT	(arm64_dma_phys_limit - 1)
+extern phys_addr_t arm64_dma32_phys_limit;
+#define ARCH_LOW_ADDRESS_LIMIT	((arm64_dma_phys_limit ? : arm64_dma32_phys_limit) - 1)
 
 struct debug_info {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL(memstart_addr);
  * bit addressable memory area.
  */
 phys_addr_t arm64_dma_phys_limit __ro_after_init;
-static phys_addr_t arm64_dma32_phys_limit __ro_after_init;
+phys_addr_t arm64_dma32_phys_limit __ro_after_init;
 
 #ifdef CONFIG_KEXEC_CORE
 /*


