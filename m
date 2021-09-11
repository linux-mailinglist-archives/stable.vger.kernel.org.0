Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7DD4076C5
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhIKNN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhIKNNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B77061153;
        Sat, 11 Sep 2021 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365931;
        bh=alr/Fr+3BEJGzOrZJdEg4FUj83fn8nf0tz1XUxDuecY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdHqgJUczF/OiG9x5qeyOWE4uIc58iibPgCsgLuGZ7Qto6pOVn4gcVqxqyj7ALxH7
         JrQSBX4PzvNzaYJZUToEYiilKZZ8g1wU1KpQR5I4jOdnMVbAoeF9G1gsKavDnbePzI
         67kMuzxaOZm/kp9RLabjPnmleHvfbnX0qVQjVqIIdoV9nA9o8EOGk+2tNBCawuTkCP
         Nm9+bylTpoSz6MX+UflhpyMRisERNcMDDqQW3VPlIgNE8QsseTZalsT7aK805NqDAg
         Ge1U/Fttm/xmTkxruRCo+x1Fz7Z+S+N2tK9JppEP2KG5+uQxVn+Ue1/7X5DhpEKHfx
         uWwYK7lG/lLbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 15/32] PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool
Date:   Sat, 11 Sep 2021 09:11:32 -0400
Message-Id: <20210911131149.284397-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
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
index 35e61048e133..0c5813b230b4 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -66,7 +66,7 @@ enum j721e_pcie_mode {
 
 struct j721e_pcie_data {
 	enum j721e_pcie_mode	mode;
-	bool quirk_retrain_flag;
+	unsigned int		quirk_retrain_flag:1;
 };
 
 static inline u32 j721e_pcie_user_readl(struct j721e_pcie *pcie, u32 offset)
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 30db2d68c17a..bc27d126f239 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -303,7 +303,7 @@ struct cdns_pcie_rc {
 	u32			vendor_id;
 	u32			device_id;
 	bool			avail_ib_bar[CDNS_PCIE_RP_MAX_IB];
-	bool                    quirk_retrain_flag;
+	unsigned int		quirk_retrain_flag:1;
 };
 
 /**
-- 
2.30.2

