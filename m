Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983AA6C55D9
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjCVUBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjCVUA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2EB6A1D4;
        Wed, 22 Mar 2023 12:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B657A622B4;
        Wed, 22 Mar 2023 19:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E961CC433D2;
        Wed, 22 Mar 2023 19:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515108;
        bh=U2nfdusHcmUfo5Dxeanu0y7DchbxUE5e7NRJhWSoTAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y96lU6qQVehYEQLiHp6CrkcsZoShYLoEqmgkZROu2HTfiSBaPiDaluFx+ibhCrSIq
         fbCWjLbLnYeiDpAunHff6ixhE4KNq2hBZNHdRUMEul8PLDe72L2NmtljKH6tGn4Rln
         rRzBHQh8zReZ+95DT5ECNqgeHcoZpm4mvZlHkHw0pB4R9Ie63VZrK6TZyF+XBONYIX
         0TFFsS1TpXcsNQ4GA0ZaxAYNwr1vqZ6YBDUAkaVa+1OAivVp26g+vG2PclVjSFMTM7
         rDqH0ikLCMhPk3qAC7WiFYV+V+stZeQrPKkl38Rbm6kCjNWhYFTj4/jdWQ1gUMQEKo
         JahLDeSv+UnaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 6.2 23/45] x86/PVH: obtain VGA console info in Dom0
Date:   Wed, 22 Mar 2023 15:56:17 -0400
Message-Id: <20230322195639.1995821-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 934ef33ee75c3846f605f18b65048acd147e3918 ]

A new platform-op was added to Xen to allow obtaining the same VGA
console information PV Dom0 is handed. Invoke the new function and have
the output data processed by xen_init_vga().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>

Link: https://lore.kernel.org/r/8f315e92-7bda-c124-71cc-478ab9c5e610@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/Makefile            |  2 +-
 arch/x86/xen/enlighten_pv.c      |  3 ++-
 arch/x86/xen/enlighten_pvh.c     | 13 +++++++++++++
 arch/x86/xen/vga.c               |  5 ++---
 arch/x86/xen/xen-ops.h           |  7 ++++---
 include/xen/interface/platform.h |  3 +++
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3c5b52fbe4a7f..a9ec8c9f5c5dd 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -45,6 +45,6 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 
-obj-$(CONFIG_XEN_PV_DOM0)	+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= vga.o
 
 obj-$(CONFIG_XEN_EFI)		+= efi.o
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 5b13796628770..68f5f5d209dfa 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1389,7 +1389,8 @@ asmlinkage __visible void __init xen_start_kernel(struct start_info *si)
 
 		x86_platform.set_legacy_features =
 				xen_dom0_set_legacy_features;
-		xen_init_vga(info, xen_start_info->console.dom0.info_size);
+		xen_init_vga(info, xen_start_info->console.dom0.info_size,
+			     &boot_params.screen_info);
 		xen_start_info->console.domU.mfn = 0;
 		xen_start_info->console.domU.evtchn = 0;
 
diff --git a/arch/x86/xen/enlighten_pvh.c b/arch/x86/xen/enlighten_pvh.c
index bcae606bbc5cf..1da44aca896c6 100644
--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -43,6 +43,19 @@ void __init xen_pvh_init(struct boot_params *boot_params)
 	x86_init.oem.banner = xen_banner;
 
 	xen_efi_init(boot_params);
+
+	if (xen_initial_domain()) {
+		struct xen_platform_op op = {
+			.cmd = XENPF_get_dom0_console,
+		};
+		long ret = HYPERVISOR_platform_op(&op);
+
+		if (ret > 0)
+			xen_init_vga(&op.u.dom0_console,
+				     min(ret * sizeof(char),
+					 sizeof(op.u.dom0_console)),
+				     &boot_params->screen_info);
+	}
 }
 
 void __init mem_map_via_hcall(struct boot_params *boot_params_p)
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
index 14ea32e734d59..d97adab8420f4 100644
--- a/arch/x86/xen/vga.c
+++ b/arch/x86/xen/vga.c
@@ -9,10 +9,9 @@
 
 #include "xen-ops.h"
 
-void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
+void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size,
+			 struct screen_info *screen_info)
 {
-	struct screen_info *screen_info = &boot_params.screen_info;
-
 	/* This is drawn from a dump from vgacon:startup in
 	 * standard Linux. */
 	screen_info->orig_video_mode = 3;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9a8bb972193d8..a10903785a338 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -108,11 +108,12 @@ static inline void xen_uninit_lock_cpu(int cpu)
 
 struct dom0_vga_console_info;
 
-#ifdef CONFIG_XEN_PV_DOM0
-void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+#ifdef CONFIG_XEN_DOM0
+void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size,
+			 struct screen_info *);
 #else
 static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
-				       size_t size)
+				       size_t size, struct screen_info *si)
 {
 }
 #endif
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 655d92e803e14..79a443c65ea93 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -483,6 +483,8 @@ struct xenpf_symdata {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_symdata);
 
+#define XENPF_get_dom0_console 64
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -506,6 +508,7 @@ struct xen_platform_op {
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		struct xenpf_symdata           symdata;
+		struct dom0_vga_console_info   dom0_console;
 		uint8_t                        pad[128];
 	} u;
 };
-- 
2.39.2

