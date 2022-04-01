Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2914EF3A7
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349439AbiDAOzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349903AbiDAOq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:46:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968121E1105;
        Fri,  1 Apr 2022 07:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6457CB8250B;
        Fri,  1 Apr 2022 14:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A49C340F2;
        Fri,  1 Apr 2022 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823802;
        bh=clkxCeeVshCjj/tkcXT/aa1TUVS1+JD8nre3csosIJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttGiD0d8Cq7VmjGmdMZYDEDQA/Q/MK308DXp1at4pRJtynlGFyiOuayDV6SNpsafV
         /vRZEzQG6w9xloBLCZnqHpPFtCypi2YlYQzrUMqsnEr2NE9bib5sh0brAP1I4E6AY8
         H22BplVqW01w2odPrKXzJVDMp78ZnQE9o86Uoc8Z96JZIiIeVFPwlN5CBah/ycnDJp
         hWTrlqDzCuyj/MNRJjhn+JHCob5G5GrlMpSjldgVYvn3RKGItey5KwW/EMORCdJ/i/
         UrrMsyo12gdlIkOJHYsNvga3i8z/E2+ThYiiIZOlLx/mnsYeRLmXsmQUNSEJQC5fhJ
         BZ2g6X5LIye5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Chen <lchen@ambarella.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>, bhelgaas@google.com,
        Zhiqiang.Hou@nxp.com, yangyingliang@huawei.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 084/109] PCI: endpoint: Fix misused goto label
Date:   Fri,  1 Apr 2022 10:32:31 -0400
Message-Id: <20220401143256.1950537-84-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index c7e45633beaf..5b833f00e980 100644
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

