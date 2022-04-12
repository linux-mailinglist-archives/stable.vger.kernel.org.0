Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6250E4FC9DB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242990AbiDLAsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiDLArc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BC016580;
        Mon, 11 Apr 2022 17:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C424CE0EA2;
        Tue, 12 Apr 2022 00:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593CC385B0;
        Tue, 12 Apr 2022 00:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724313;
        bh=yVc9gM0GvyeesUHCUbbJse0kel0eC1dgwpszLaGwkxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lG+g4f4ctRpq2GBUw6FfKDTcpQCaqlbZWLPX0I1b2bCxOKbLpHmn7H447E+xlmQ1R
         eRFbmQIaCo52GlFNLl5/eLCIUYiOv/Or9qvt1A8UmGNeBk+Lhbe9IRsuuzqyWiN9si
         Y6ZBnnui6V3zjfZP830i503/vOsyjUUdT4aAYgWt1iKnD4dwPRabS/ZmXvM1y+gOGx
         UcGVFzWvdE/bp334q1Z8NhF6qJ8O8OoP1qfDZ3qkOK0w59Z7VLYBp5iRaTDPHxwYLh
         mt8l59eXnljZW6kHTVRmr4HvdsosIdy33HEsV6C+kdgpNSjd+hfArzmra0BhfXlBbE
         el2FYsKtAPL/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, lorenzo.pieralisi@arm.com,
        bhelgaas@google.com, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 15/49] PCI: hv: Propagate coherence from VMbus device to PCI device
Date:   Mon, 11 Apr 2022 20:43:33 -0400
Message-Id: <20220412004411.349427-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 8d21732475c637c7efcdb91dc927a4c594e97898 ]

PCI pass-thru devices in a Hyper-V VM are represented as a VMBus
device and as a PCI device.  The coherence of the VMbus device is
set based on the VMbus node in ACPI, but the PCI device has no
ACPI node and defaults to not hardware coherent.  This results
in extra software coherence management overhead on ARM64 when
devices are hardware coherent.

Fix this by setting up the PCI host bus so that normal
PCI mechanisms will propagate the coherence of the VMbus
device to the PCI device. There's no effect on x86/x64 where
devices are always hardware coherent.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1648138492-2191-3-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index ae0bc2fee4ca..88b3b56d0522 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3404,6 +3404,15 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+#elif defined(CONFIG_ARM64)
+	/*
+	 * Set the PCI bus parent to be the corresponding VMbus
+	 * device. Then the VMbus device will be assigned as the
+	 * ACPI companion in pcibios_root_bridge_prepare() and
+	 * pci_dma_configure() will propagate device coherence
+	 * information to devices created on the bus.
+	 */
+	hbus->sysdata.parent = hdev->device.parent;
 #endif
 
 	hbus->hdev = hdev;
-- 
2.35.1

