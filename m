Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF0147E7C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389622AbgAXKJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389250AbgAXKJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:09:29 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2753820709;
        Fri, 24 Jan 2020 10:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860568;
        bh=WbL5FrtL+GKODvfT5Wqg3jR04ZlK0I6T0T3zcFvSMDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/UWCUfyR2q/mOxGlBA5lJo8+JcvsZYwKbMAbF9BfULXUufMPFID3nxZgm7TAT6VW
         7koPnzqmCX80p6cDC16Ui46h1Vz8nNppXW8qHeL3c7EmHe3tLno7kkfIcjNJUTi4vC
         YQcmMeQQ0FOXSI9yPe5NpLzYMykH+NST2Xt5CGz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/639] PCI: iproc: Remove PAXC slot check to allow VF support
Date:   Fri, 24 Jan 2020 10:23:19 +0100
Message-Id: <20200124093051.009814605@linuxfoundation.org>
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

From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

[ Upstream commit 4da6b4480766e5bc9c4d7bc14bf1d0939a1a5fa7 ]

Fix previous incorrect logic that limits PAXC slot number to zero only.
In order for SRIOV/VF to work, we need to allow the slot number to be
greater than zero.

Fixes: 46560388c476c ("PCI: iproc: Allow multiple devices except on PAXC")
Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Signed-off-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 3160e9342a2fb..c20fd6bd68fd8 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -630,14 +630,6 @@ static void __iomem *iproc_pcie_map_cfg_bus(struct iproc_pcie *pcie,
 			return (pcie->base + offset);
 	}
 
-	/*
-	 * PAXC is connected to an internally emulated EP within the SoC.  It
-	 * allows only one device.
-	 */
-	if (pcie->ep_is_internal)
-		if (slot > 0)
-			return NULL;
-
 	return iproc_pcie_map_ep_cfg_reg(pcie, busno, slot, fn, where);
 }
 
-- 
2.20.1



