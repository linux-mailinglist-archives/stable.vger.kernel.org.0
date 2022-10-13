Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A1C5FE018
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJMSEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiJMSDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:03:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA8216F419;
        Thu, 13 Oct 2022 11:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 100B56190E;
        Thu, 13 Oct 2022 17:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B54BC433D6;
        Thu, 13 Oct 2022 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683802;
        bh=w7/9AVzZ9ndeBeSxC7PHlgXCtfuyzqO6drfGK0LwTx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fv9hnyuq9MgM7J0GaKDYByKCEivL0pS1Ugl2rF/o/iHUKIMxJI4kcHZt6YLqLZuaD
         0sr4PS/ZF3oWxz7NZZbN7LRdCNIAvkVp1DtY7McUaDyzCLaSuRKoZHJ4F2zG6Smlk6
         i17UhiTRZLoM48fxkuv1H/2s30OgIZ4oHRalKTnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 53/54] misc: pci_endpoint_test: Aggregate params checking for xfer
Date:   Thu, 13 Oct 2022 19:52:47 +0200
Message-Id: <20221013175148.617518003@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Mie <mie@igel.co.jp>

commit 3e42deaac06567c7e86d287c305ccda24db4ae3d upstream.

Each transfer test functions have same parameter checking code. This patch
unites those to an introduced function.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220907020100.122588-1-mie@igel.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -331,6 +331,17 @@ static bool pci_endpoint_test_msi_irq(st
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
@@ -362,9 +373,11 @@ static bool pci_endpoint_test_copy(struc
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
@@ -496,9 +509,11 @@ static bool pci_endpoint_test_write(stru
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
@@ -594,9 +609,11 @@ static bool pci_endpoint_test_read(struc
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


