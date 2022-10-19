Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1595D604382
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJSLko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiJSLkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1217618F908;
        Wed, 19 Oct 2022 04:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495BB61805;
        Wed, 19 Oct 2022 09:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B96C433D6;
        Wed, 19 Oct 2022 09:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170040;
        bh=vcaLK0lvNkR+XV77RCpMih3ZdGG56S+uibkBqrOTXyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLP9JvLF4ESpMGQcJqB2WAVqZHcRLdhIi6tDunJNA3DBxkeEHz/aTZxqNRXWu0G2I
         dvJLeSaWNPoBV2YfmKuk8MJ+gz+eP8zaVP3QvzFIrpo3/YdoiRafuAc5Oj5CtUXedA
         6v1MEIo+l+gDUoi9Rvsg7G5KN2AJU/5e9vgRSCAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        Marco Pagani <marpagan@redhat.com>, Tom Rix <trix@redhat.com>,
        Wu Hao <hao.wu@intel.com>, Xu Yilun <yilun.xu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 504/862] fpga: dfl-pci: Add IDs for Intel N6000, N6001 and C6100 cards
Date:   Wed, 19 Oct 2022 10:29:51 +0200
Message-Id: <20221019083312.264626205@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Gerlach <matthew.gerlach@linux.intel.com>

[ Upstream commit 65f5c01033ab85f8d385d65c4b51fe31459da603 ]

Add pci_dev_table entries supporting the Intel N6000, N6001
and C6100 cards to the dfl-pci driver.

Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
Tested-by: Marco Pagani <marpagan@redhat.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20220719145644.242481-1-matthew.gerlach@linux.intel.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl-pci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -77,12 +77,18 @@ static void cci_pci_free_irq(struct pci_
 #define PCIE_DEVICE_ID_INTEL_PAC_D5005		0x0B2B
 #define PCIE_DEVICE_ID_SILICOM_PAC_N5010	0x1000
 #define PCIE_DEVICE_ID_SILICOM_PAC_N5011	0x1001
+#define PCIE_DEVICE_ID_INTEL_DFL		0xbcce
+/* PCI Subdevice ID for PCIE_DEVICE_ID_INTEL_DFL */
+#define PCIE_SUBDEVICE_ID_INTEL_N6000		0x1770
+#define PCIE_SUBDEVICE_ID_INTEL_N6001		0x1771
+#define PCIE_SUBDEVICE_ID_INTEL_C6100		0x17d4
 
 /* VF Device */
 #define PCIE_DEVICE_ID_VF_INT_5_X		0xBCBF
 #define PCIE_DEVICE_ID_VF_INT_6_X		0xBCC1
 #define PCIE_DEVICE_ID_VF_DSC_1_X		0x09C5
 #define PCIE_DEVICE_ID_INTEL_PAC_D5005_VF	0x0B2C
+#define PCIE_DEVICE_ID_INTEL_DFL_VF		0xbccf
 
 static struct pci_device_id cci_pcie_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_5_X),},
@@ -96,6 +102,18 @@ static struct pci_device_id cci_pcie_id_
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_PAC_D5005_VF),},
 	{PCI_DEVICE(PCI_VENDOR_ID_SILICOM_DENMARK, PCIE_DEVICE_ID_SILICOM_PAC_N5010),},
 	{PCI_DEVICE(PCI_VENDOR_ID_SILICOM_DENMARK, PCIE_DEVICE_ID_SILICOM_PAC_N5011),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_N6000),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL_VF,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_N6000),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_N6001),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL_VF,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_N6001),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_C6100),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL_VF,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_C6100),},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);


