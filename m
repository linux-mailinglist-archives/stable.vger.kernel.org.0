Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35301DB647
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgETOXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:23:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33256 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00036v-Cq; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DVj-Au; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christian Zigotzky" <chzigotzky@xenosoft.de>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Rob Herring" <robh@kernel.org>
Date:   Wed, 20 May 2020 15:14:53 +0100
Message-ID: <lsq.1589984009.147114071@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 85/99] of: Add OF_DMA_DEFAULT_COHERENT & select it on
 powerpc
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit dabf6b36b83a18d57e3d4b9d50544ed040d86255 upstream.

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
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/Kconfig | 1 +
 drivers/of/Kconfig   | 4 ++++
 drivers/of/address.c | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -89,6 +89,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
 	select OF
+	select OF_DMA_DEFAULT_COHERENT		if !NOT_COHERENT_CACHE
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
 	select HAVE_FTRACE_MCOUNT_RECORD
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -78,4 +78,8 @@ config OF_RESERVED_MEM
 	help
 	  Helpers to allow for reservation of memory regions
 
+config OF_DMA_DEFAULT_COHERENT
+	# arches should select this if DMA is coherent by default for OF devices
+	bool
+
 endmenu # OF
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -812,12 +812,16 @@ EXPORT_SYMBOL_GPL(of_dma_get_range);
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

