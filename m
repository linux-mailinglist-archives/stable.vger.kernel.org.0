Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A244EF50B
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbiDAPF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349545AbiDAO4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:56:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E761EF32B3;
        Fri,  1 Apr 2022 07:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0FB0B8240E;
        Fri,  1 Apr 2022 14:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B43C2BBE4;
        Fri,  1 Apr 2022 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824246;
        bh=tzTiadN5Zj6DRCCirKrLyN3UU6bVuQqMqdBzqv4dZr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzEg6+Xqx57qQsD7F8ic07oxZiB8DGLoYpcyLsOoJUgxO7VGjigU1Y4BNGU21QvBm
         JPdmeD4h4BRMWyePdLWpB5O40yuXQwF/kUUHg/5Q/TZQX3GulKZvid5JeiYtJshd8N
         mrjqtZY49cBG99jPDQX19en1dES1xGWdQHDPlfjGaMCvfYl/aUhfGa6iu0kr/MtGUe
         0BPHuw5Uh5uQwCI6wYH5KpHS6ntIB1HyOX/A5LTiEXyCAOXhB1XRRd/pOWhqy98v59
         BDn650SNjiewzYBTWkdmguK7Ftc0yDNV0fwX+XeWy8qpX206oPe6c0a+wZp+SbMzwn
         EBAKAPbuX3OuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Chen <lchen@ambarella.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        Zhiqiang.Hou@nxp.com, yangyingliang@huawei.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 49/65] PCI: endpoint: Fix misused goto label
Date:   Fri,  1 Apr 2022 10:41:50 -0400
Message-Id: <20220401144206.1953700-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Li Chen <lchen@ambarella.com>

[ Upstream commit bf8d87c076f55b8b4dfdb6bc6c6b6dc0c2ccb487 ]

Fix a misused goto label jump since that can result in a memory leak.

Link: https://lore.kernel.org/r/17e7b9b9ee6.c6d9c6a02564.4545388417402742326@zohomail.com
Signed-off-by: Li Chen <lchen@ambarella.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index b861840e867c..262b2c4c70c9 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -451,7 +451,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 		if (!epf_test->dma_supported) {
 			dev_err(dev, "Cannot transfer data using DMA\n");
 			ret = -EINVAL;
-			goto err_map_addr;
+			goto err_dma_map;
 		}
 
 		src_phys_addr = dma_map_single(dma_dev, buf, reg->size,
-- 
2.34.1

