Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C95AB12F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiIBNHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbiIBNGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6242112EFC;
        Fri,  2 Sep 2022 05:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB85EB82ACE;
        Fri,  2 Sep 2022 12:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1283C433D7;
        Fri,  2 Sep 2022 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122148;
        bh=RcY9bMWiZPvaxJI29PxskHOtvopzEBhAGDCs6Qwxy1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt+B9cbvXWPp+wa0aNHGL7t7SGx4Kci4IshcN+y+Lh9BYSgCRcoVKII0eETrs10/D
         bynLkoLCIwMLYAnhkTjXwEc/G+MWfoEwPaLZ52tSRy+UPaTFCDKcZ5hQij1zXjeDeP
         p/DD8GyV/2F1rNy8ztbRnx6ubjgszwbygfUeUTxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Stefan Roese <sr@denx.de>, Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 08/72] Revert "PCI/portdrv: Dont disable AER reporting in get_port_device_capability()"
Date:   Fri,  2 Sep 2022 14:18:44 +0200
Message-Id: <20220902121405.064846233@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 65e393fddc5379b2c41ca7e73cd4bb9572c4d90e which is
commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 upstream.

It is reported to cause problems, so drop it from the stable trees for
now until it gets sorted out.

Link: https://lore.kernel.org/r/47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com
Reported-by: Ben Greear <greearb@candelatech.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Pali Rohár <pali@kernel.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Yao Hongbo <yaohongbo@linux.alibaba.com>
Cc: Naveen Naidu <naveennaidu479@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/portdrv_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -222,8 +222,15 @@ static int get_port_device_capability(st
 
 #ifdef CONFIG_PCIEAER
 	if (dev->aer_cap && pci_aer_available() &&
-	    (pcie_ports_native || host->native_aer))
+	    (pcie_ports_native || host->native_aer)) {
 		services |= PCIE_PORT_SERVICE_AER;
+
+		/*
+		 * Disable AER on this port in case it's been enabled by the
+		 * BIOS (the AER service driver will enable it when necessary).
+		 */
+		pci_disable_pcie_error_reporting(dev);
+	}
 #endif
 
 	/* Root Ports and Root Complex Event Collectors may generate PMEs */


