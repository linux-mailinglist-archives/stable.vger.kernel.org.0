Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ECD4CF6FB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiCGJn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240712AbiCGJla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCEF2BB2C;
        Mon,  7 Mar 2022 01:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EA23CE0B91;
        Mon,  7 Mar 2022 09:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B0C340E9;
        Mon,  7 Mar 2022 09:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645839;
        bh=+2VXaBSzPCczrSieBa6Z5FKW8gMdw7eVMp/ZAnh4K0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIXouci0gDacMxoGTWmwQZxrOrFV1PoDd1zvysz5DXQlKrqDYaMigzoLOoTQ1ToRP
         xanS1EjcKtMZ6W2OXt1RxXdKG60nQQYVY2Q5pwmm27jxuMSRBtzODcvv4Z76tM4jJ+
         GNq1EY5gpYvUwgZlTRd7KuIDQevQAoy3yf8XtvnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Richard Zhu <hongxing.zhu@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/262] PCI: dwc: Do not remap invalid res
Date:   Mon,  7 Mar 2022 10:16:37 +0100
Message-Id: <20220307091704.013388515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 6e5ebc96ec651b67131f816d7e3bf286c635e749 ]

On imx6 and perhaps others when pcie probes you get a:
imx6q-pcie 33800000.pcie: invalid resource

This occurs because the atu is not specified in the DT and as such it
should not be remapped.

Link: https://lore.kernel.org/r/20211101180243.23761-1-tharvey@gateworks.com
Fixes: 281f1f99cf3a ("PCI: dwc: Detect number of iATU windows")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index a945f0c0e73dc..3254f60d1713f 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -671,10 +671,11 @@ void dw_pcie_iatu_detect(struct dw_pcie *pci)
 		if (!pci->atu_base) {
 			struct resource *res =
 				platform_get_resource_byname(pdev, IORESOURCE_MEM, "atu");
-			if (res)
+			if (res) {
 				pci->atu_size = resource_size(res);
-			pci->atu_base = devm_ioremap_resource(dev, res);
-			if (IS_ERR(pci->atu_base))
+				pci->atu_base = devm_ioremap_resource(dev, res);
+			}
+			if (!pci->atu_base || IS_ERR(pci->atu_base))
 				pci->atu_base = pci->dbi_base + DEFAULT_DBI_ATU_OFFSET;
 		}
 
-- 
2.34.1



