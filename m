Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775914077A2
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhIKNS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236297AbhIKNQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D2161264;
        Sat, 11 Sep 2021 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366007;
        bh=3yos3JvVPLcMvFsxovYx1mLu68HlfZthsxXRfdeKGhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXCwbUvFC9hHvoNJG1/28GTSaN36eNsQlQF7GQjOAjxGi0wdvTln5sJO+bidZUv/N
         QZYt5nowPZjFthvnK95LkDl5zY+yGra32HJFy40EO2ACEq0VHlWZlbqdsRkcFvhVMr
         bn4xRCwCSt4bAPh9s6BvhhddprDmXJBHJnLKuGmsoEh0Tkg3niahmcev8TiZKF9S74
         U7NkCskhRjV7BZoRDzgM/QRKlN9rO0Jw/xzxOl829lyXPTdBc6whQDhdtRABNP74lm
         PpN9DiYVUvsLqQPLAzM08j/7CJO0M8ldyxEinYxqy4Bh+/0XAPYIVF3dB4oFV4CCFY
         7wFszID15/bzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 11/25] PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool
Date:   Sat, 11 Sep 2021 09:12:58 -0400
Message-Id: <20210911131312.285225-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit f4455748b2126a9ba2bcc9cfb2fbcaa08de29bb2 ]

No functional change. As we are intending to add additional 1-bit
members in struct j721e_pcie_data/struct cdns_pcie_rc, use bitfields
instead of bool since it takes less space. As discussed in [1],
the preference is to use bitfileds instead of bool inside structures.

[1] -> https://lore.kernel.org/linux-fsdevel/CA+55aFzKQ6Pj18TB8p4Yr0M4t+S+BsiHH=BJNmn=76-NcjTj-g@mail.gmail.com/

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20210811123336.31357-2-kishon@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c    | 2 +-
 drivers/pci/controller/cadence/pcie-cadence.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index d34ca0fda0f6..973b309ac9ba 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -63,7 +63,7 @@ enum j721e_pcie_mode {
 
 struct j721e_pcie_data {
 	enum j721e_pcie_mode	mode;
-	bool quirk_retrain_flag;
+	unsigned int		quirk_retrain_flag:1;
 };
 
 static inline u32 j721e_pcie_user_readl(struct j721e_pcie *pcie, u32 offset)
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 6705a5fedfbb..60981877f65b 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -299,7 +299,7 @@ struct cdns_pcie_rc {
 	u32			vendor_id;
 	u32			device_id;
 	bool			avail_ib_bar[CDNS_PCIE_RP_MAX_IB];
-	bool                    quirk_retrain_flag;
+	unsigned int		quirk_retrain_flag:1;
 };
 
 /**
-- 
2.30.2

