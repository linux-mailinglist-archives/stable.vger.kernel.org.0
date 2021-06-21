Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37803AEEE2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhFUQdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhFUQbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15AA76138C;
        Mon, 21 Jun 2021 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292727;
        bh=4UBEDegR1+ok8VwfXrcRVjGbp2H2ycDcefRkifNqyCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmkH2Yr2+AzyWxCI3/CPFzWT94+YuEClJU2vVdvQshKKWVkbIZ3oXMCr746laMjTU
         O5zBnmoCBk6ETKsByCIRPVHiKFoSHQd6Z99AvL9PE1DLemOLYj1ToTwEsZpvGRfAyj
         H28eYsgvYjNR52wASIC5nirc6vWAYMQF55AE6P+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Antti=20J=C3=A4rvinen?= <antti.jarvinen@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.10 107/146] PCI: Mark TI C667X to avoid bus reset
Date:   Mon, 21 Jun 2021 18:15:37 +0200
Message-Id: <20210621154918.077242614@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antti Järvinen <antti.jarvinen@gmail.com>

commit b5cf198e74a91073d12839a3e2db99994a39995d upstream.

Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS
automatically disables LTSSM when Secondary Bus Reset is received and
device stops working.  Prevent bus reset for these devices.  With this
change, the device can be assigned to VMs with VFIO, but it will leak state
between VMs.

Reference: https://e2e.ti.com/support/processors/f/791/t/954382
Link: https://lore.kernel.org/r/20210315102606.17153-1-antti.jarvinen@gmail.com
Signed-off-by: Antti Järvinen <antti.jarvinen@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3577,6 +3577,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
  */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CAVIUM, 0xa100, quirk_no_bus_reset);
 
+/*
+ * Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS
+ * automatically disables LTSSM when Secondary Bus Reset is received and
+ * the device stops working.  Prevent bus reset for these devices.  With
+ * this change, the device can be assigned to VMs with VFIO, but it will
+ * leak state between VMs.  Reference
+ * https://e2e.ti.com/support/processors/f/791/t/954382
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0xb005, quirk_no_bus_reset);
+
 static void quirk_no_pm_reset(struct pci_dev *dev)
 {
 	/*


