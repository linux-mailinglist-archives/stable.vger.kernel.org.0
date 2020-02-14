Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E0215E3B4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406637AbgBNQb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405869AbgBNQ0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:26:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011CD247DC;
        Fri, 14 Feb 2020 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697559;
        bh=rjrhQW09Vso9tajVY7leCL9tNge/xnc21nLf2tfe578=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bO0Tolm7KXc8nhbGLHD/4fnzfDr3rA6nZureeNaA+aWtxZauKJvECwQYTDJoiPjs
         uwsA1pSY/3ehiXBHGoviWQtPbPwp3i2QaAq1GoNsjtjbL2laNxq/ABMk43f9Q2cjjh
         oThNYRnzuEDej4fhYWBYcKzUNIUcUf7IEmFuWOjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 076/100] ide: serverworks: potential overflow in svwks_set_pio_mode()
Date:   Fri, 14 Feb 2020 11:24:00 -0500
Message-Id: <20200214162425.21071-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a97affca18abe..0f57d45484d1d 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -114,6 +114,9 @@ static void svwks_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
+	if (drive->dn >= ARRAY_SIZE(drive_pci))
+		return;
+
 	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
 
 	if (svwks_csb_check(dev)) {
@@ -140,6 +143,9 @@ static void svwks_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 
 	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
 
+	if (drive->dn >= ARRAY_SIZE(drive_pci2))
+		return;
+
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
-- 
2.20.1

