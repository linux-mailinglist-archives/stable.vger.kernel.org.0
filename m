Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4045414D7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358718AbiFGUWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356895AbiFGUVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A501451C0;
        Tue,  7 Jun 2022 11:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B663561295;
        Tue,  7 Jun 2022 18:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA084C385A2;
        Tue,  7 Jun 2022 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626674;
        bh=qyEorKugdSDrYM446SI/sSvrMFs3g4trsGrHJkoRY5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI4XM1Tgvh2UbdTzc0mrXySHWTJNNm17nUnqGr7lQ115Xwnx9geoFphyHZuQesNJq
         e9YAWFZRXVgwVbpRwz0Rw0vgIoLDFh19vYJ+iltdo8Png09Hb5pcOpkAA4tnPHmKax
         EG7LztP3IkZWOcQNrXoorQAmC24dXCH6Gz4QJSsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianrong Zhang <zhangjianrong5@huawei.com>,
        Jiantao Zhang <water.zhangjiantao@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 462/772] PCI: dwc: Fix setting error return on MSI DMA mapping failure
Date:   Tue,  7 Jun 2022 19:00:54 +0200
Message-Id: <20220607165002.614777042@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiantao Zhang <water.zhangjiantao@huawei.com>

[ Upstream commit 88557685cd72cf0db686a4ebff3fad4365cb6071 ]

When dma_mapping_error() returns error because of no enough memory,
but dw_pcie_host_init() returns success, which will mislead the callers.

Link: https://lore.kernel.org/r/30170911-0e2f-98ce-9266-70465b9073e5@huawei.com
Fixes: 07940c369a6b ("PCI: dwc: Fix MSI page leakage in suspend/resume")
Signed-off-by: Jianrong Zhang <zhangjianrong5@huawei.com>
Signed-off-by: Jiantao Zhang <water.zhangjiantao@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index f4755f3a03be..9dcb51728dd1 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -390,7 +390,8 @@ int dw_pcie_host_init(struct pcie_port *pp)
 						      sizeof(pp->msi_msg),
 						      DMA_FROM_DEVICE,
 						      DMA_ATTR_SKIP_CPU_SYNC);
-			if (dma_mapping_error(pci->dev, pp->msi_data)) {
+			ret = dma_mapping_error(pci->dev, pp->msi_data);
+			if (ret) {
 				dev_err(pci->dev, "Failed to map MSI data\n");
 				pp->msi_data = 0;
 				goto err_free_msi;
-- 
2.35.1



