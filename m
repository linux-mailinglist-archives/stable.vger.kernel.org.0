Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DCE6AA547
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCCXDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjCCXDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BF24FA90;
        Fri,  3 Mar 2023 15:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2860BB81A43;
        Fri,  3 Mar 2023 21:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F58C4339C;
        Fri,  3 Mar 2023 21:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880073;
        bh=EoYuMau1ceIpjX5tjDs5OAnfLOA35rNSG5SWqpHEXn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEW/gmMTojcaZWCVuCLV4krLrdgDL7c7VN+G+bbCl4FXvnNPJ5s+7As8RsDP2LvtM
         T87w8EW4iTuoEx4cgZ0h3WASE3C8fK79T9UdTuY+soj/G4zCJnrYODELCc+RKiVm82
         Iz6tCp88tczHVg9/eT/6fAP9H5tBJWFGJzrv3k+aPuC/AMU8Rka33QiHsMdQN4uVZB
         asyBlrlbSxY4ANzQP5iAcQ6AncrQ51n3ItqTuCVoi6jw7uF0lJIwD04eHkrCf5VjgD
         R6lcz3H415mtoG4RcQLFfQMFbwEzsPnTKFkU6UmmNAWYGTa5r9DbNGyNF+py3zvFS4
         t+9VU3lioai3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/30] PCI: Align extra resources for hotplug bridges properly
Date:   Fri,  3 Mar 2023 16:47:07 -0500
Message-Id: <20230303214715.1452256-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214715.1452256-1-sashal@kernel.org>
References: <20230303214715.1452256-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 08f0a15ee8adb4846b08ca5d5c175fbf0f652bc9 ]

After division the extra resource space per hotplug bridge may not be
aligned according to the window alignment, so align it before passing it
down for further distribution.

Link: https://lore.kernel.org/r/20230131092405.29121-2-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 2ce636937c6ea..4a6b698b5dd10 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2004,6 +2004,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	 * resource space between hotplug bridges.
 	 */
 	for_each_pci_bridge(dev, bus) {
+		struct resource *res;
 		struct pci_bus *b;
 
 		b = dev->subordinate;
@@ -2015,16 +2016,28 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 		 * hotplug-capable downstream ports taking alignment into
 		 * account.
 		 */
-		io.end = io.start + io_per_hp - 1;
-		mmio.end = mmio.start + mmio_per_hp - 1;
-		mmio_pref.end = mmio_pref.start + mmio_pref_per_hp - 1;
+		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+		align = pci_resource_alignment(dev, res);
+		io.end = align ? io.start + ALIGN_DOWN(io_per_hp, align) - 1
+			       : io.start + io_per_hp - 1;
+
+		res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
+		align = pci_resource_alignment(dev, res);
+		mmio.end = align ? mmio.start + ALIGN_DOWN(mmio_per_hp, align) - 1
+				 : mmio.start + mmio_per_hp - 1;
+
+		res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
+		align = pci_resource_alignment(dev, res);
+		mmio_pref.end = align ? mmio_pref.start +
+					ALIGN_DOWN(mmio_pref_per_hp, align) - 1
+				      : mmio_pref.start + mmio_pref_per_hp - 1;
 
 		pci_bus_distribute_available_resources(b, add_list, io, mmio,
 						       mmio_pref);
 
-		io.start += io_per_hp;
-		mmio.start += mmio_per_hp;
-		mmio_pref.start += mmio_pref_per_hp;
+		io.start += io.end + 1;
+		mmio.start += mmio.end + 1;
+		mmio_pref.start += mmio_pref.end + 1;
 	}
 }
 
-- 
2.39.2

