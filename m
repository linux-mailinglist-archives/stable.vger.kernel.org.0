Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9281A541D12
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378661AbiFGWHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383880AbiFGWGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA6D195976;
        Tue,  7 Jun 2022 12:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D3EB6192F;
        Tue,  7 Jun 2022 19:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D84C385A2;
        Tue,  7 Jun 2022 19:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629450;
        bh=+7xftkGjyf+e5zg4DgvqH+lSjN974cPn3Aj+rSWqdhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2koyuUbLehMc2Vhtb15rsQ/cp9RuRj91HP6wLbK5f0kT3q7ND3raPaAtGur13NEp
         JUx4N1ESdCUTFvS7htmWWikgvRFee05IeNCx3ioa242eoKclYbQKcjhFXCp1dzvg+m
         +nHmGFYvjk5Ckhm6BoHvgsD+orSzymY+xtko0wuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 695/879] MIPS: RALINK: Define pci_remap_iospace under CONFIG_PCI_DRIVERS_GENERIC
Date:   Tue,  7 Jun 2022 19:03:33 +0200
Message-Id: <20220607165023.019728967@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 7e4fd16b38923028b01d3dbadf4ca973d885c53e ]

kernel test robot reports a build error used with clang compiler and
mips-randconfig [1]:

    ld.lld: error: undefined symbol: pci_remap_iospace

we can see the following configs in the mips-randconfig file:

    CONFIG_RALINK=y
    CONFIG_SOC_MT7620=y
    CONFIG_PCI_DRIVERS_LEGACY=y
    CONFIG_PCI=y

CONFIG_RALINK is set, so pci_remap_iospace is defined in the related
arch/mips/include/asm/mach-ralink/spaces.h header file:

    #define pci_remap_iospace pci_remap_iospace

CONFIG_PCI is set, so pci_remap_iospace() in drivers/pci/pci.c is not
built due to pci_remap_iospace is defined under CONFIG_RALINK.

    #ifndef pci_remap_iospace
    int pci_remap_iospace(const struct resource *res, ...)

    $ objdump -d drivers/pci/pci.o | grep pci_remap_iospace
    00004cc8 <devm_pci_remap_iospace>:
        4d18:	10400008 	beqz	v0,4d3c <devm_pci_remap_iospace+0x74>
        4d2c:	1040000c 	beqz	v0,4d60 <devm_pci_remap_iospace+0x98>
        4d70:	1000fff3 	b	4d40 <devm_pci_remap_iospace+0x78>

In addition, CONFIG_PCI_DRIVERS_GENERIC is not set, so pci_remap_iospace()
in arch/mips/pci/pci-generic.c is not built too.

    #ifdef pci_remap_iospace
    int pci_remap_iospace(const struct resource *res, ...)

For the above reasons, undefined reference pci_remap_iospace() looks like
reasonable.

Here are simple steps to reproduce used with gcc and defconfig:

    cd mips.git
    make vocore2_defconfig # set RALINK, SOC_MT7620, PCI_DRIVERS_LEGACY
    make menuconfig        # set PCI
    make

there exists the following build error:

      LD      vmlinux.o
      MODPOST vmlinux.symvers
      MODINFO modules.builtin.modinfo
      GEN     modules.builtin
      LD      .tmp_vmlinux.kallsyms1
    drivers/pci/pci.o: In function `devm_pci_remap_iospace':
    pci.c:(.text+0x4d24): undefined reference to `pci_remap_iospace'
    Makefile:1158: recipe for target 'vmlinux' failed
    make: *** [vmlinux] Error 1

Define pci_remap_iospace under CONFIG_PCI_DRIVERS_GENERIC can fix the build
error, with this patch, no build error remains. This patch is similar with
commit e538e8649892 ("MIPS: asm: pci: define arch-specific
'pci_remap_iospace()' dependent on 'CONFIG_PCI_DRIVERS_GENERIC'").

[1] https://lore.kernel.org/lkml/202205251247.nQ5cxSV6-lkp@intel.com/

Fixes: 09d97da660ff ("MIPS: Only define pci_remap_iospace() for Ralink")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-ralink/spaces.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/mach-ralink/spaces.h b/arch/mips/include/asm/mach-ralink/spaces.h
index f7af11ea2d61..a9f0570d0f04 100644
--- a/arch/mips/include/asm/mach-ralink/spaces.h
+++ b/arch/mips/include/asm/mach-ralink/spaces.h
@@ -6,7 +6,9 @@
 #define PCI_IOSIZE	SZ_64K
 #define IO_SPACE_LIMIT	(PCI_IOSIZE - 1)
 
+#ifdef CONFIG_PCI_DRIVERS_GENERIC
 #define pci_remap_iospace pci_remap_iospace
+#endif
 
 #include <asm/mach-generic/spaces.h>
 #endif
-- 
2.35.1



