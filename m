Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDBD5FB650
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiJKPCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiJKPBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7F9C21D;
        Tue, 11 Oct 2022 07:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A85B81630;
        Tue, 11 Oct 2022 14:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB24C433D6;
        Tue, 11 Oct 2022 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499972;
        bh=8MLmv8j3T46AmOBVlkUxEoYYnaocUtHwPDy2md3Eo98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBa2dbhM7qn7rVyFd8ROlAOe/VIF9PpbKoURddD0DQYmfrj2ruv4+Mj3Cj807rqQ+
         RtPlpn350j2HVI8GTNitXX9gWcQf3dky0zexZPGciFTDEAtFcaL28N65N25Dzgr/vN
         Objd8jK/7/vLPHrVDZjAbI/rBxny2TNfDUsjjaAW0F9RRtNTwVo21CerDNIu5ffUwh
         H/NHKYRXveOEswUFLTR9u8BLOKMubKIvxx+t0qdN+9AfOWNIhK/30ZDN0A5EVotepA
         dz7GhHfYhy1kGwwqL4aYAo+G2bhCQVrZqoLENm+0SlmBIGwVMysYGJDp7lcmGUTSKM
         dZ1KuZDYqX2HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 12/26] sparc: Fix the generic IO helpers
Date:   Tue, 11 Oct 2022 10:52:19 -0400
Message-Id: <20221011145233.1624013-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2c230431e1e809270178905974f57cf3878939f5 ]

This enables the Sparc to use <asm-generic/io.h> to fill in the
missing (undefined) [read|write]sq I/O accessor functions.

This is needed if Sparc[64] ever wants to uses CONFIG_REGMAP_MMIO
which has been patches to use accelerated _noinc accessors
such as readsq/writesq that Sparc64, while being a 64bit platform,
as of now not yet provide.

This comes with the requirement that everything the architecture
already provides needs to be defined, rather than just being,
say, static inline functions.

Bite the bullet and just provide the definitions and make it work.
Compile-tested on sparc32 and sparc64.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-kernel/202208201639.HXye3ke4-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/io.h    |  2 ++
 arch/sparc/include/asm/io_64.h | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index 2eefa526b38f..2dad9be9ec75 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -19,4 +19,6 @@
 #define writel_be(__w, __addr)	__raw_writel(__w, __addr)
 #define writew_be(__l, __addr)	__raw_writew(__l, __addr)
 
+#include <asm-generic/io.h>
+
 #endif
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 5ffa820dcd4d..9303270b22f3 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -9,6 +9,7 @@
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/asi.h>
 #include <asm-generic/pci_iomap.h>
+#define pci_iomap pci_iomap
 
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
@@ -239,38 +240,51 @@ static inline void outl(u32 l, unsigned long addr)
 void outsb(unsigned long, const void *, unsigned long);
 void outsw(unsigned long, const void *, unsigned long);
 void outsl(unsigned long, const void *, unsigned long);
+#define outsb outsb
+#define outsw outsw
+#define outsl outsl
 void insb(unsigned long, void *, unsigned long);
 void insw(unsigned long, void *, unsigned long);
 void insl(unsigned long, void *, unsigned long);
+#define insb insb
+#define insw insw
+#define insl insl
 
 static inline void readsb(void __iomem *port, void *buf, unsigned long count)
 {
 	insb((unsigned long __force)port, buf, count);
 }
+#define readsb readsb
+
 static inline void readsw(void __iomem *port, void *buf, unsigned long count)
 {
 	insw((unsigned long __force)port, buf, count);
 }
+#define readsw readsw
 
 static inline void readsl(void __iomem *port, void *buf, unsigned long count)
 {
 	insl((unsigned long __force)port, buf, count);
 }
+#define readsl readsl
 
 static inline void writesb(void __iomem *port, const void *buf, unsigned long count)
 {
 	outsb((unsigned long __force)port, buf, count);
 }
+#define writesb writesb
 
 static inline void writesw(void __iomem *port, const void *buf, unsigned long count)
 {
 	outsw((unsigned long __force)port, buf, count);
 }
+#define writesw writesw
 
 static inline void writesl(void __iomem *port, const void *buf, unsigned long count)
 {
 	outsl((unsigned long __force)port, buf, count);
 }
+#define writesl writesl
 
 #define ioread8_rep(p,d,l)	readsb(p,d,l)
 #define ioread16_rep(p,d,l)	readsw(p,d,l)
@@ -344,6 +358,7 @@ static inline void memset_io(volatile void __iomem *dst, int c, __kernel_size_t
 		d++;
 	}
 }
+#define memset_io memset_io
 
 static inline void sbus_memcpy_fromio(void *dst, const volatile void __iomem *src,
 				      __kernel_size_t n)
@@ -369,6 +384,7 @@ static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
 		src++;
 	}
 }
+#define memcpy_fromio memcpy_fromio
 
 static inline void sbus_memcpy_toio(volatile void __iomem *dst, const void *src,
 				    __kernel_size_t n)
@@ -395,6 +411,7 @@ static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
 		d++;
 	}
 }
+#define memcpy_toio memcpy_toio
 
 #ifdef __KERNEL__
 
@@ -412,7 +429,9 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 static inline void __iomem *ioremap_np(unsigned long offset, unsigned long size)
 {
 	return NULL;
+
 }
+#define ioremap_np ioremap_np
 
 static inline void iounmap(volatile void __iomem *addr)
 {
@@ -432,10 +451,13 @@ static inline void iounmap(volatile void __iomem *addr)
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr);
 void ioport_unmap(void __iomem *);
+#define ioport_map ioport_map
+#define ioport_unmap ioport_unmap
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 void pci_iounmap(struct pci_dev *dev, void __iomem *);
+#define pci_iounmap pci_iounmap
 
 static inline int sbus_can_dma_64bit(void)
 {
-- 
2.35.1

