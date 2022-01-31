Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306B34A4578
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377701AbiAaLlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378669AbiAaLiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:38:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0CDC02B8FE;
        Mon, 31 Jan 2022 03:25:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F3FA61297;
        Mon, 31 Jan 2022 11:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ACAC340E8;
        Mon, 31 Jan 2022 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628306;
        bh=wA6tpPJW7/hPjE0f16wHIPYDgLW97CbU1atKfuSI4to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgtmsO9qZYCm04juK5Ff0bI0EQWsZRTJ5zv/1RgZQ+MuLMVPDQ8Eid72ySUbksLkT
         WWCI8kGIw7CbDfzoyrStDFj17e4PzMREUMLd5GzB4ilo1/THBOsnV3f4h7AL76YjEO
         8XeCeC9fWNVIBHM8R9S0TglUSkbhfF2dM0KEjyP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.16 190/200] PCI: mt7621: Remove unused function pcie_rmw()
Date:   Mon, 31 Jan 2022 11:57:33 +0100
Message-Id: <20220131105239.926196974@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit c035366d9c9fe48d947ee6c43465ab43d42e20f2 upstream.

Function pcie_rmw() is not being used at all and can be deleted. Hence get
rid of it, which fixes this warning:

  drivers/pci/controller/pcie-mt7621.c:112:20: warning: unused function 'pcie_rmw' [-Wunused-function]

Fixes: 2bdd5238e756 ("PCI: mt7621: Add MediaTek MT7621 PCIe host controller driver")
Link: https://lore.kernel.org/r/20220124113003.406224-3-sergio.paracuellos@gmail.com
Link: https://lore.kernel.org/all/202201241754.igtHzgHv-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-mt7621.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/pci/controller/pcie-mt7621.c
+++ b/drivers/pci/controller/pcie-mt7621.c
@@ -109,15 +109,6 @@ static inline void pcie_write(struct mt7
 	writel_relaxed(val, pcie->base + reg);
 }
 
-static inline void pcie_rmw(struct mt7621_pcie *pcie, u32 reg, u32 clr, u32 set)
-{
-	u32 val = readl_relaxed(pcie->base + reg);
-
-	val &= ~clr;
-	val |= set;
-	writel_relaxed(val, pcie->base + reg);
-}
-
 static inline u32 pcie_port_read(struct mt7621_pcie_port *port, u32 reg)
 {
 	return readl_relaxed(port->base + reg);


