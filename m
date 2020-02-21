Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D570B1675DA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbgBUINx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733060AbgBUINw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:13:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A93C20578;
        Fri, 21 Feb 2020 08:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272831;
        bh=tKutHQzqUEtlGwZgT4t3m5DF0mw5khkEEf3otkXuA88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GXHztXM5G/IYVLFapJkGDbQuorwcKMOmId8X4hq1s/I5t8NueZOVzcbph2IaJ64T
         5toCFmPPngTUXWqLtnWcmRzNXNpUcC/4BnfP0WfCANuWsC1wYzL9zxtsnO3ZzbCpii
         VC2LfkI1z8hikXmP40TTVH4/fwjlTdEKRNLQDVMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/344] ide: serverworks: potential overflow in svwks_set_pio_mode()
Date:   Fri, 21 Feb 2020 08:41:01 +0100
Message-Id: <20200221072413.414324787@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ce1f31b4c0b9551dd51874dd5364654ed4ca13ae ]

The "drive->dn" variable is a u8 controlled by root.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ide/serverworks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index ac6fc3fffa0de..458e72e034b09 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -115,6 +115,9 @@ static void svwks_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
+	if (drive->dn >= ARRAY_SIZE(drive_pci))
+		return;
+
 	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
 
 	if (svwks_csb_check(dev)) {
@@ -141,6 +144,9 @@ static void svwks_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
+	if (drive->dn >= ARRAY_SIZE(drive_pci2))
+		return;
+
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
-- 
2.20.1



