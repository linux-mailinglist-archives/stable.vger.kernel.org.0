Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88865505648
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbiDRNdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241787AbiDRN06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604F93E5E9;
        Mon, 18 Apr 2022 05:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00D26129D;
        Mon, 18 Apr 2022 12:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE1FC385A1;
        Mon, 18 Apr 2022 12:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286388;
        bh=yB13W5tOao+PMMsRCdoow1rYwhVmMajvCfsHTW3TQNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDo9awIKOgFl2LvS0ppErDohT/ntvpdX9numRhQjJ/qDPWzf196vfrY5NTTAT/rVC
         snPCxln6uti731voEq03LEC+HZdb8wQ+ib2Md2ulAkBSx8rRX/Kh5H0oYGPMJ8FM8H
         eoLdpU90ftoZDTa0E1TNUbuTOEC3LHg5Le5riwx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/284] PCI: Reduce warnings on possible RW1C corruption
Date:   Mon, 18 Apr 2022 14:11:39 +0200
Message-Id: <20220418121214.430848350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 92c45b63ce22c8898aa41806e8d6692bcd577510 ]

For hardware that only supports 32-bit writes to PCI there is the
possibility of clearing RW1C (write-one-to-clear) bits. A rate-limited
messages was introduced by fb2659230120, but rate-limiting is not the best
choice here. Some devices may not show the warnings they should if another
device has just produced a bunch of warnings. Also, the number of messages
can be a nuisance on devices which are otherwise working fine.

Change the ratelimit to a single warning per bus. This ensures no bus is
'starved' of emitting a warning and also that there isn't a continuous
stream of warnings. It would be preferable to have a warning per device,
but the pci_dev structure is not available here, and a lookup from devfn
would be far too slow.

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Fixes: fb2659230120 ("PCI: Warn on possible RW1C corruption for sub-32 bit config writes")
Link: https://lore.kernel.org/r/20200806041455.11070-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/access.c | 9 ++++++---
 include/linux/pci.h  | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 8c585e7ca520..9ae710a63d38 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -161,9 +161,12 @@ int pci_generic_config_write32(struct pci_bus *bus, unsigned int devfn,
 	 * write happen to have any RW1C (write-one-to-clear) bits set, we
 	 * just inadvertently cleared something we shouldn't have.
 	 */
-	dev_warn_ratelimited(&bus->dev, "%d-byte config write to %04x:%02x:%02x.%d offset %#x may corrupt adjacent RW1C bits\n",
-			     size, pci_domain_nr(bus), bus->number,
-			     PCI_SLOT(devfn), PCI_FUNC(devfn), where);
+	if (!bus->unsafe_warn) {
+		dev_warn(&bus->dev, "%d-byte config write to %04x:%02x:%02x.%d offset %#x may corrupt adjacent RW1C bits\n",
+			 size, pci_domain_nr(bus), bus->number,
+			 PCI_SLOT(devfn), PCI_FUNC(devfn), where);
+		bus->unsafe_warn = 1;
+	}
 
 	mask = ~(((1 << (size * 8)) - 1) << ((where & 0x3) * 8));
 	tmp = readl(addr) & mask;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 66c0d5fad0cb..521030233c8d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -569,6 +569,7 @@ struct pci_bus {
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
 	unsigned int		is_added:1;
+	unsigned int		unsafe_warn:1;	/* warned about RW1C config write */
 };
 
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
-- 
2.34.1



