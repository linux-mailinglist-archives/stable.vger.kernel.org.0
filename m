Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8321C551B24
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243140AbiFTNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344253AbiFTNNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:13:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198941EED3;
        Mon, 20 Jun 2022 06:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8FE9B811D8;
        Mon, 20 Jun 2022 13:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E0C3411B;
        Mon, 20 Jun 2022 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730260;
        bh=BrMAr5keXlVGAt/2wfdpi2cV9Jtsmv2DZ3dYTdZLhrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFiW0eZk6SUsojmbD3b+tN1aJdFacoy9ro9sUp4WYKDKOX+NG0bOk85OtAfWYoQzW
         xam2myxhc0T5/3PyUEgJd0AR3Qma8iIVQ0WJQ7Y0hveU9JJh/djYWARiyXOO29+lPW
         RMr6d00/Dgr1dckSGU7tcyePwx9klhJwKldg9pYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.10 82/84] igc: Enable PCIe PTM
Date:   Mon, 20 Jun 2022 14:51:45 +0200
Message-Id: <20220620124723.313079844@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

commit 1b5d73fb862414106cf270a1a7300ce8ae77de83 upstream.

Enables PCIe PTM (Precision Time Measurement) support in the igc
driver. Notifies the PCI devices that PCIe PTM should be enabled.

PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
in the PCIe fabric, it allows devices to report time measurements from
their internal clocks and the correlation with the PCIe root clock.

The i225 NIC exposes some registers that expose those time
measurements, those registers will be used, in later patches, to
implement the PTP_SYS_OFFSET_PRECISE ioctl().

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -9,6 +9,7 @@
 #include <linux/udp.h>
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
+#include <linux/pci.h>
 #include <net/pkt_sched.h>
 
 #include <net/ipv6.h>
@@ -5041,6 +5042,10 @@ static int igc_probe(struct pci_dev *pde
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;


