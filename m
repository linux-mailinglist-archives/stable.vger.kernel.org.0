Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1D1FE91C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgFRCxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgFRBIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022BA21D7E;
        Thu, 18 Jun 2020 01:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442493;
        bh=oRtI3EK4vwV1BYLrXFSQDXPl5jMD+2koWknO8vkCueY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXdRReb0B0GUDnHe+lOwP3g12ADCBF/jDSsnWQ6vYhh6x8RwbNb7inM4DstyVzCpJ
         71OvCy+WTiAbHievzG+AHbBLWsErXM0GFgpjOQJMKCSj338so1S7EuKSZWsFUVyPV2
         TUtpSu4g6qFLXdg5g70H0aWPlM+lrd8/RfVLusYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Honse <calcprogrammer1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 006/388] i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets
Date:   Wed, 17 Jun 2020 21:01:43 -0400
Message-Id: <20200618010805.600873-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Honse <calcprogrammer1@gmail.com>

[ Upstream commit f27237c174fd9653033330e4e532cd9d153ce824 ]

The AMD X370 and other AM4 chipsets (A/B/X 3/4/5 parts) and Threadripper
equivalents have a secondary SMBus controller at I/O port address
0x0B20.  This bus is used by several manufacturers to control
motherboard RGB lighting via embedded controllers.  I have been using
this bus in my OpenRGB project to control the Aura RGB on many
motherboards and ASRock also uses this bus for their Polychrome RGB
controller.

I am not aware of any CZ-compatible platforms which do not have the
second SMBus channel.  All of AMD's AM4- and Threadripper- series
chipsets that OpenRGB users have tested appear to have this secondary
bus.  I also noticed this secondary bus is present on older AMD
platforms including my FM1 home server.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202587
Signed-off-by: Adam Honse <calcprogrammer1@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-piix4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 30ded6422e7b..69740a4ff1db 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -977,7 +977,8 @@ static int piix4_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	if (dev->vendor == PCI_VENDOR_ID_AMD &&
-	    dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) {
+	    (dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS ||
+	     dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS)) {
 		retval = piix4_setup_sb800(dev, id, 1);
 	}
 
-- 
2.25.1

