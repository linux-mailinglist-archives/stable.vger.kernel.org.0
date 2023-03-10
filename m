Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5571A6B435A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjCJONv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjCJON3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:13:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AE611CBFC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B49B822B9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2FFC433D2;
        Fri, 10 Mar 2023 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457509;
        bh=Yjn/miN5Ms+DDaKaJ7TGYSPNfB4/50MyPTdwkdXaLyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4XSWMFhNezXfwKd8u+34OO+O8O/qwREfC8Rx4RxyGQjeewxQ73x6FyaStwGrPlVx
         9SgjQX/Izzw6MelfmDfKMF+7EbDpS1mLUG1AMqvAGMID/Nrh9w20d4sOkpZxgH2LPh
         gytr1wpuaBCxyxBGxR20opadJEihFB7bOmlp9xM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/200] PCI: Align extra resources for hotplug bridges properly
Date:   Fri, 10 Mar 2023 14:39:27 +0100
Message-Id: <20230310133722.030773220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index b4096598dbcbb..e440f264accb8 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1891,6 +1891,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	 * resource space between hotplug bridges.
 	 */
 	for_each_pci_bridge(dev, bus) {
+		struct resource *res;
 		struct pci_bus *b;
 
 		b = dev->subordinate;
@@ -1902,16 +1903,28 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
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



