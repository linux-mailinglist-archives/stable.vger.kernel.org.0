Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B093BA5D7
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389715AbfIVSp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389698AbfIVSp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2855620882;
        Sun, 22 Sep 2019 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177956;
        bh=TCzrj21DePjZetssjICk3LSvp+6XekcD+3nP3eSbAjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vLG+5qDB+4kKAFZk3xHGv8iuiQMckZFyOJHG7baM6akgUOWAcdXsJgsy/vaSgIY7
         cd3qJoJZD7ZO6vBe1kHfuxxrlntByRUkcjKlNQ+ZmrTYbr+8rGGMVi7y1SkbnU5Zts
         QK9OEo9DtIvdxezEAjv2hgjFYp+og6a/xBKOcqd4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Douthit <stephend@silicom-usa.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 061/203] EDAC, pnd2: Fix ioremap() size in dnv_rd_reg()
Date:   Sun, 22 Sep 2019 14:41:27 -0400
Message-Id: <20190922184350.30563-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

