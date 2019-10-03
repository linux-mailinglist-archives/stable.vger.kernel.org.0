Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D314ACA39E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389193AbfJCQRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbfJCQRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C312120700;
        Thu,  3 Oct 2019 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119431;
        bh=pqNJ8pNu97tfTX6kEisVmJXTZF0n5AhEugcUW9k3lp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nK3Ufs2xO+io3JVZUw20QG0yVYzBOcNUv+aJNN1dH6EqjEYHqJgGhK6CDiFrz6JWN
         Z2L1P3rGE9klxMBe/LOfdBOcP0dFAsuk9oUoOucpPS8euagZs9jXuyVvF9XqNNGOIx
         kLVnuhfWTAuaWTjKstz0ARHWQoOpeGMgEUPD/eng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Douthit <stephend@silicom-usa.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/211] EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()
Date:   Thu,  3 Oct 2019 17:52:07 +0200
Message-Id: <20191003154502.401660435@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Douthit <stephend@silicom-usa.com>

[ Upstream commit 29a3388bfcce7a6d087051376ea02bf8326a957b ]

Depending on how BIOS has marked the reserved region containing the 32KB
MCHBAR you can get warnings like:

resource sanity check: requesting [mem 0xfed10000-0xfed1ffff], which spans more than reserved [mem 0xfed10000-0xfed17fff]
caller dnv_rd_reg+0xc8/0x240 [pnd2_edac] mapping multiple BARs

Not all of the mmio regions used in dnv_rd_reg() are the same size.  The
MCHBAR window is 32KB and the sideband ports are 64KB.  Pass the correct
size to ioremap() depending on which resource we're reading from.

Signed-off-by: Stephen Douthit <stephend@silicom-usa.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/pnd2_edac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index 903a4f1fadcc3..0153c730750e5 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -268,11 +268,14 @@ static u64 get_sideband_reg_base_addr(void)
 	}
 }
 
+#define DNV_MCHBAR_SIZE  0x8000
+#define DNV_SB_PORT_SIZE 0x10000
 static int dnv_rd_reg(int port, int off, int op, void *data, size_t sz, char *name)
 {
 	struct pci_dev *pdev;
 	char *base;
 	u64 addr;
+	unsigned long size;
 
 	if (op == 4) {
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x1980, NULL);
@@ -287,15 +290,17 @@ static int dnv_rd_reg(int port, int off, int op, void *data, size_t sz, char *na
 			addr = get_mem_ctrl_hub_base_addr();
 			if (!addr)
 				return -ENODEV;
+			size = DNV_MCHBAR_SIZE;
 		} else {
 			/* MMIO via sideband register base address */
 			addr = get_sideband_reg_base_addr();
 			if (!addr)
 				return -ENODEV;
 			addr += (port << 16);
+			size = DNV_SB_PORT_SIZE;
 		}
 
-		base = ioremap((resource_size_t)addr, 0x10000);
+		base = ioremap((resource_size_t)addr, size);
 		if (!base)
 			return -ENODEV;
 
-- 
2.20.1



