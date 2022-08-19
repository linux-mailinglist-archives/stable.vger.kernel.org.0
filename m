Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1352E59A08C
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352467AbiHSQ0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352372AbiHSQZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:25:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610DA2A42F;
        Fri, 19 Aug 2022 09:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 256E1617CE;
        Fri, 19 Aug 2022 16:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D024EC433D6;
        Fri, 19 Aug 2022 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924992;
        bh=iQ7iWrZaZi/BsjIXc1ksis2Vv46be5HwFbPHTwHYWQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAa1DXcBplwToIfIQVYnEpylGYKdfuhRlbXZVh9HD3TirnauQkDYl9E/XrQeRs16A
         C/ub/+bPIeAFX3cRrumWDSzxj45fkpYQfYBMif65mslCZkWMsGwrBPvJlL5hxdwksv
         8qCzm05jKkCREhmxoDxetB475BW24iI5fN+FwkOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/545] PCI/portdrv: Dont disable AER reporting in get_port_device_capability()
Date:   Fri, 19 Aug 2022 17:41:29 +0200
Message-Id: <20220819153843.626684387@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Stefan Roese <sr@denx.de>

[ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]

AER reporting is currently disabled in the DevCtl registers of all non Root
Port PCIe devices on systems using pcie_ports_native || host->native_aer,
disabling AER completely in such systems. This is because 2bd50dd800b5
("PCI: PCIe: Disable PCIe port services during port initialization"), added
a call to pci_disable_pcie_error_reporting() *after* the AER setup was
completed for the PCIe device tree.

Here a longer analysis about the current status of AER enabling /
disabling upon bootup provided by Bjorn:

  pcie_portdrv_probe
    pcie_port_device_register
      get_port_device_capability
        pci_disable_pcie_error_reporting
          clear CERE NFERE FERE URRE               # <-- disable for RP USP DSP
      pcie_device_init
        device_register                            # new AER service device
          aer_probe
            aer_enable_rootport                    # RP only
              set_downstream_devices_error_reporting
                set_device_error_reporting         # self (RP)
                  if (RP || USP || DSP)
                    pci_enable_pcie_error_reporting
                      set CERE NFERE FERE URRE     # <-- enable for RP
                pci_walk_bus
                  set_device_error_reporting
                    if (RP || USP || DSP)
                      pci_enable_pcie_error_reporting
                        set CERE NFERE FERE URRE   # <-- enable for USP DSP

In a typical Root Port -> Endpoint hierarchy, the above:
  - Disables Error Reporting for the Root Port,
  - Enables Error Reporting for the Root Port,
  - Does NOT enable Error Reporting for the Endpoint because it is not a
    Root Port or Switch Port.

In a deeper Root Port -> Upstream Switch Port -> Downstream Switch
Port -> Endpoint hierarchy:
  - Disables Error Reporting for the Root Port,
  - Enables Error Reporting for the Root Port,
  - Enables Error Reporting for both Switch Ports,
  - Does NOT enable Error Reporting for the Endpoint because it is not a
    Root Port or Switch Port,
  - Disables Error Reporting for the Switch Ports when pcie_portdrv_probe()
    claims them.  AER does not re-enable it because these are not Root
    Ports.

Remove this call to pci_disable_pcie_error_reporting() from
get_port_device_capability(), leaving the already enabled AER configuration
intact. With this change, AER is enabled in the Root Port and the PCIe
switch upstream and downstream ports. Only the PCIe Endpoints don't have
AER enabled yet. A follow-up patch will take care of this Endpoint
enabling.

Fixes: 2bd50dd800b5 ("PCI: PCIe: Disable PCIe port services during port initialization")
Link: https://lore.kernel.org/r/20220125071820.2247260-3-sr@denx.de
Signed-off-by: Stefan Roese <sr@denx.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Yao Hongbo <yaohongbo@linux.alibaba.com>
Cc: Naveen Naidu <naveennaidu479@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv_core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 3779b264dbec..5ae81f2df45f 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -222,15 +222,8 @@ static int get_port_device_capability(struct pci_dev *dev)
 
 #ifdef CONFIG_PCIEAER
 	if (dev->aer_cap && pci_aer_available() &&
-	    (pcie_ports_native || host->native_aer)) {
+	    (pcie_ports_native || host->native_aer))
 		services |= PCIE_PORT_SERVICE_AER;
-
-		/*
-		 * Disable AER on this port in case it's been enabled by the
-		 * BIOS (the AER service driver will enable it when necessary).
-		 */
-		pci_disable_pcie_error_reporting(dev);
-	}
 #endif
 
 	/*
-- 
2.35.1



