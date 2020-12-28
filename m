Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6492E40C1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391779AbgL1OQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440885AbgL1OQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF8320791;
        Mon, 28 Dec 2020 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164927;
        bh=WDcTPrTXz9qUtyo8bsOW9H+jSc4yZdmHOzryDsLKWVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4Mrxj7tr92Ah02QvnNP0MhxO7Ow8F8xAPyqN0m3xwkTtURTP/iYrWPGytyqv2oY9
         KM+S1PU7GWZPEndIJaIXTd4QJuVnvwlM3AxIK/knOQoPKsRU3gF2pfr5xfaf/IRdsI
         vzvfWhr03HFE0OzXl0m+UgZUg9ybE5/YWy28DzO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/717] memory: ti-emif-sram: only build for ARMv7
Date:   Mon, 28 Dec 2020 13:45:15 +0100
Message-Id: <20201228125036.221339172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d77d22d701b0471584abe1871570bb43deb6e3c4 ]

The driver can be compile-tested on all ARM machines, but
causes a failure when built for ARMv7-M:

arm-linux-gnueabi-ld: error: drivers/memory/ti-emif-sram-pm.o: conflicting architecture profiles A/M

Limit the target machines to configurations that have ARMv7 enabled.

Fixes: ea0c0ad6b6eb ("memory: Enable compile testing for most of the drivers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201203230832.1481767-1-arnd@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 00e013b14703e..cc2c83e1accfb 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -128,7 +128,7 @@ config OMAP_GPMC_DEBUG
 
 config TI_EMIF_SRAM
 	tristate "Texas Instruments EMIF SRAM driver"
-	depends on SOC_AM33XX || SOC_AM43XX || (ARM && COMPILE_TEST)
+	depends on SOC_AM33XX || SOC_AM43XX || (ARM && CPU_V7 && COMPILE_TEST)
 	depends on SRAM
 	help
 	  This driver is for the EMIF module available on Texas Instruments
-- 
2.27.0



