Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90202328BD8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbhCASkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239458AbhCASfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ED5965167;
        Mon,  1 Mar 2021 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618425;
        bh=tRdfwBMOc4cllLlSrfAP+6oTIivb4Ku1XyOMJyNdTeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKhWUPKLaoPHKr1dxO+/bMaRVw7PGPHiV37ufbVQjXmx3GK+TleIsM05nHlxfpPOI
         xNMD/7vWdMuwx5gDFhzAMHGi5z+3UBe3reREnbhfBK9gNw/C9m5nMyJ2ujXERu3u6p
         AYzk/Bl8k6Y0lmaLPzVod3xx0mTZPaGGsFC4NrhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/663] ARM: at91: use proper asm syntax in pm_suspend
Date:   Mon,  1 Mar 2021 17:05:30 +0100
Message-Id: <20210301161145.792622232@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d30337da8677cd73cb19444436b311c13e57356f ]

Compiling with the clang integrated assembler warns about
a recently added instruction:

<instantiation>:14:13: error: unknown token in expression
 ldr tmp1, =#0x00020010UL
arch/arm/mach-at91/pm_suspend.S:542:2: note: while in macro instantiation
 at91_plla_enable

Remove the extra '#' character that is not used for the 'ldr'
instruction when doing an indirect load of a constant.

Fixes: 4fd36e458392 ("ARM: at91: pm: add plla disable/enable support for sam9x60")
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210204160129.2249394-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 0184de05c1be1..b683c2caa40b9 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -442,7 +442,7 @@ ENDPROC(at91_backup_mode)
 	str	tmp1, [pmc, #AT91_PMC_PLL_UPDT]
 
 	/* step 2. */
-	ldr	tmp1, =#AT91_PMC_PLL_ACR_DEFAULT_PLLA
+	ldr	tmp1, =AT91_PMC_PLL_ACR_DEFAULT_PLLA
 	str	tmp1, [pmc, #AT91_PMC_PLL_ACR]
 
 	/* step 3. */
-- 
2.27.0



