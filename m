Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7B6AF082
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjCGSbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjCGSaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0622525BBE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A50DDB819D3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD543C4339B;
        Tue,  7 Mar 2023 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213441;
        bh=G31j6pkn9FWOyso2QvJ9lZKO7Mt7932KoufaZD5P4NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QGKHXYSa3EpIPgv/0GeFFly2u5RXRIMWMhUwslAGQMj55y8KSUu3HoFALj6dxsA1
         rMX0knYggZUCOHQLWIg/nol+UBaGkxTJ9WjhjW7B6HODH3ndn4mwlqSgtRZesjtM3C
         SiY3KEivPieoWq2hYduSNpgLGicSYC3iNzc/GJYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 478/885] PCI: Fix dropping valid root bus resources with .end = zero
Date:   Tue,  7 Mar 2023 17:56:52 +0100
Message-Id: <20230307170023.252516404@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9d8ba74a181b1c81def21168795ed96cbe6f05ed ]

On r8a7791/koelsch:

  kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
  # cat /sys/kernel/debug/kmemleak
  unreferenced object 0xc3a34e00 (size 64):
    comm "swapper/0", pid 1, jiffies 4294937460 (age 199.080s)
    hex dump (first 32 bytes):
      b4 5d 81 f0 b4 5d 81 f0 c0 b0 a2 c3 00 00 00 00  .]...]..........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<fe3aa979>] __kmalloc+0xf0/0x140
      [<34bd6bc0>] resource_list_create_entry+0x18/0x38
      [<767046bc>] pci_add_resource_offset+0x20/0x68
      [<b3f3edf2>] devm_of_pci_get_host_bridge_resources.constprop.0+0xb0/0x390

When coalescing two resources for a contiguous aperture, the second
resource is enlarged to cover the full contiguous range, while the first
resource is marked invalid.  This invalidation is done by clearing the
flags, start, and end members.

When adding the initial resources to the bus later, invalid resources are
skipped.  Unfortunately, the check for an invalid resource considers only
the end member, causing false positives.

E.g. on r8a7791/koelsch, root bus resource 0 ("bus 00") is skipped, and no
longer registered with pci_bus_insert_busn_res() (causing the memory leak),
nor printed:

   pci-rcar-gen2 ee090000.pci: host bridge /soc/pci@ee090000 ranges:
   pci-rcar-gen2 ee090000.pci:      MEM 0x00ee080000..0x00ee08ffff -> 0x00ee080000
   pci-rcar-gen2 ee090000.pci: PCI: revision 11
   pci-rcar-gen2 ee090000.pci: PCI host bridge to bus 0000:00
  -pci_bus 0000:00: root bus resource [bus 00]
   pci_bus 0000:00: root bus resource [mem 0xee080000-0xee08ffff]

Fix this by only skipping resources where all of the flags, start, and end
members are zero.

Fixes: 7c3855c423b17f6c ("PCI: Coalesce host bridge contiguous apertures")
Link: https://lore.kernel.org/r/da0fcd5e86c74239be79c7cb03651c0fce31b515.1676036673.git.geert+renesas@glider.be
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1d6f7b502020d..90e676439170b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -994,7 +994,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	resource_list_for_each_entry_safe(window, n, &resources) {
 		offset = window->offset;
 		res = window->res;
-		if (!res->end)
+		if (!res->flags && !res->start && !res->end)
 			continue;
 
 		list_move_tail(&window->node, &bridge->windows);
-- 
2.39.2



