Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043835A4A22
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiH2Lee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiH2Lcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FFE74DD6;
        Mon, 29 Aug 2022 04:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A89B80FB3;
        Mon, 29 Aug 2022 11:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFF0C433C1;
        Mon, 29 Aug 2022 11:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771943;
        bh=DEen8Wx9SWDeZ4BN4+Uh+Y3+X9vpHk7Dx7Iq9uXiD6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad2iqDXenr0H7Vctd5JFdspuKBO1Mo/+VpTD3tpI6zquHxvOE2pDzxDzDJyKoHqzJ
         zDYTg2RrgoHH+lrgl6ALZkbO6oPWa1Cqf4fzU/gIBIjLRUgRCOmZBBp6i41i0LOfVQ
         gVRxOE7qx6d0+RXDP4AhZBMfPkYBOOLz4QC5Y7Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jagdish Gediya <jvgediya@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 147/158] arm64: fix rodata=full
Date:   Mon, 29 Aug 2022 12:59:57 +0200
Message-Id: <20220829105815.256833196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 2e8cff0a0eee87b27f0cf87ad8310eb41b5886ab upstream.

On arm64, "rodata=full" has been suppored (but not documented) since
commit:

  c55191e96caa9d78 ("arm64: mm: apply r/o permissions of VM areas to its linear alias as well")

As it's necessary to determine the rodata configuration early during
boot, arm64 has an early_param() handler for this, whereas init/main.c
has a __setup() handler which is run later.

Unfortunately, this split meant that since commit:

  f9a40b0890658330 ("init/main.c: return 1 from handled __setup() functions")

... passing "rodata=full" would result in a spurious warning from the
__setup() handler (though RO permissions would be configured
appropriately).

Further, "rodata=full" has been broken since commit:

  0d6ea3ac94ca77c5 ("lib/kstrtox.c: add "false"/"true" support to kstrtobool()")

... which caused strtobool() to parse "full" as false (in addition to
many other values not documented for the "rodata=" kernel parameter.

This patch fixes this breakage by:

* Moving the core parameter parser to an __early_param(), such that it
  is available early.

* Adding an (optional) arch hook which arm64 can use to parse "full".

* Updating the documentation to mention that "full" is valid for arm64.

* Having the core parameter parser handle "on" and "off" explicitly,
  such that any undocumented values (e.g. typos such as "ful") are
  reported as errors rather than being silently accepted.

Note that __setup() and early_param() have opposite conventions for
their return values, where __setup() uses 1 to indicate a parameter was
handled and early_param() uses 0 to indicate a parameter was handled.

Fixes: f9a40b089065 ("init/main.c: return 1 from handled __setup() functions")
Fixes: 0d6ea3ac94ca ("lib/kstrtox.c: add "false"/"true" support to kstrtobool()")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jagdish Gediya <jvgediya@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220817154022.3974645-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    2 ++
 arch/arm64/include/asm/setup.h                  |   17 +++++++++++++++++
 arch/arm64/mm/mmu.c                             |   18 ------------------
 init/main.c                                     |   18 +++++++++++++++---
 4 files changed, 34 insertions(+), 21 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5260,6 +5260,8 @@
 	rodata=		[KNL]
 		on	Mark read-only kernel memory as read-only (default).
 		off	Leave read-only kernel memory writable for debugging.
+		full	Mark read-only kernel memory and aliases as read-only
+		        [arm64]
 
 	rockchip.usb_uart
 			Enable the uart passthrough on the designated usb port
--- a/arch/arm64/include/asm/setup.h
+++ b/arch/arm64/include/asm/setup.h
@@ -3,6 +3,8 @@
 #ifndef __ARM64_ASM_SETUP_H
 #define __ARM64_ASM_SETUP_H
 
+#include <linux/string.h>
+
 #include <uapi/asm/setup.h>
 
 void *get_early_fdt_ptr(void);
@@ -14,4 +16,19 @@ void early_fdt_map(u64 dt_phys);
 extern phys_addr_t __fdt_pointer __initdata;
 extern u64 __cacheline_aligned boot_args[4];
 
+static inline bool arch_parse_debug_rodata(char *arg)
+{
+	extern bool rodata_enabled;
+	extern bool rodata_full;
+
+	if (arg && !strcmp(arg, "full")) {
+		rodata_enabled = true;
+		rodata_full = true;
+		return true;
+	}
+
+	return false;
+}
+#define arch_parse_debug_rodata arch_parse_debug_rodata
+
 #endif
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -625,24 +625,6 @@ static void __init map_kernel_segment(pg
 	vm_area_add_early(vma);
 }
 
-static int __init parse_rodata(char *arg)
-{
-	int ret = strtobool(arg, &rodata_enabled);
-	if (!ret) {
-		rodata_full = false;
-		return 0;
-	}
-
-	/* permit 'full' in addition to boolean options */
-	if (strcmp(arg, "full"))
-		return -EINVAL;
-
-	rodata_enabled = true;
-	rodata_full = true;
-	return 0;
-}
-early_param("rodata", parse_rodata);
-
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
--- a/init/main.c
+++ b/init/main.c
@@ -1446,13 +1446,25 @@ static noinline void __init kernel_init_
 
 #if defined(CONFIG_STRICT_KERNEL_RWX) || defined(CONFIG_STRICT_MODULE_RWX)
 bool rodata_enabled __ro_after_init = true;
+
+#ifndef arch_parse_debug_rodata
+static inline bool arch_parse_debug_rodata(char *str) { return false; }
+#endif
+
 static int __init set_debug_rodata(char *str)
 {
-	if (strtobool(str, &rodata_enabled))
+	if (arch_parse_debug_rodata(str))
+		return 0;
+
+	if (str && !strcmp(str, "on"))
+		rodata_enabled = true;
+	else if (str && !strcmp(str, "off"))
+		rodata_enabled = false;
+	else
 		pr_warn("Invalid option string for rodata: '%s'\n", str);
-	return 1;
+	return 0;
 }
-__setup("rodata=", set_debug_rodata);
+early_param("rodata", set_debug_rodata);
 #endif
 
 #ifdef CONFIG_STRICT_KERNEL_RWX


