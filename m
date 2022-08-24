Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C8D59FA00
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiHXMa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiHXMaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:30:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D1159240
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:30:24 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 67so8149048pfv.2
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jx5D2mTV+ExxV8ji9PCBz7vQf+NrUEKj5YJ/dsZ+EGc=;
        b=lUY19Y9Hd9OS3UivjnlZCoXY1Bh/MTUqfkDMO9l+Ox5gj32ooZicggfrJnvlMXKAxd
         i6VcOEC9xDtmg24ihkGf9Bwg0RxIXqixVTMjVD+GZeN7ef5DdDVkFH5+DHSC9RPtO9V4
         jth5ptsa24LpkiVe5qvE6wUGZyi5npyqj+m8k2axWb3fVLkZTlxCuzsOTa0xXY21QB6Z
         gEp/5lAH7mxAkaw1gmfsBWG/yAv9K3ssyIdSpy2Lxcuvv6q1JlNqo2goBU4dYUOOoif2
         BnMNA10IN8KB8dU0VZdV/C4Uo43b7vpAVGp3FCFR1c6EKo1L2vnAbMGTlHnP1khhB6Ga
         kR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jx5D2mTV+ExxV8ji9PCBz7vQf+NrUEKj5YJ/dsZ+EGc=;
        b=m5ntCgmVquOHzqRTBqo4r50Vh9tk8NTPOZhnKHKAQheI2OvwKoQKIZhMb/4CiZQ9OD
         9K10k8BrVNbPkLes8gSnIZKHDrGAJS7NIcBP2mCzF9kM3L0shJkA6flxweswJEi/LpoO
         01H8nBXqCkG3Y32nCgmCv0pO/f+FCFfk/OP7DcNYwDMzhFeAOzGKTQFCRYholVInlJQS
         cDfn3GPuMr0Fyvt0jGxo1Gwa1H5sBShfbyd/PJQUx5PDkHvGgZkzqPo/jtsdUlxIypMX
         VdyC422dXIAlVvkX/uzvuycZgpMFunnDzSnuB7FRml3VEnYpQY8oclVGJe7sR84Z0u/P
         wvnA==
X-Gm-Message-State: ACgBeo1evplYVBeR/iM+BuXcZFe3IXX6c22XiAam2CTjGF7g43SIYrPo
        47gLWvSWy1tQLIQZkXBGip3o
X-Google-Smtp-Source: AA6agR7P9b6IBewqy9DpjGisAzgO74uYCSE7ZBWKK8Cwk+n3NWqNf/c1nYyvvIjanHpCkx2UCcg9ig==
X-Received: by 2002:a05:6a00:842:b0:52e:2515:d657 with SMTP id q2-20020a056a00084200b0052e2515d657mr29276965pfk.31.1661344223508;
        Wed, 24 Aug 2022 05:30:23 -0700 (PDT)
Received: from localhost.localdomain ([117.207.24.28])
        by smtp.gmail.com with ESMTPSA id b3-20020a1709027e0300b00173031308fdsm3539220plm.158.2022.08.24.05.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:30:23 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     kishon@ti.com, gregkh@linuxfoundation.org, lpieralisi@kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        mie@igel.co.jp, kw@linux.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/5] misc: pci_endpoint_test: Fix the return value of IOCTL
Date:   Wed, 24 Aug 2022 18:00:06 +0530
Message-Id: <20220824123010.51763-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IOCTLs are supposed to return 0 for success and negative error codes for
failure. Currently, this driver is returning 0 for failure and 1 for
success, that's not correct. Hence, fix it!

Cc: stable@vger.kernel.org #5.10
Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/misc/pci_endpoint_test.c | 163 ++++++++++++++-----------------
 1 file changed, 76 insertions(+), 87 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 8f786a225dcf..a7d8ae9730f6 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -174,13 +174,12 @@ static void pci_endpoint_test_free_irq_vectors(struct pci_endpoint_test *test)
 	test->irq_type = IRQ_TYPE_UNDEFINED;
 }
 
-static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
+static int pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
 						int type)
 {
-	int irq = -1;
+	int irq = -ENOSPC;
 	struct pci_dev *pdev = test->pdev;
 	struct device *dev = &pdev->dev;
-	bool res = true;
 
 	switch (type) {
 	case IRQ_TYPE_LEGACY:
@@ -202,15 +201,16 @@ static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
 		dev_err(dev, "Invalid IRQ type selected\n");
 	}
 
+	test->irq_type = type;
+
 	if (irq < 0) {
-		irq = 0;
-		res = false;
+		test->num_irqs = 0;
+		return irq;
 	}
 
-	test->irq_type = type;
 	test->num_irqs = irq;
 
-	return res;
+	return 0;
 }
 
 static void pci_endpoint_test_release_irq(struct pci_endpoint_test *test)
@@ -225,7 +225,7 @@ static void pci_endpoint_test_release_irq(struct pci_endpoint_test *test)
 	test->num_irqs = 0;
 }
 
-static bool pci_endpoint_test_request_irq(struct pci_endpoint_test *test)
+static int pci_endpoint_test_request_irq(struct pci_endpoint_test *test)
 {
 	int i;
 	int err;
@@ -240,7 +240,7 @@ static bool pci_endpoint_test_request_irq(struct pci_endpoint_test *test)
 			goto fail;
 	}
 
-	return true;
+	return 0;
 
 fail:
 	switch (irq_type) {
@@ -260,10 +260,10 @@ static bool pci_endpoint_test_request_irq(struct pci_endpoint_test *test)
 		break;
 	}
 
-	return false;
+	return err;
 }
 
-static bool pci_endpoint_test_bar(struct pci_endpoint_test *test,
+static int pci_endpoint_test_bar(struct pci_endpoint_test *test,
 				  enum pci_barno barno)
 {
 	int j;
@@ -272,7 +272,7 @@ static bool pci_endpoint_test_bar(struct pci_endpoint_test *test,
 	struct pci_dev *pdev = test->pdev;
 
 	if (!test->bar[barno])
-		return false;
+		return -ENOMEM;
 
 	size = pci_resource_len(pdev, barno);
 
@@ -285,13 +285,13 @@ static bool pci_endpoint_test_bar(struct pci_endpoint_test *test,
 	for (j = 0; j < size; j += 4) {
 		val = pci_endpoint_test_bar_readl(test, barno, j);
 		if (val != 0xA0A0A0A0)
-			return false;
+			return -EIO;
 	}
 
-	return true;
+	return 0;
 }
 
-static bool pci_endpoint_test_legacy_irq(struct pci_endpoint_test *test)
+static int pci_endpoint_test_legacy_irq(struct pci_endpoint_test *test)
 {
 	u32 val;
 
@@ -303,12 +303,12 @@ static bool pci_endpoint_test_legacy_irq(struct pci_endpoint_test *test)
 	val = wait_for_completion_timeout(&test->irq_raised,
 					  msecs_to_jiffies(1000));
 	if (!val)
-		return false;
+		return -ETIMEDOUT;
 
-	return true;
+	return 0;
 }
 
-static bool pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
+static int pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 				       u16 msi_num, bool msix)
 {
 	u32 val;
@@ -324,19 +324,18 @@ static bool pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 	val = wait_for_completion_timeout(&test->irq_raised,
 					  msecs_to_jiffies(1000));
 	if (!val)
-		return false;
+		return -ETIMEDOUT;
 
-	if (pci_irq_vector(pdev, msi_num - 1) == test->last_irq)
-		return true;
+	if (pci_irq_vector(pdev, msi_num - 1) != test->last_irq)
+		return -EIO;
 
-	return false;
+	return 0;
 }
 
-static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
+static int pci_endpoint_test_copy(struct pci_endpoint_test *test,
 				   unsigned long arg)
 {
 	struct pci_endpoint_test_xfer_param param;
-	bool ret = false;
 	void *src_addr;
 	void *dst_addr;
 	u32 flags = 0;
@@ -360,12 +359,12 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 	err = copy_from_user(&param, (void __user *)arg, sizeof(param));
 	if (err) {
 		dev_err(dev, "Failed to get transfer param\n");
-		return false;
+		return -EFAULT;
 	}
 
 	size = param.size;
 	if (size > SIZE_MAX - alignment)
-		goto err;
+		return -EINVAL;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -373,22 +372,21 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 
 	if (irq_type < IRQ_TYPE_LEGACY || irq_type > IRQ_TYPE_MSIX) {
 		dev_err(dev, "Invalid IRQ type option\n");
-		goto err;
+		return -EINVAL;
 	}
 
 	orig_src_addr = kzalloc(size + alignment, GFP_KERNEL);
 	if (!orig_src_addr) {
 		dev_err(dev, "Failed to allocate source buffer\n");
-		ret = false;
-		goto err;
+		return -ENOMEM;
 	}
 
 	get_random_bytes(orig_src_addr, size + alignment);
 	orig_src_phys_addr = dma_map_single(dev, orig_src_addr,
 					    size + alignment, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, orig_src_phys_addr)) {
+	err = dma_mapping_error(dev, orig_src_phys_addr);
+	if (err) {
 		dev_err(dev, "failed to map source buffer address\n");
-		ret = false;
 		goto err_src_phys_addr;
 	}
 
@@ -412,15 +410,15 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 	orig_dst_addr = kzalloc(size + alignment, GFP_KERNEL);
 	if (!orig_dst_addr) {
 		dev_err(dev, "Failed to allocate destination address\n");
-		ret = false;
+		err = -ENOMEM;
 		goto err_dst_addr;
 	}
 
 	orig_dst_phys_addr = dma_map_single(dev, orig_dst_addr,
 					    size + alignment, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, orig_dst_phys_addr)) {
+	err = dma_mapping_error(dev, orig_dst_phys_addr);
+	if (err) {
 		dev_err(dev, "failed to map destination buffer address\n");
-		ret = false;
 		goto err_dst_phys_addr;
 	}
 
@@ -453,8 +451,8 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 			 DMA_FROM_DEVICE);
 
 	dst_crc32 = crc32_le(~0, dst_addr, size);
-	if (dst_crc32 == src_crc32)
-		ret = true;
+	if (dst_crc32 != src_crc32)
+		err = -EIO;
 
 err_dst_phys_addr:
 	kfree(orig_dst_addr);
@@ -465,16 +463,13 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 
 err_src_phys_addr:
 	kfree(orig_src_addr);
-
-err:
-	return ret;
+	return err;
 }
 
-static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
+static int pci_endpoint_test_write(struct pci_endpoint_test *test,
 				    unsigned long arg)
 {
 	struct pci_endpoint_test_xfer_param param;
-	bool ret = false;
 	u32 flags = 0;
 	bool use_dma;
 	u32 reg;
@@ -492,14 +487,14 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 	int err;
 
 	err = copy_from_user(&param, (void __user *)arg, sizeof(param));
-	if (err != 0) {
+	if (err) {
 		dev_err(dev, "Failed to get transfer param\n");
-		return false;
+		return -EFAULT;
 	}
 
 	size = param.size;
 	if (size > SIZE_MAX - alignment)
-		goto err;
+		return -EINVAL;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -507,23 +502,22 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 
 	if (irq_type < IRQ_TYPE_LEGACY || irq_type > IRQ_TYPE_MSIX) {
 		dev_err(dev, "Invalid IRQ type option\n");
-		goto err;
+		return -EINVAL;
 	}
 
 	orig_addr = kzalloc(size + alignment, GFP_KERNEL);
 	if (!orig_addr) {
 		dev_err(dev, "Failed to allocate address\n");
-		ret = false;
-		goto err;
+		return -ENOMEM;
 	}
 
 	get_random_bytes(orig_addr, size + alignment);
 
 	orig_phys_addr = dma_map_single(dev, orig_addr, size + alignment,
 					DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, orig_phys_addr)) {
+	err = dma_mapping_error(dev, orig_phys_addr);
+	if (err) {
 		dev_err(dev, "failed to map source buffer address\n");
-		ret = false;
 		goto err_phys_addr;
 	}
 
@@ -556,24 +550,21 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 	wait_for_completion(&test->irq_raised);
 
 	reg = pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_STATUS);
-	if (reg & STATUS_READ_SUCCESS)
-		ret = true;
+	if (!(reg & STATUS_READ_SUCCESS))
+		err = -EIO;
 
 	dma_unmap_single(dev, orig_phys_addr, size + alignment,
 			 DMA_TO_DEVICE);
 
 err_phys_addr:
 	kfree(orig_addr);
-
-err:
-	return ret;
+	return err;
 }
 
-static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
+static int pci_endpoint_test_read(struct pci_endpoint_test *test,
 				   unsigned long arg)
 {
 	struct pci_endpoint_test_xfer_param param;
-	bool ret = false;
 	u32 flags = 0;
 	bool use_dma;
 	size_t size;
@@ -592,12 +583,12 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 	err = copy_from_user(&param, (void __user *)arg, sizeof(param));
 	if (err) {
 		dev_err(dev, "Failed to get transfer param\n");
-		return false;
+		return -EFAULT;
 	}
 
 	size = param.size;
 	if (size > SIZE_MAX - alignment)
-		goto err;
+		return -EINVAL;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -605,21 +596,20 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 
 	if (irq_type < IRQ_TYPE_LEGACY || irq_type > IRQ_TYPE_MSIX) {
 		dev_err(dev, "Invalid IRQ type option\n");
-		goto err;
+		return -EINVAL;
 	}
 
 	orig_addr = kzalloc(size + alignment, GFP_KERNEL);
 	if (!orig_addr) {
 		dev_err(dev, "Failed to allocate destination address\n");
-		ret = false;
-		goto err;
+		return -ENOMEM;
 	}
 
 	orig_phys_addr = dma_map_single(dev, orig_addr, size + alignment,
 					DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, orig_phys_addr)) {
+	err = dma_mapping_error(dev, orig_phys_addr);
+	if (err) {
 		dev_err(dev, "failed to map source buffer address\n");
-		ret = false;
 		goto err_phys_addr;
 	}
 
@@ -651,50 +641,51 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 			 DMA_FROM_DEVICE);
 
 	crc32 = crc32_le(~0, addr, size);
-	if (crc32 == pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_CHECKSUM))
-		ret = true;
+	if (crc32 != pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_CHECKSUM))
+		err = -EIO;
 
 err_phys_addr:
 	kfree(orig_addr);
-err:
-	return ret;
+	return err;
 }
 
-static bool pci_endpoint_test_clear_irq(struct pci_endpoint_test *test)
+static int pci_endpoint_test_clear_irq(struct pci_endpoint_test *test)
 {
 	pci_endpoint_test_release_irq(test);
 	pci_endpoint_test_free_irq_vectors(test);
-	return true;
+
+	return 0;
 }
 
-static bool pci_endpoint_test_set_irq(struct pci_endpoint_test *test,
+static int pci_endpoint_test_set_irq(struct pci_endpoint_test *test,
 				      int req_irq_type)
 {
 	struct pci_dev *pdev = test->pdev;
 	struct device *dev = &pdev->dev;
+	int err;
 
 	if (req_irq_type < IRQ_TYPE_LEGACY || req_irq_type > IRQ_TYPE_MSIX) {
 		dev_err(dev, "Invalid IRQ type option\n");
-		return false;
+		return -EINVAL;
 	}
 
 	if (test->irq_type == req_irq_type)
-		return true;
+		return 0;
 
 	pci_endpoint_test_release_irq(test);
 	pci_endpoint_test_free_irq_vectors(test);
 
-	if (!pci_endpoint_test_alloc_irq_vectors(test, req_irq_type))
-		goto err;
-
-	if (!pci_endpoint_test_request_irq(test))
-		goto err;
+	err = pci_endpoint_test_alloc_irq_vectors(test, req_irq_type);
+	if (err)
+		return err;
 
-	return true;
+	err = pci_endpoint_test_request_irq(test);
+	if (err) {
+		pci_endpoint_test_free_irq_vectors(test);
+		return err;
+	}
 
-err:
-	pci_endpoint_test_free_irq_vectors(test);
-	return false;
+	return 0;
 }
 
 static long pci_endpoint_test_ioctl(struct file *file, unsigned int cmd,
@@ -812,10 +803,9 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	if (!pci_endpoint_test_alloc_irq_vectors(test, irq_type)) {
-		err = -EINVAL;
+	err = pci_endpoint_test_alloc_irq_vectors(test, irq_type);
+	if (err)
 		goto err_disable_irq;
-	}
 
 	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
 		if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
@@ -852,10 +842,9 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 		goto err_ida_remove;
 	}
 
-	if (!pci_endpoint_test_request_irq(test)) {
-		err = -EINVAL;
+	err = pci_endpoint_test_request_irq(test);
+	if (err)
 		goto err_kfree_test_name;
-	}
 
 	misc_device = &test->miscdev;
 	misc_device->minor = MISC_DYNAMIC_MINOR;
-- 
2.25.1

