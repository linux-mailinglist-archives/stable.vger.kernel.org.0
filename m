Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A02420F4B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhJDNdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235167AbhJDNbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B635361B9F;
        Mon,  4 Oct 2021 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353249;
        bh=PVn9EHXXCHt0iDBC+6Sl0NjacemLjq2AYG/6tsvarqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ER+pTJ84UgX7zWp3TebcrprAdfDWAebKmfUflrVDePF9+g4k2JK8W8FWPrn/GusFv
         gCjaukd6t5oPOB4moTTLnWn/EN9A9szO4L/uW8VBi0WFMaKcb5LSoKOM/LCppHepwc
         d0Jj6hhjm3IjNbq9WnaALxrlU3m2goD/rFddE6MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 026/172] watchdog/sb_watchdog: fix compilation problem due to COMPILE_TEST
Date:   Mon,  4 Oct 2021 14:51:16 +0200
Message-Id: <20211004125045.812990968@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit c388a18957efdf31db8e97ec4d2d4b7dc1ca9a44 ]

Compiling sb_watchdog needs to clearly define SIBYTE_HDR_FEATURES.
In arch/mips/sibyte/Platform like:

  cflags-$(CONFIG_SIBYTE_BCM112X) +=                                      \
                -I$(srctree)/arch/mips/include/asm/mach-sibyte          \
                -DSIBYTE_HDR_FEATURES=SIBYTE_HDR_FMASK_1250_112x_ALL

Otherwise, SIBYTE_HDR_FEATURES is SIBYTE_HDR_FMASK_ALL.
SIBYTE_HDR_FMASK_ALL is mean:

 #define SIBYTE_HDR_FMASK_ALL  SIBYTE_HDR_FMASK_1250_ALL | SIBYTE_HDR_FMASK_112x_ALL \
				     | SIBYTE_HDR_FMASK_1480_ALL)

So, If not limited to CPU_SB1, we will get such an error:

  arch/mips/include/asm/sibyte/bcm1480_scd.h:261: error: "M_SPC_CFG_CLEAR" redefined [-Werror]
  arch/mips/include/asm/sibyte/bcm1480_scd.h:262: error: "M_SPC_CFG_ENABLE" redefined [-Werror]

Fixes: da2a68b3eb47 ("watchdog: Enable COMPILE_TEST where possible")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 546dfc1e2349..71cf3f503f16 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1677,7 +1677,7 @@ config WDT_MTX1
 
 config SIBYTE_WDOG
 	tristate "Sibyte SoC hardware watchdog"
-	depends on CPU_SB1 || (MIPS && COMPILE_TEST)
+	depends on CPU_SB1
 	help
 	  Watchdog driver for the built in watchdog hardware in Sibyte
 	  SoC processors.  There are apparently two watchdog timers
-- 
2.33.0



