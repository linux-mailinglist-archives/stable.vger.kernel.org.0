Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9429614844D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390363AbgAXLQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390360AbgAXLQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:27 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A98C2077C;
        Fri, 24 Jan 2020 11:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864586;
        bh=fsE1GfhrSbKu3pQpLV0LKCFIRXEanynsbFs5sGymykw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEnULglpP4XfmZFYDx05KOEa4lXqrwfRwzyfvxRXV3tgQWrubSASZfn0ESHnVZbCc
         y8XaeS04oqJwix60nPM0Wxyonj+1lHpT26fLZVQ42IAQ+x69LrHlVwoRQMQN1XJfkf
         0saC+eWETPDq96CDdiux4PASR0nu3DnWfOEPolN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 307/639] PCI: rockchip: Fix rockchip_pcie_ep_assert_intx() bitwise operations
Date:   Fri, 24 Jan 2020 10:27:57 +0100
Message-Id: <20200124093125.386544917@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c577f4a5a08bb9677e12ddafb62e2f3a901de87f ]

Currently the bitwise operations on the u16 variable 'status' with
the setting ROCKCHIP_PCIE_EP_CMD_STATUS_IS are incorrect because
ROCKCHIP_PCIE_EP_CMD_STATUS_IS is 1UL<<19 which is wider than the
u16 variable.

Fix this by making status a u32.

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index b8163c56a142d..caf34661d38d4 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -350,7 +350,7 @@ static void rockchip_pcie_ep_assert_intx(struct rockchip_pcie_ep *ep, u8 fn,
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 	u32 r = ep->max_regions - 1;
 	u32 offset;
-	u16 status;
+	u32 status;
 	u8 msg_code;
 
 	if (unlikely(ep->irq_pci_addr != ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR ||
-- 
2.20.1



