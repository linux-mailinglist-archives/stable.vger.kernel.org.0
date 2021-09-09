Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CBC40540F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353960AbhIIM4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353125AbhIIMtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F4E63218;
        Thu,  9 Sep 2021 11:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188609;
        bh=8DU1iuGYv74LnsIoiQnBgxC46+p/xTgoTDxSj+Xr8tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxtsmOm4q87e14q0etvwVcxTSBTlXGiZne6ebLDtDVnxg0apr8SIuyBuKn/w9NuoL
         dXbtv78cDWmDefrcQDAkGC1ewstJ8yQ4r7skOCowzNX3FllzwN6ZJwExfO3DWFB6iq
         so6ncnjzr7zM5BTdDKXVotkn77LBzn4MjH1nVWuUHryLaYT1l16sOg697DR1ApVFFc
         BygkkcwyZYQvLhilFPvav103XVij7sT+HXrCDoz6qQtC2J8rG+Ek7ypqHcMvmY1ClD
         Pb01MNkPVb7EuSukKwkzO5Ax1Y1eRt45Tj6/PYQ/XWKJYZVQPasTiRb824hHYvi38A
         6e4Z63AARGuHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 080/109] m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch
Date:   Thu,  9 Sep 2021 07:54:37 -0400
Message-Id: <20210909115507.147917-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit db87db65c1059f3be04506d122f8ec9b2fa3b05e ]

> Hi Arnd,
>
> First bad commit (maybe != root cause):
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   2f73937c9aa561e2082839bc1a8efaac75d6e244
> commit: 47fd22f2b84765a2f7e3f150282497b902624547 [4771/5318] cs89x0: rework driver configuration
> config: m68k-randconfig-c003-20210804 (attached as .config)
> compiler: m68k-linux-gcc (GCC) 10.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=47fd22f2b84765a2f7e3f150282497b902624547
>         git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>         git fetch --no-tags linux-next master
>         git checkout 47fd22f2b84765a2f7e3f150282497b902624547
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-10.3.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/kernel.h:19,
>                     from include/linux/list.h:9,
>                     from include/linux/module.h:12,
>                     from drivers/net/ethernet/cirrus/cs89x0.c:51:
>    drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
>    drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaration of function 'isa_virt_to_bus'; did you mean 'virt_to_bus'? [-Werror=implicit-function-declaration]
>      897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
>          |                    ^~~~~~~~~~~~~~~
>    include/linux/printk.h:141:17: note: in definition of macro 'no_printk'
>      141 |   printk(fmt, ##__VA_ARGS__);  \
>          |                 ^~~~~~~~~~~
>    drivers/net/ethernet/cirrus/cs89x0.c:86:3: note: in expansion of macro 'pr_debug'
>       86 |   pr_##level(fmt, ##__VA_ARGS__);   \
>          |   ^~~
>    drivers/net/ethernet/cirrus/cs89x0.c:894:3: note: in expansion of macro 'cs89_dbg'
>      894 |   cs89_dbg(1, debug, "%s: dma %lx %lx\n",
>          |   ^~~~~~~~
> >> drivers/net/ethernet/cirrus/cs89x0.c:914:3: error: implicit declaration of function 'disable_dma'; did you mean 'disable_irq'? [-Werror=implicit-function-declaration]

As far as I can tell, this is a bug with the m68kmmu architecture, not
with my driver:
The CONFIG_ISA_DMA_API option is provided for coldfire, which implements it,
but dragonball also sets the option as a side-effect, without actually
implementing
the interfaces. The patch below should fix it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.bus | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
index 9d0a3a23d50e..355c51309ed8 100644
--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -63,7 +63,7 @@ source "drivers/zorro/Kconfig"
 
 endif
 
-if !MMU
+if COLDFIRE
 
 config ISA_DMA_API
         def_bool !M5272
-- 
2.30.2

