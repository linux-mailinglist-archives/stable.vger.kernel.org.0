Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B90D232D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbfJJIjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387995AbfJJIjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568502190F;
        Thu, 10 Oct 2019 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696794;
        bh=64kjopHHDGcUZ+tsArg6NpuzNCg62nqj6+KYCnkP7rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s60ug3Bl6RXAEikoJiaf2HuOdOmAmgfzHauvKJJlEiZdlpNQ1JMzmPB0zExsSTlUD
         muQIRQTO74228PSmqF2FFTfbXy3n9P/g6vmKdjFQSZoUiiM6eXLvQWn0KXOI8vRUKI
         93mf0uqzjl3RnHEZG2+vIWMU8bLHeV1TGv4cgT9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.3 055/148] PCI: vmd: Fix shadow offsets to reflect spec changes
Date:   Thu, 10 Oct 2019 10:35:16 +0200
Message-Id: <20191010083614.481390762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit a1a30170138c9c5157bd514ccd4d76b47060f29b upstream.

The shadow offset scratchpad was moved to 0x2000-0x2010. Update the
location to get the correct shadow offset.

Fixes: 6788958e4f3c ("PCI: vmd: Assign membar addresses from shadow registers")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/vmd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -31,6 +31,9 @@
 #define PCI_REG_VMLOCK		0x70
 #define MB2_SHADOW_EN(vmlock)	(vmlock & 0x2)
 
+#define MB2_SHADOW_OFFSET	0x2000
+#define MB2_SHADOW_SIZE		16
+
 enum vmd_features {
 	/*
 	 * Device may contain registers which hint the physical location of the
@@ -578,7 +581,7 @@ static int vmd_enable_domain(struct vmd_
 		u32 vmlock;
 		int ret;
 
-		membar2_offset = 0x2018;
+		membar2_offset = MB2_SHADOW_OFFSET + MB2_SHADOW_SIZE;
 		ret = pci_read_config_dword(vmd->dev, PCI_REG_VMLOCK, &vmlock);
 		if (ret || vmlock == ~0)
 			return -ENODEV;
@@ -590,9 +593,9 @@ static int vmd_enable_domain(struct vmd_
 			if (!membar2)
 				return -ENOMEM;
 			offset[0] = vmd->dev->resource[VMD_MEMBAR1].start -
-						readq(membar2 + 0x2008);
+					readq(membar2 + MB2_SHADOW_OFFSET);
 			offset[1] = vmd->dev->resource[VMD_MEMBAR2].start -
-						readq(membar2 + 0x2010);
+					readq(membar2 + MB2_SHADOW_OFFSET + 8);
 			pci_iounmap(vmd->dev, membar2);
 		}
 	}


