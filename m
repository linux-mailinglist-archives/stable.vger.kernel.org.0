Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718A814C9B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfEFOlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfEFOlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:41:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD3421655;
        Mon,  6 May 2019 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153711;
        bh=VKIaQHqILKktV1uilDIzU4auAHkCA0xrJuZDJAa28PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eos6Lut92D8eYftrGuc3Wmn8qKJ6Sy30IvD7ckot3IbianDtbw8GPN8Hl3d4IDnxG
         OPwnvH7lwiDCsVsatinfcT9ofByVifUlG6rfS95EVrHg3Mh1IxSCKPEPkGmWaYA/bg
         A9pC60QSxLWnsEYNd9AbN4t0sVl+kaZe79NvjAWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 68/99] ARM: iop: dont use using 64-bit DMA masks
Date:   Mon,  6 May 2019 16:32:41 +0200
Message-Id: <20190506143100.338219925@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2125801ccce19249708ca3245d48998e70569ab8 ]

clang warns about statically defined DMA masks from the DMA_BIT_MASK
macro with length 64:

 arch/arm/mach-iop13xx/setup.c:303:35: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
 static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(64);
                                  ^~~~~~~~~~~~~~~~
 include/linux/dma-mapping.h:141:54: note: expanded from macro 'DMA_BIT_MASK'
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                                      ^ ~~~

The ones in iop shouldn't really be 64 bit masks, so changing them
to what the driver can support avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-iop13xx/setup.c |  8 ++++----
 arch/arm/mach-iop13xx/tpmi.c  | 10 +++++-----
 arch/arm/plat-iop/adma.c      |  6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 53c316f7301e..fe4932fda01d 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -300,7 +300,7 @@ static struct resource iop13xx_adma_2_resources[] = {
 	}
 };
 
-static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(64);
+static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(32);
 static struct iop_adma_platform_data iop13xx_adma_0_data = {
 	.hw_id = 0,
 	.pool_size = PAGE_SIZE,
@@ -324,7 +324,7 @@ static struct platform_device iop13xx_adma_0_channel = {
 	.resource = iop13xx_adma_0_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_0_data,
 	},
 };
@@ -336,7 +336,7 @@ static struct platform_device iop13xx_adma_1_channel = {
 	.resource = iop13xx_adma_1_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_1_data,
 	},
 };
@@ -348,7 +348,7 @@ static struct platform_device iop13xx_adma_2_channel = {
 	.resource = iop13xx_adma_2_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_2_data,
 	},
 };
diff --git a/arch/arm/mach-iop13xx/tpmi.c b/arch/arm/mach-iop13xx/tpmi.c
index db511ec2b1df..116feb6b261e 100644
--- a/arch/arm/mach-iop13xx/tpmi.c
+++ b/arch/arm/mach-iop13xx/tpmi.c
@@ -152,7 +152,7 @@ static struct resource iop13xx_tpmi_3_resources[] = {
 	}
 };
 
-u64 iop13xx_tpmi_mask = DMA_BIT_MASK(64);
+u64 iop13xx_tpmi_mask = DMA_BIT_MASK(32);
 static struct platform_device iop13xx_tpmi_0_device = {
 	.name = "iop-tpmi",
 	.id = 0,
@@ -160,7 +160,7 @@ static struct platform_device iop13xx_tpmi_0_device = {
 	.resource = iop13xx_tpmi_0_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -171,7 +171,7 @@ static struct platform_device iop13xx_tpmi_1_device = {
 	.resource = iop13xx_tpmi_1_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -182,7 +182,7 @@ static struct platform_device iop13xx_tpmi_2_device = {
 	.resource = iop13xx_tpmi_2_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -193,7 +193,7 @@ static struct platform_device iop13xx_tpmi_3_device = {
 	.resource = iop13xx_tpmi_3_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
diff --git a/arch/arm/plat-iop/adma.c b/arch/arm/plat-iop/adma.c
index a4d1f8de3b5b..d9612221e484 100644
--- a/arch/arm/plat-iop/adma.c
+++ b/arch/arm/plat-iop/adma.c
@@ -143,7 +143,7 @@ struct platform_device iop3xx_dma_0_channel = {
 	.resource = iop3xx_dma_0_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_dma_0_data,
 	},
 };
@@ -155,7 +155,7 @@ struct platform_device iop3xx_dma_1_channel = {
 	.resource = iop3xx_dma_1_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_dma_1_data,
 	},
 };
@@ -167,7 +167,7 @@ struct platform_device iop3xx_aau_channel = {
 	.resource = iop3xx_aau_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_aau_data,
 	},
 };
-- 
2.20.1



