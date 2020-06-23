Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BC0206579
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgFWUEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387608AbgFWUEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9802082F;
        Tue, 23 Jun 2020 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942647;
        bh=815DJpzVMaHIxTR+LNLWiZWJzBLO+5q9S2l+VW5VseQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krAWAH356xINRCTlrK+eLseaWUl62USCdXkL93YlKvcXT6ODcOvftZMSVWxcv3bZj
         v+8oUCMTCEwQkZINEQ0FW3Xmhbd1+uF7sSkWh4j6GOSJAuZKwvODhrfeS3LZfJGZ52
         +k8OfbNupBqTjNxgU0KDOGAQwIVbGBoloB6Lgdsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 081/477] PCI: vmd: Filter resource type bits from shadow register
Date:   Tue, 23 Jun 2020 21:51:18 +0200
Message-Id: <20200623195411.437630175@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit 3e5095eebe015d5a4d566aa5e03c8621add5f0a7 ]

Versions of VMD with the Host Physical Address shadow register use this
register to calculate the bus address offset needed to do guest
passthrough of the domain. This register shadows the Host Physical
Address registers including the resource type bits. After calculating
the offset, the extra resource type bits lead to the VMD resources being
over-provisioned at the front and under-provisioned at the back.

Example:
pci 10000:80:02.0: reg 0x10: [mem 0xf801fffc-0xf803fffb 64bit]

Expected:
pci 10000:80:02.0: reg 0x10: [mem 0xf8020000-0xf803ffff 64bit]

If other devices are mapped in the over-provisioned front, it could lead
to resource conflict issues with VMD or those devices.

Link: https://lore.kernel.org/r/20200528030240.16024-3-jonathan.derrick@intel.com
Fixes: a1a30170138c9 ("PCI: vmd: Fix shadow offsets to reflect spec changes")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index dac91d60701de..e386d4eac4070 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -445,9 +445,11 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 			if (!membar2)
 				return -ENOMEM;
 			offset[0] = vmd->dev->resource[VMD_MEMBAR1].start -
-					readq(membar2 + MB2_SHADOW_OFFSET);
+					(readq(membar2 + MB2_SHADOW_OFFSET) &
+					 PCI_BASE_ADDRESS_MEM_MASK);
 			offset[1] = vmd->dev->resource[VMD_MEMBAR2].start -
-					readq(membar2 + MB2_SHADOW_OFFSET + 8);
+					(readq(membar2 + MB2_SHADOW_OFFSET + 8) &
+					 PCI_BASE_ADDRESS_MEM_MASK);
 			pci_iounmap(vmd->dev, membar2);
 		}
 	}
-- 
2.25.1



