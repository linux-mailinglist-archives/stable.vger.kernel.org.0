Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E806F594CC8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347015AbiHPAiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351888AbiHPAge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A554518A8F9;
        Mon, 15 Aug 2022 13:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A70E261232;
        Mon, 15 Aug 2022 20:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B9AC433C1;
        Mon, 15 Aug 2022 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595878;
        bh=YTiMFhoSMMnGNTHiEsgFEmAmD1SPaL3yjJsXjV8eRAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBWXYBV7enf5Z5dcD7IlmwH/qsvMKHvZ3xSZu984xtkFbWrqktPaYpddE1zGu3Ae6
         UgXKnzVvurq6H9ss4hguc6sOV6GYvAeW2XBVeDBkbBtwfct6xSNq3xORcs70X6nze8
         Qm2GXTMRpK1Q/xY3MTZuOZ1f8u9AB3Lff1AbKjA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Juergen Gross <jgross@suse.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0871/1157] xen: dont require virtio with grants for non-PV guests
Date:   Mon, 15 Aug 2022 20:03:47 +0200
Message-Id: <20220815180514.310806817@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 251e90e7e346a23742b90e2c4db19d322e071d99 ]

Commit fa1f57421e0b ("xen/virtio: Enable restricted memory access using
Xen grant mappings") introduced a new requirement for using virtio
devices: the backend now needs to support the VIRTIO_F_ACCESS_PLATFORM
feature.

This is an undue requirement for non-PV guests, as those can be operated
with existing backends without any problem, as long as those backends
are running in dom0.

Per default allow virtio devices without grant support for non-PV
guests.

On Arm require VIRTIO_F_ACCESS_PLATFORM for devices having been listed
in the device tree to use grants.

Add a new config item to always force use of grants for virtio.

Fixes: fa1f57421e0b ("xen/virtio: Enable restricted memory access using Xen grant mappings")
Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Tested-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com> # Arm64 guest using Xen
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20220622063838.8854-4-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c     |  4 +++-
 arch/x86/xen/enlighten_hvm.c |  4 +++-
 arch/x86/xen/enlighten_pv.c  |  5 ++++-
 drivers/xen/Kconfig          |  9 +++++++++
 drivers/xen/grant-dma-ops.c  | 10 ++++++++++
 include/xen/xen-ops.h        |  9 +++++++++
 include/xen/xen.h            |  8 --------
 7 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 1f9c3ba32833..93c8ccbf2982 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -34,6 +34,7 @@
 #include <linux/timekeeping.h>
 #include <linux/timekeeper_internal.h>
 #include <linux/acpi.h>
+#include <linux/virtio_anchor.h>
 
 #include <linux/mm.h>
 
@@ -443,7 +444,8 @@ static int __init xen_guest_init(void)
 	if (!xen_domain())
 		return 0;
 
-	xen_set_restricted_virtio_memory_access();
+	if (IS_ENABLED(CONFIG_XEN_VIRTIO))
+		virtio_set_mem_acc_cb(xen_virtio_mem_acc);
 
 	if (!acpi_disabled)
 		xen_acpi_guest_init();
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index 8b71b1dd7639..28762f800596 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/kexec.h>
 #include <linux/memblock.h>
+#include <linux/virtio_anchor.h>
 
 #include <xen/features.h>
 #include <xen/events.h>
@@ -195,7 +196,8 @@ static void __init xen_hvm_guest_init(void)
 	if (xen_pv_domain())
 		return;
 
-	xen_set_restricted_virtio_memory_access();
+	if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT))
+		virtio_set_mem_acc_cb(virtio_require_restricted_mem_acc);
 
 	init_hvm_pv_info();
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 70fb2ea85e90..0ed2e487a693 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -31,6 +31,7 @@
 #include <linux/gfp.h>
 #include <linux/edd.h>
 #include <linux/reboot.h>
+#include <linux/virtio_anchor.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>
@@ -109,7 +110,9 @@ static DEFINE_PER_CPU(struct tls_descs, shadow_tls_desc);
 
 static void __init xen_pv_init_platform(void)
 {
-	xen_set_restricted_virtio_memory_access();
+	/* PV guests can't operate virtio devices without grants. */
+	if (IS_ENABLED(CONFIG_XEN_VIRTIO))
+		virtio_set_mem_acc_cb(virtio_require_restricted_mem_acc);
 
 	populate_extra_pte(fix_to_virt(FIX_PARAVIRT_BOOTMAP));
 
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index bfd5f4f706bc..a65bd92121a5 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -355,4 +355,13 @@ config XEN_VIRTIO
 
 	  If in doubt, say n.
 
+config XEN_VIRTIO_FORCE_GRANT
+	bool "Require Xen virtio support to use grants"
+	depends on XEN_VIRTIO
+	help
+	  Require virtio for Xen guests to use grant mappings.
+	  This will avoid the need to give the backend the right to map all
+	  of the guest memory. This will need support on the backend side
+	  (e.g. qemu or kernel, depending on the virtio device types used).
+
 endmenu
diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index fc0142484001..8973fc1e9ccc 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -12,6 +12,8 @@
 #include <linux/of.h>
 #include <linux/pfn.h>
 #include <linux/xarray.h>
+#include <linux/virtio_anchor.h>
+#include <linux/virtio.h>
 #include <xen/xen.h>
 #include <xen/xen-ops.h>
 #include <xen/grant_table.h>
@@ -287,6 +289,14 @@ bool xen_is_grant_dma_device(struct device *dev)
 	return has_iommu;
 }
 
+bool xen_virtio_mem_acc(struct virtio_device *dev)
+{
+	if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT))
+		return true;
+
+	return xen_is_grant_dma_device(dev->dev.parent);
+}
+
 void xen_grant_setup_dma_ops(struct device *dev)
 {
 	struct xen_grant_dma_data *data;
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 80546960f8b7..dae0f350c678 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -5,6 +5,7 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/efi.h>
+#include <linux/virtio_anchor.h>
 #include <xen/features.h>
 #include <asm/xen/interface.h>
 #include <xen/interface/vcpu.h>
@@ -217,6 +218,7 @@ static inline void xen_preemptible_hcall_end(void) { }
 #ifdef CONFIG_XEN_GRANT_DMA_OPS
 void xen_grant_setup_dma_ops(struct device *dev);
 bool xen_is_grant_dma_device(struct device *dev);
+bool xen_virtio_mem_acc(struct virtio_device *dev);
 #else
 static inline void xen_grant_setup_dma_ops(struct device *dev)
 {
@@ -225,6 +227,13 @@ static inline bool xen_is_grant_dma_device(struct device *dev)
 {
 	return false;
 }
+
+struct virtio_device;
+
+static inline bool xen_virtio_mem_acc(struct virtio_device *dev)
+{
+	return false;
+}
 #endif /* CONFIG_XEN_GRANT_DMA_OPS */
 
 #endif /* INCLUDE_XEN_OPS_H */
diff --git a/include/xen/xen.h b/include/xen/xen.h
index ac5a144c6a65..a99bab817523 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -52,14 +52,6 @@ bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 extern u64 xen_saved_max_mem_size;
 #endif
 
-#include <linux/virtio_anchor.h>
-
-static inline void xen_set_restricted_virtio_memory_access(void)
-{
-	if (IS_ENABLED(CONFIG_XEN_VIRTIO) && xen_domain())
-		virtio_set_mem_acc_cb(virtio_require_restricted_mem_acc);
-}
-
 #ifdef CONFIG_XEN_UNPOPULATED_ALLOC
 int xen_alloc_unpopulated_pages(unsigned int nr_pages, struct page **pages);
 void xen_free_unpopulated_pages(unsigned int nr_pages, struct page **pages);
-- 
2.35.1



