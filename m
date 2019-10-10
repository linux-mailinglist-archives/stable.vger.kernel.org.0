Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADE9D247A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbfJJIpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388460AbfJJIpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E6D2054F;
        Thu, 10 Oct 2019 08:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697143;
        bh=+Dp3VPKRNAonIXNzDT/w+gGIHl/t8uq8h/pUwdBBssE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDUUY9EPKG+5W+M49glHpXCvSl10G7SYrdQjRGNU3CJnZuM0AYq7JyRT8nBOQwbGP
         t71YC+zBuohDL7+7/ih2lKqy5W0ie5B1QXb99c4ja8q2jRwPSP6ig4pv4nTbhPyYz/
         f+l5VX706O4Gg/MW2Tr51gMoHqpC8SyoRj1p0UaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 033/114] PCI: vmd: Fix shadow offsets to reflect spec changes
Date:   Thu, 10 Oct 2019 10:35:40 +0200
Message-Id: <20191010083600.748316121@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
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
@@ -600,7 +603,7 @@ static int vmd_enable_domain(struct vmd_
 		u32 vmlock;
 		int ret;
 
-		membar2_offset = 0x2018;
+		membar2_offset = MB2_SHADOW_OFFSET + MB2_SHADOW_SIZE;
 		ret = pci_read_config_dword(vmd->dev, PCI_REG_VMLOCK, &vmlock);
 		if (ret || vmlock == ~0)
 			return -ENODEV;
@@ -612,9 +615,9 @@ static int vmd_enable_domain(struct vmd_
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


