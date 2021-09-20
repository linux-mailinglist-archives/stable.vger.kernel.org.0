Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846A412218
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376528AbhITSMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350976AbhITSLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B036327B;
        Mon, 20 Sep 2021 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158421;
        bh=8DU1iuGYv74LnsIoiQnBgxC46+p/xTgoTDxSj+Xr8tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2novm93nW9XM4vOjGRES4QbKNNo2mxh/6/ITPcprR5MkJAAXyUUW3Y/2IfW6mynk2
         Xzc/6MiKzsKyE2r8eKIeWiLL8WPVGGdarnkdBOkQZ19/kzfav00Kx0y2dj0mQf4Stu
         6W/FvFljNOpJsmJ68XnZuFSFFCu95Sd9k3fRuFgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/260] m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch
Date:   Mon, 20 Sep 2021 18:42:45 +0200
Message-Id: <20210920163936.109686269@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



