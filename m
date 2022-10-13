Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37E5FDEB3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJMRLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJMRLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E32BC629
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D8D9B80B68
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB836C433D6;
        Thu, 13 Oct 2022 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665681091;
        bh=H7XMzFLMi/SrpDNx5XyAZ3v8UgXz2PWLLHdGkfqhI5c=;
        h=Subject:To:Cc:From:Date:From;
        b=OrSJ5JVbWKvotoEtYDqwgLQk29BBH+LdtP7belitzAtzPBfe97lvjys6SnFWb+v2y
         iqHkeYNu9lv6j9AUWlsqwkep5Cr4pYFOEn8AhZKqaNnMDyKv5Hqk7jSSM8kZLcKVhz
         SyycNwHQ3R4tZCYaI6S5uXeyvn1yKH+ZY3qplDHs=
Subject: FAILED: patch "[PATCH] misc: pci_endpoint_test: Aggregate params checking for xfer" failed to apply to 4.19-stable tree
To:     mie@igel.co.jp, gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 19:12:07 +0200
Message-ID: <166568112711674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3e42deaac065 ("misc: pci_endpoint_test: Aggregate params checking for xfer")
cf376b4b59da ("misc: pci_endpoint_test: Add support to get DMA option from userspace")
5bb04b19230c ("misc: pci_endpoint_test: Add support to test PCI EP in AM654x")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3e42deaac06567c7e86d287c305ccda24db4ae3d Mon Sep 17 00:00:00 2001
From: Shunsuke Mie <mie@igel.co.jp>
Date: Wed, 7 Sep 2022 11:00:59 +0900
Subject: [PATCH] misc: pci_endpoint_test: Aggregate params checking for xfer

Each transfer test functions have same parameter checking code. This patch
unites those to an introduced function.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220907020100.122588-1-mie@igel.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 8f786a225dcf..39d477bb0989 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -332,6 +332,17 @@ static bool pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 	return false;
 }
 
+static int pci_endpoint_test_validate_xfer_params(struct device *dev,
+		struct pci_endpoint_test_xfer_param *param, size_t alignment)
+{
+	if (param->size > SIZE_MAX - alignment) {
+		dev_dbg(dev, "Maximum transfer data size exceeded\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 				   unsigned long arg)
 {
@@ -363,9 +374,11 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -497,9 +510,11 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -595,9 +610,11 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)

