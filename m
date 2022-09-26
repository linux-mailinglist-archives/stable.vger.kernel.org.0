Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FFB5E9FE5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbiIZKai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiIZK33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B0D118;
        Mon, 26 Sep 2022 03:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5163760687;
        Mon, 26 Sep 2022 10:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E79C433C1;
        Mon, 26 Sep 2022 10:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187574;
        bh=0mJTwtfsM3JU847gcuOVwTHGzf5FOEHdXTIF2GM5PXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1ziJMiKDwBGwP9S7/sZVkr3lepEY6xcNgS+hoT29a8HP2F0IUynFuH6xkCsKUb7R
         PlWirCe7EU5LUDnPhO2vsYQq1fkl+QlbvlJ1Aq5YMvkYlqJiPIGdtOtzVPEiyPwdTv
         p4NZgCWyPhTo2mh0STQj4UCRnAXayOezAKe9zTX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/58] usb: dwc3: pci: add support for TigerLake Devices
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100742.179235864@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[ Upstream commit b3649dee5fbb0f6585010e6e9313dfcbb075b22b ]

This patch adds the necessary PCI ID for TGP-LP devices.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Stable-dep-of: bad0d1d726ac ("usb: dwc3: pci: Add support for Intel Raptor Lake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 5d5166373aa1..3ca582127f94 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -37,6 +37,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
 #define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
+#define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -355,6 +356,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHLLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPLP),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.35.1



