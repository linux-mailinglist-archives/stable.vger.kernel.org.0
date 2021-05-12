Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5F37C647
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbhELPuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhELPo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53CD361C8B;
        Wed, 12 May 2021 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832961;
        bh=x6IIQ3xVA6PrYrrXSvlR0k9iFErrr00WFalA7SC+nP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6ti51H3QHPJ5p32jKcr/GhITOxHE0g7Z4DCVBMBtUhQ0ZdSdmWqWRniKn9npzb4z
         qIRJTDMNw4VkkIIJabbXNqZZ0Sd1d9bZB1ScWjlATCYdjuPDz49KSjcskc+XJ+GcNW
         HnMq7RdHm/0a8ERVhrw4PhAy9vdZS6kEt87lYCUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/530] net: enetc: fix link error again
Date:   Wed, 12 May 2021 16:50:04 +0200
Message-Id: <20210512144835.989992361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 74c97ea3b61e4ce149444f904ee8d4fc7073505b ]

A link time bug that I had fixed before has come back now that
another sub-module was added to the enetc driver:

ERROR: modpost: "enetc_ierb_register_pf" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!

The problem is that the enetc Makefile is not actually used for
the ierb module if that is the only built-in driver in there
and everything else is a loadable module.

Fix it by always entering the directory this time, regardless
of which symbols are configured. This should reliably fix the
problem and prevent it from coming back another time.

Fixes: 112463ddbe82 ("net: dsa: felix: fix link error")
Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/Makefile | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 67c436400352..de7b31842233 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -24,6 +24,4 @@ obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
 
 obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
 
-obj-$(CONFIG_FSL_ENETC) += enetc/
-obj-$(CONFIG_FSL_ENETC_MDIO) += enetc/
-obj-$(CONFIG_FSL_ENETC_VF) += enetc/
+obj-y += enetc/
-- 
2.30.2



