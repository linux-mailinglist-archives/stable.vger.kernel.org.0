Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34F01577FA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgBJND4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgBJMkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AFAD20873;
        Mon, 10 Feb 2020 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338420;
        bh=cDztcK+reDB/TcP8f2+T4tcfLGtQ5Z92p23Ou4/MWwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLQrTFyZKQ57uNrJvqNko6YPy1AAeMfOuyyybgP8b7AWgh2RYB40e1peOZKL6vadl
         om1gl26DSskVDytrfuroEPvUuqWSb7qVuAlVAA+6fl3AsFtuw7aiN8xH6ir+KtV4sr
         2QIHfItALlFRO9hQdGDcLPIUsrbqQx/LvtQi61DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.5 138/367] of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc
Date:   Mon, 10 Feb 2020 04:30:51 -0800
Message-Id: <20200210122437.597135691@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.16+
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Kconfig |    1 +
 drivers/of/Kconfig   |    4 ++++
 drivers/of/address.c |    6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -238,6 +238,7 @@ config PPC
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
 	select NEED_SG_DMA_LENGTH
 	select OF
+	select OF_DMA_DEFAULT_COHERENT		if !NOT_COHERENT_CACHE
 	select OF_EARLY_FLATTREE
 	select OLD_SIGACTION			if PPC32
 	select OLD_SIGSUSPEND
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
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -995,12 +995,16 @@ out:
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


