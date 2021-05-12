Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0D37CEA6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345091AbhELRGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237886AbhELQtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 217FA61D53;
        Wed, 12 May 2021 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836162;
        bh=x6IIQ3xVA6PrYrrXSvlR0k9iFErrr00WFalA7SC+nP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUlJKozLqhQENd1pSvhXEhDdQ/qCVjswFaQLrX2TU9cyvEG9AVBoAOvqJp+LXIQh8
         KkyXr9GN9U7FCDmibkz8P1HoiAWTZgykJT5JxTUh81vjp97Y5OAEbK0RdzTk1C/SBy
         NozItVn5poC08F2hcM9GmaafCAteHzGsXmdfZ1Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 634/677] net: enetc: fix link error again
Date:   Wed, 12 May 2021 16:51:20 +0200
Message-Id: <20210512144858.427369074@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



