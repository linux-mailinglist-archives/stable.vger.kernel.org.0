Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1EB6D48AD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjDCOay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbjDCOay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:30:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3F931996
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 518FDB81C52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE166C433EF;
        Mon,  3 Apr 2023 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532250;
        bh=AqSXgRIi/BJPiDJTWepOKNXUrQyyOJofAKS+fRFpeQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJOE5dbLSVa8KW88KdluudrSHSrqKItTuqy8KouBZ7D+QoENW6NUhOdp1tTauy4gz
         B55y428eZQPgXVLI4YPSdQbGYwnP+nfgbOqSkFiklR/CxXAaM5EDbsas1A3EepkPY7
         HFaVhJRNUpk24qlScd5DA5vbjabzEdm/ICkxRE3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/99] x86/PVH: obtain VGA console info in Dom0
Date:   Mon,  3 Apr 2023 16:08:34 +0200
Message-Id: <20230403140356.562484464@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4953260e281c3..40b5779fce21c 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 
-obj-$(CONFIG_XEN_PV_DOM0)	+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= vga.o
 
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 561aad13412f9..998db0257e2ad 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1353,7 +1353,8 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
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
index e336f223f7f47..93697109592c3 100644
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
index 16aed4b121297..71f31032c635f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -110,11 +110,12 @@ static inline void xen_uninit_lock_cpu(int cpu)
 
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
index 732efb08c3e17..744bc41355678 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -500,6 +500,8 @@ struct xenpf_symdata {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_symdata);
 
+#define XENPF_get_dom0_console 64
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -523,6 +525,7 @@ struct xen_platform_op {
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		struct xenpf_symdata           symdata;
+		struct dom0_vga_console_info   dom0_console;
 		uint8_t                        pad[128];
 	} u;
 };
-- 
2.39.2



