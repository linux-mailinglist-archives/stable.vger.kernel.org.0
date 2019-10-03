Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4CCA89B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391459AbfJCQ3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390954AbfJCQ33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E074820700;
        Thu,  3 Oct 2019 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120168;
        bh=TCzrj21DePjZetssjICk3LSvp+6XekcD+3nP3eSbAjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdmnLKfX1o5bkB2LZ0Znv6F6spbosfleXRIWQ9Mr8ld1E398Dr3lmnLCqexfP+09h
         vziB4xXvPTKPY/7KM8HpLW7PSR/QZSNCZG83VFEs//i2l37/Nxq1miMFxn/yYt9nFh
         ni1qOtxlihZtgZAGraoJ94V3MGMBKjHYx07PV4PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Douthit <stephend@silicom-usa.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 084/313] EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()
Date:   Thu,  3 Oct 2019 17:51:02 +0200
Message-Id: <20191003154541.136326669@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
index ca25f8fe57ef3..1ad538baaa4a9 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -260,11 +260,14 @@ static u64 get_sideband_reg_base_addr(void)
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
@@ -279,15 +282,17 @@ static int dnv_rd_reg(int port, int off, int op, void *data, size_t sz, char *na
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



