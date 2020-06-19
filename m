Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C302013D7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392044AbgFSQEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392039AbgFSPKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3438206FA;
        Fri, 19 Jun 2020 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579441;
        bh=W9NDGKPF9pC8bklJ+MLGv1XFofDCYAUQi70eNJtJEgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjUMSslsYEPUNs4oeojWMY6I0iTW40jtRR4qndSAr8nu3OPOfEMpTq5YHHKIcXw1l
         5uRQ+we2xtd/E5c/fybHIZhA6+aaXsIw5znCKFtWBNYpiPD+wKY1ttNMQcv1nmQTRJ
         26J3VGMuL23a2O5c971wf4mdnbouP2kWZpZJjD6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/261] PCI: Dont disable decoding when mmio_always_on is set
Date:   Fri, 19 Jun 2020 16:32:28 +0200
Message-Id: <20200619141656.423071816@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit b6caa1d8c80cb71b6162cb1f1ec13aa655026c9f ]

Don't disable MEM/IO decoding when a device have both non_compliant_bars
and mmio_always_on.

That would allow us quirk devices with junk in BARs but can't disable
their decoding.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Acked-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d3033873395d..48209d915de3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1777,7 +1777,7 @@ int pci_setup_device(struct pci_dev *dev)
 	/* Device class may be changed after fixup */
 	class = dev->class >> 8;
 
-	if (dev->non_compliant_bars) {
+	if (dev->non_compliant_bars && !dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
 		if (cmd & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 			pci_info(dev, "device has non-compliant BARs; disabling IO/MEM decoding\n");
-- 
2.25.1



