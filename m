Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4413E412
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388802AbgAPRFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388668AbgAPRFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D805217F4;
        Thu, 16 Jan 2020 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194353;
        bh=nPZ1XTnaEG3wsEn3/9GneQYMObYjOmeffnxVFFkkbUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCaTg6b06C8KN3Qmb0E9olqbC8JMT6V2z6zvw+g9BPtqdJFAGMJawTUgsVS64CZtO
         LcFmBwLDU3PTcii4PpN9Lz/o0ipKfaRWQrnI5SKkXoeX6ILkxH5uG4mOP5idOuZt4X
         Rt/grCc9LZGu+9yWtecoT2h0KZpDZcoo6a5cdUSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 292/671] PCI: rockchip: Fix rockchip_pcie_ep_assert_intx() bitwise operations
Date:   Thu, 16 Jan 2020 11:58:50 -0500
Message-Id: <20200116170509.12787-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b8163c56a142..caf34661d38d 100644
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

