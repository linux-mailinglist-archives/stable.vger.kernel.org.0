Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9362E417C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391742AbgL1PHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391750AbgL1OIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2837D206C3;
        Mon, 28 Dec 2020 14:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164478;
        bh=82mzM1lZEnwgvckRxASow2+oILhN7WGcmCtxSn4PGJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJN3ATnOCHEz0icSGO9S35bCmrA2r3pBt6hA8GZHxJ+n4cEbYDLxeJffVRWjFrikL
         ymrg/QcyGcGKYFMmhofa84tCFQ83g9/yySc6vHZBclTL+UW/2LHsShqeBM183AETFm
         k1gugCWBxmfm8Vn3KbSNtrCH0fuQ3/KDJDFuYnyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Jim Quinlan <james.quinlan@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/717] PCI: brcmstb: Initialize "tmp" before use
Date:   Mon, 28 Dec 2020 13:42:55 +0100
Message-Id: <20201228125029.445272963@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit ddaff0af653136ee1e0b49116ecf2988c2fc64ca ]

The variable 'tmp' is used multiple times in the brcm_pcie_setup()
function.  One such usage did not initialize 'tmp' to the current value
of the target register.  By luck the mistake does not currently affect
behavior;  regardless 'tmp' is now initialized properly.

Suggested-by: Rafał Miłecki <zajec5@gmail.com>
Link: https://lore.kernel.org/r/20201102205712.23332-1-james.quinlan@broadcom.com
Fixes: c0452137034b ("PCI: brcmstb: Add Broadcom STB PCIe host controller driver")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index bea86899bd5df..9c3d2982248d3 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -893,6 +893,7 @@ static int brcm_pcie_setup(struct brcm_pcie *pcie)
 		burst = 0x2; /* 512 bytes */
 
 	/* Set SCB_MAX_BURST_SIZE, CFG_READ_UR_MODE, SCB_ACCESS_EN */
+	tmp = readl(base + PCIE_MISC_MISC_CTRL);
 	u32p_replace_bits(&tmp, 1, PCIE_MISC_MISC_CTRL_SCB_ACCESS_EN_MASK);
 	u32p_replace_bits(&tmp, 1, PCIE_MISC_MISC_CTRL_CFG_READ_UR_MODE_MASK);
 	u32p_replace_bits(&tmp, burst, PCIE_MISC_MISC_CTRL_MAX_BURST_SIZE_MASK);
-- 
2.27.0



