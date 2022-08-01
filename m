Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B8A586A93
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiHAMSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiHAMSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8D49B5F;
        Mon,  1 Aug 2022 04:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1E7601C5;
        Mon,  1 Aug 2022 11:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAFAC433C1;
        Mon,  1 Aug 2022 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355154;
        bh=Kr1Yx27AWLh+1gvT8gaFpSOhnROqSVu0uXH2DRg+H2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do9arLBY+JWYTpX3rV3riVQc8B4YmT/P7Jcpd3qt2wYoGmbYLgJ0dz8PboAHEksJ3
         ShVofVkMRczbF6iYm4U84Ox15cWQ238asHFo1FUNeC19EP2KVUg9TjGUEVBcSef0+4
         7uN8SYxvP3rKv0AyD2zyZrEqifs+zo2i9cHJ/Jy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 82/88] ARM: 9216/1: Fix MAX_DMA_ADDRESS overflow
Date:   Mon,  1 Aug 2022 13:47:36 +0200
Message-Id: <20220801114141.740058208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit fb0fd3469ead5b937293c213daa1f589b4b7ce46 ]

Commit 26f09e9b3a06 ("mm/memblock: add memblock memory allocation apis")
added a check to determine whether arm_dma_zone_size is exceeding the
amount of kernel virtual address space available between the upper 4GB
virtual address limit and PAGE_OFFSET in order to provide a suitable
definition of MAX_DMA_ADDRESS that should fit within the 32-bit virtual
address space. The quantity used for comparison was off by a missing
trailing 0, leading to MAX_DMA_ADDRESS to be overflowing a 32-bit
quantity.

This was caught thanks to CONFIG_DEBUG_VIRTUAL on the bcm2711 platform
where we define a dma_zone_size of 1GB and we have a PAGE_OFFSET value
of 0xc000_0000 (CONFIG_VMSPLIT_3G) leading to MAX_DMA_ADDRESS being
0x1_0000_0000 which overflows the unsigned long type used throughout
__pa() and then __virt_addr_valid(). Because the virtual address passed
to __virt_addr_valid() would now be 0, the function would loudly warn
and flood the kernel log, thus making the platform unable to boot
properly.

Fixes: 26f09e9b3a06 ("mm/memblock: add memblock memory allocation apis")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index a81dda65c576..45180a2cc47c 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -10,7 +10,7 @@
 #else
 #define MAX_DMA_ADDRESS	({ \
 	extern phys_addr_t arm_dma_zone_size; \
-	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
+	arm_dma_zone_size && arm_dma_zone_size < (0x100000000ULL - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
-- 
2.35.1



