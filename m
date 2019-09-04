Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA81A8F95
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388772AbfIDSEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389110AbfIDSEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F70D206BA;
        Wed,  4 Sep 2019 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620276;
        bh=1gz43MtbkLW9vDDQwtFpGHs8+iCwIumiNFT6QK+MqAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwnruCRoP4j7jC6TKGL/gNGlNFKcfZWE25JSKv4RGBD+xZgD8uFEI+Hx88VR4KleP
         cF0xAMLu4433WLTW9tU5On2vTHPFv/nfsYxT4QYfbb23Sgq1Jx96dKwF/mrKh/ZSuL
         zlfEr9pHreX9Lm5EDU26auFZAjbqhKef6GVC79f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooks <andrew.cooks@opengear.com>,
        Jean Delvare <jdelvare@suse.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 56/57] i2c: piix4: Fix port selection for AMD Family 16h Model 30h
Date:   Wed,  4 Sep 2019 19:54:24 +0200
Message-Id: <20190904175307.476249941@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7c06a1532f3fe106687ac82a13492c6a619ff1c ]

Family 16h Model 30h SMBus controller needs the same port selection fix
as described and fixed in commit 0fe16195f891 ("i2c: piix4: Fix SMBus port
selection for AMD Family 17h chips")

commit 6befa3fde65f ("i2c: piix4: Support alternative port selection
register") also fixed the port selection for Hudson2, but unfortunately
this is not the exact same device and the AMD naming and PCI Device IDs
aren't particularly helpful here.

The SMBus port selection register is common to the following Families
and models, as documented in AMD's publicly available BIOS and Kernel
Developer Guides:

 50742 - Family 15h Model 60h-6Fh (PCI_DEVICE_ID_AMD_KERNCZ_SMBUS)
 55072 - Family 15h Model 70h-7Fh (PCI_DEVICE_ID_AMD_KERNCZ_SMBUS)
 52740 - Family 16h Model 30h-3Fh (PCI_DEVICE_ID_AMD_HUDSON2_SMBUS)

The Hudson2 PCI Device ID (PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) is shared
between Bolton FCH and Family 16h Model 30h, but the location of the
SmBus0Sel port selection bits are different:

 51192 - Bolton Register Reference Guide

We distinguish between Bolton and Family 16h Model 30h using the PCI
Revision ID:

  Bolton is device 0x780b, revision 0x15
  Family 16h Model 30h is device 0x780b, revision 0x1F
  Family 15h Model 60h and 70h are both device 0x790b, revision 0x4A.

The following additional public AMD BKDG documents were checked and do
not share the same port selection register:

 42301 - Family 15h Model 00h-0Fh doesn't mention any
 42300 - Family 15h Model 10h-1Fh doesn't mention any
 49125 - Family 15h Model 30h-3Fh doesn't mention any

 48751 - Family 16h Model 00h-0Fh uses the previously supported
         index register SB800_PIIX4_PORT_IDX_ALT at 0x2e

Signed-off-by: Andrew Cooks <andrew.cooks@opengear.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org [v4.6+]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-piix4.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 174579d32e5f3..4b81dc231b18f 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -99,7 +99,7 @@
 #define SB800_PIIX4_PORT_IDX_MASK	0x06
 #define SB800_PIIX4_PORT_IDX_SHIFT	1
 
-/* On kerncz, SmBus0Sel is at bit 20:19 of PMx00 DecodeEn */
+/* On kerncz and Hudson2, SmBus0Sel is at bit 20:19 of PMx00 DecodeEn */
 #define SB800_PIIX4_PORT_IDX_KERNCZ		0x02
 #define SB800_PIIX4_PORT_IDX_MASK_KERNCZ	0x18
 #define SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ	3
@@ -359,18 +359,16 @@ static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 
 	/* Find which register is used for port selection */
 	if (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD) {
-		switch (PIIX4_dev->device) {
-		case PCI_DEVICE_ID_AMD_KERNCZ_SMBUS:
+		if (PIIX4_dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS ||
+		    (PIIX4_dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
+		     PIIX4_dev->revision >= 0x1F)) {
 			piix4_port_sel_sb800 = SB800_PIIX4_PORT_IDX_KERNCZ;
 			piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK_KERNCZ;
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ;
-			break;
-		case PCI_DEVICE_ID_AMD_HUDSON2_SMBUS:
-		default:
+		} else {
 			piix4_port_sel_sb800 = SB800_PIIX4_PORT_IDX_ALT;
 			piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-			break;
 		}
 	} else {
 		mutex_lock(&piix4_mutex_sb800);
-- 
2.20.1



