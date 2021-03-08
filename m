Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6CC330DED
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhCHMeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhCHMeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE382651D3;
        Mon,  8 Mar 2021 12:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206840;
        bh=wKkAHu82AqmqBxnZhs11MmkFTEA9bAr0eG/VyWNa1to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJLbXfGVto3KJuhk+v56XvptmxBYqfStFrnq0NvCU48SQOyzWl0PK+Sd9CinGyRBS
         quMaid5qosxx+d+/hPhv2VOiyAJGPBEBtGjxzta4+LvNpPI3GujYCPbKBTa4hhsiIH
         UjQsXUWD1RAO2huhUrQa2S8SwZK9k06ho3RpKMpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.10 24/42] arm64: mm: Move reserve_crashkernel() into mem_init()
Date:   Mon,  8 Mar 2021 13:30:50 +0100
Message-Id: <20210308122719.315066515@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 0a30c53573b07d5561457e41fb0ab046cd857da5 upstream

crashkernel might reserve memory located in ZONE_DMA. We plan to delay
ZONE_DMA's initialization after unflattening the devicetree and ACPI's
boot table initialization, so move it later in the boot process.
Specifically into bootmem_init() since request_standard_resources()
depends on it.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/r/20201119175400.9995-2-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -386,8 +386,6 @@ void __init arm64_memblock_init(void)
 	else
 		arm64_dma32_phys_limit = PHYS_MASK + 1;
 
-	reserve_crashkernel();
-
 	reserve_elfcorehdr();
 
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
@@ -427,6 +425,12 @@ void __init bootmem_init(void)
 	sparse_init();
 	zone_sizes_init(min, max);
 
+	/*
+	 * request_standard_resources() depends on crashkernel's memory being
+	 * reserved, so do it here.
+	 */
+	reserve_crashkernel();
+
 	memblock_dump_all();
 }
 


