Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62A9594193
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347018AbiHOVcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiHOVbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:31:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FCBF076B;
        Mon, 15 Aug 2022 12:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5046B81062;
        Mon, 15 Aug 2022 19:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07601C433D6;
        Mon, 15 Aug 2022 19:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591455;
        bh=CnsTbjLDuDtH0/cJrjat7Y4T94D3EJ6Ue+A+1sVKQvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY8DGInxQZ1N1pobkfVqJFQdZWaIJ79O5g3qzWcoQIfS64Yueco6YOeAchnRePPHZ
         O10HIkNlxv+6FWIhRgh8J130UB01yBWci6SaobzFufmGHPYV/Naw1v7v40tqlilpbZ
         abY9yF127uQRyDZXNZuR+QOjzT5t/VCWYzILp6C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0586/1095] iio: core: Fix IIO_ALIGN and rename as it was not sufficiently large
Date:   Mon, 15 Aug 2022 19:59:45 +0200
Message-Id: <20220815180453.832686798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 12c4efe3509b8018e76ea3ebda8227cb53bf5887 ]

Discussion of the series:
https://lore.kernel.org/all/20220405135758.774016-1-catalin.marinas@arm.com/
mm, arm64: Reduce ARCH_KMALLOC_MINALIGN brought to my attention that
our current IIO usage of L1CACHE_ALIGN is insufficient as their are Arm
platforms out their with non coherent DMA and larger cache lines at
at higher levels of their cache hierarchy.

Rename the define to make it's purpose more explicit. It will be used
much more widely going forwards (to replace incorrect ____cacheline_aligned
markings.

Note this patch will greatly reduce the padding on some architectures
that have smaller requirements for DMA safe buffers.

The history of changing values of ARCH_KMALLOC_MINALIGN via
ARCH_DMA_MINALIGN on arm64 is rather complex. I'm not tagging this
as fixing a particular patch from that route as it's not clear what to tag.

Most recently a change to bring them back inline was reverted because
of some Qualcomm Kryo cores with an L2 cache with 128-byte lines
sitting above the point of coherency.

c1132702c71f Revert "arm64: cache: Lower ARCH_DMA_MINALIGN to 64 (L1_CACHE_BYTES)"
That reverts:
65688d2a05de arm64: cache: Lower ARCH_DMA_MINALIGN to 64 (L1_CACHE_BYTES) which
refers to the change originally being motivated by Thunder x1 performance
rather than correctness.

Fixes: 6f7c8ee585e9d ("staging:iio: Add ability to allocate private data space to iio_allocate_device")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/adi-axi-adc.c   |  7 ++++---
 drivers/iio/industrialio-core.c |  4 ++--
 include/linux/iio/iio.h         | 10 ++++++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index a9e655e69eaa..8ffabdaf841e 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -84,7 +84,8 @@ void *adi_axi_adc_conv_priv(struct adi_axi_adc_conv *conv)
 {
 	struct adi_axi_adc_client *cl = conv_to_client(conv);
 
-	return (char *)cl + ALIGN(sizeof(struct adi_axi_adc_client), IIO_ALIGN);
+	return (char *)cl + ALIGN(sizeof(struct adi_axi_adc_client),
+				  IIO_DMA_MINALIGN);
 }
 EXPORT_SYMBOL_GPL(adi_axi_adc_conv_priv);
 
@@ -169,9 +170,9 @@ static struct adi_axi_adc_conv *adi_axi_adc_conv_register(struct device *dev,
 	struct adi_axi_adc_client *cl;
 	size_t alloc_size;
 
-	alloc_size = ALIGN(sizeof(struct adi_axi_adc_client), IIO_ALIGN);
+	alloc_size = ALIGN(sizeof(struct adi_axi_adc_client), IIO_DMA_MINALIGN);
 	if (sizeof_priv)
-		alloc_size += ALIGN(sizeof_priv, IIO_ALIGN);
+		alloc_size += ALIGN(sizeof_priv, IIO_DMA_MINALIGN);
 
 	cl = kzalloc(alloc_size, GFP_KERNEL);
 	if (!cl)
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index b2d2b42614d3..e5aed96de8f3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1655,7 +1655,7 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 
 	alloc_size = sizeof(struct iio_dev_opaque);
 	if (sizeof_priv) {
-		alloc_size = ALIGN(alloc_size, IIO_ALIGN);
+		alloc_size = ALIGN(alloc_size, IIO_DMA_MINALIGN);
 		alloc_size += sizeof_priv;
 	}
 
@@ -1665,7 +1665,7 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 
 	indio_dev = &iio_dev_opaque->indio_dev;
 	indio_dev->priv = (char *)iio_dev_opaque +
-		ALIGN(sizeof(struct iio_dev_opaque), IIO_ALIGN);
+		ALIGN(sizeof(struct iio_dev_opaque), IIO_DMA_MINALIGN);
 
 	indio_dev->dev.parent = parent;
 	indio_dev->dev.type = &iio_device_type;
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index faf00f2c0be6..c4ce02293f1f 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -9,6 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/cdev.h>
+#include <linux/slab.h>
 #include <linux/iio/types.h>
 #include <linux/of.h>
 /* IIO TODO LIST */
@@ -657,8 +658,13 @@ static inline void *iio_device_get_drvdata(const struct iio_dev *indio_dev)
 	return dev_get_drvdata(&indio_dev->dev);
 }
 
-/* Can we make this smaller? */
-#define IIO_ALIGN L1_CACHE_BYTES
+/*
+ * Used to ensure the iio_priv() structure is aligned to allow that structure
+ * to in turn include IIO_DMA_MINALIGN'd elements such as buffers which
+ * must not share  cachelines with the rest of the structure, thus making
+ * them safe for use with non-coherent DMA.
+ */
+#define IIO_DMA_MINALIGN ARCH_KMALLOC_MINALIGN
 struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv);
 
 /* The information at the returned address is guaranteed to be cacheline aligned */
-- 
2.35.1



