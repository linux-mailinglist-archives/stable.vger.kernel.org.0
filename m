Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4042F153CDE
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 03:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBFCFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 21:05:39 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34276 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBFCFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 21:05:38 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 98B29201ECB;
        Thu,  6 Feb 2020 03:05:36 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 69329201ECE;
        Thu,  6 Feb 2020 03:05:34 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 51C9040246;
        Thu,  6 Feb 2020 10:05:31 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-devel@linux.nxdi.nxp.com, Li Yang <leoyang.li@nxp.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org
Subject: [PATCH] of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc
Date:   Thu,  6 Feb 2020 10:03:22 +0800
Message-Id: <20200206020322.20208-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

There's an OF helper called of_dma_is_coherent(), which checks if a
device has a "dma-coherent" property to see if the device is coherent
for DMA.

But on some platforms devices are coherent by default, and on some
platforms it's not possible to update existing device trees to add the
"dma-coherent" property.

So add a Kconfig symbol to allow arch code to tell
of_dma_is_coherent() that devices are coherent by default, regardless
of the presence of the property.

Select that symbol on powerpc when NOT_COHERENT_CACHE is not set, ie.
when the system has a coherent cache.

Fixes: 92ea637edea3 ("of: introduce of_dma_is_coherent() helper")
Cc: stable@vger.kernel.org # v3.16+
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 arch/powerpc/Kconfig | 1 +
 drivers/of/Kconfig   | 4 ++++
 drivers/of/address.c | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2a70433..fd05ff4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -237,6 +237,7 @@ config PPC
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
 	select NEED_SG_DMA_LENGTH
 	select OF
+	select OF_DMA_DEFAULT_COHERENT		if !NOT_COHERENT_CACHE
 	select OF_EARLY_FLATTREE
 	select OLD_SIGACTION			if PPC32
 	select OLD_SIGSUSPEND
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 37c2ccb..d916186 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -103,4 +103,8 @@ config OF_OVERLAY
 config OF_NUMA
 	bool
 
+config OF_DMA_DEFAULT_COHERENT
+	# arches should select this if DMA is coherent by default for OF devices
+	bool
+
 endif # OF
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 978427a..8f74c46 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -998,12 +998,16 @@ EXPORT_SYMBOL_GPL(of_dma_get_range);
  * @np:	device node
  *
  * It returns true if "dma-coherent" property was found
- * for this device in DT.
+ * for this device in the DT, or if DMA is coherent by
+ * default for OF devices on the current platform.
  */
 bool of_dma_is_coherent(struct device_node *np)
 {
 	struct device_node *node = of_node_get(np);
 
+	if (IS_ENABLED(CONFIG_OF_DMA_DEFAULT_COHERENT))
+		return true;
+
 	while (node) {
 		if (of_property_read_bool(node, "dma-coherent")) {
 			of_node_put(node);
-- 
2.7.4

