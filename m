Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846776B4AF3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjCJP2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjCJP2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60913D1FD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19705CE2941
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0882DC433EF;
        Fri, 10 Mar 2023 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461362;
        bh=EoYuMau1ceIpjX5tjDs5OAnfLOA35rNSG5SWqpHEXn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDfZ9ZMEYaD1PWi2LU1G5AX29CPdZDIHoXzpZFQqFx4d9DweuHuwH296xTbBDsgEZ
         iAp/fzr9yT5Wgj4cg3qC33+hrIq7ioZnOoadKAU6JD5qteaj+xVDJ26E6QncpWCLFO
         T5AsXzYOKPR0EBsPseEHEu+d7KBG5YYRQLzo5QZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/136] PCI: Align extra resources for hotplug bridges properly
Date:   Fri, 10 Mar 2023 14:43:54 +0100
Message-Id: <20230310133710.565910093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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



