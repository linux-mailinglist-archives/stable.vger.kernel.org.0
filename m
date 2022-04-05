Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B7F4F4172
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351421AbiDEMIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358163AbiDEK2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374799D4FD;
        Tue,  5 Apr 2022 03:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA07E617AC;
        Tue,  5 Apr 2022 10:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D192FC385A0;
        Tue,  5 Apr 2022 10:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153765;
        bh=oQol12NXJTmIhclid5lByyWV5QiK2rwhkoALF3HfbRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFMQ+Dah5PmQGArpTYbp/omJP5yCyplEmzsIERL+8F+QSGUecgJN8MYYRbFQ7wy4S
         ZqfEXlt2RjjJllKWUf2252o+EdWbW8C1s07tZyFvHesjWlD/Jf1zhRjcDkNiBrC5Hi
         FoyZV6bFVDFM3nbzKsh5Ksda5NJhG3/uNyLOzJsI=
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
Subject: [PATCH 5.10 340/599] PCI: Reduce warnings on possible RW1C corruption
Date:   Tue,  5 Apr 2022 09:30:34 +0200
Message-Id: <20220405070308.951211820@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 46935695cfb9..8d0d1f61c650 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -160,9 +160,12 @@ int pci_generic_config_write32(struct pci_bus *bus, unsigned int devfn,
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
index 4519bd12643f..bc5a1150f072 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -638,6 +638,7 @@ struct pci_bus {
 	struct bin_attribute	*legacy_io;	/* Legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem;	/* Legacy mem */
 	unsigned int		is_added:1;
+	unsigned int		unsafe_warn:1;	/* warned about RW1C config write */
 };
 
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
-- 
2.34.1



