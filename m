Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ACF3AF0DB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFUQxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhFUQvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E616D6147D;
        Mon, 21 Jun 2021 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293328;
        bh=OEQjkJXIVP4IVLdQ4hM5ZvyNdMYBD1wVUmUs5EGxHXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0row+QeineRHzMvXiLfsLeBibl2EFqu8Lim9nn2wQaWANH9N38SIaSA6rtjLbT/0a
         TrAS2pQjD5XVJtO8erWIocLsx2Dl8HKkDpjGibQE6T3S7tBl+IgcXLm/tXU7gsn5dY
         n1m0mvnFkR0etTqBRkJkLwdGXCWGO5RQHGQSfD7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 173/178] net: stmmac: disable clocks in stmmac_remove_config_dt()
Date:   Mon, 21 Jun 2021 18:16:27 +0200
Message-Id: <20210621154928.634848546@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 8f269102baf788aecfcbbc6313b6bceb54c9b990 upstream.

Platform drivers may call stmmac_probe_config_dt() to parse dt, could
call stmmac_remove_config_dt() in error handing after dt parsed, so need
disable clocks in stmmac_remove_config_dt().

Go through all platforms drivers which use stmmac_probe_config_dt(),
none of them disable clocks manually, so it's safe to disable them in
stmmac_remove_config_dt().

Fixes: commit d2ed0a7755fe ("net: ethernet: stmmac: fix of-node and fixed-link-phydev leaks")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -622,6 +622,8 @@ error_pclk_get:
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
+	clk_disable_unprepare(plat->stmmac_clk);
+	clk_disable_unprepare(plat->pclk);
 	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }


