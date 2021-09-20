Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46464412647
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355015AbhITS4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384477AbhITSsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E16763369;
        Mon, 20 Sep 2021 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159226;
        bh=alr/Fr+3BEJGzOrZJdEg4FUj83fn8nf0tz1XUxDuecY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+y+WTGgwBVLnx2cu4a8A+lHOjBFwXxs5eesVHlXt2d1fcNNQ/GtzQdWy3CFxJBL2
         B3vRGPkvWvsDvh+x3v0KBXZ79+BK+rKCQsj55LMVaY8Z7g8ghleCraV25y+XWx/xOS
         tshMHbNnLHwMt7WTawMIBjJyAClqMOGtiVOqajK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 103/168] PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool
Date:   Mon, 20 Sep 2021 18:44:01 +0200
Message-Id: <20210920163925.023361338@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



