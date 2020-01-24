Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5023147B77
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgAXJnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbgAXJnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:50 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E272721556;
        Fri, 24 Jan 2020 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859029;
        bh=Bdr8LkOCOOwN/OjX7FmAJU2t/jbIWi4QoRtWhV4xW0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+AAjhWpCAp3oQ7tqYhY+fLdIvoYn43fVfP0nglH/DfxIqZWwMTd49c65+9fgGmdo
         Y9CcLfz4uX2nzHXmEetdYZO9bnTHeoO5FWGBeacr3Dtgfftq6B/RVoqEhvfkLE3jZ0
         HgadmxrNsx7AOIZ9BieFiMCdTGJbMr4nYqu6AMDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/343] PCI: iproc: Remove PAXC slot check to allow VF support
Date:   Fri, 24 Jan 2020 10:27:10 +0100
Message-Id: <20200124092921.247494555@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
 drivers/pci/host/pcie-iproc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/pci/host/pcie-iproc.c b/drivers/pci/host/pcie-iproc.c
index c0ecc9f35667f..8f8dac0155d63 100644
--- a/drivers/pci/host/pcie-iproc.c
+++ b/drivers/pci/host/pcie-iproc.c
@@ -573,14 +573,6 @@ static void __iomem *iproc_pcie_map_cfg_bus(struct iproc_pcie *pcie,
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



