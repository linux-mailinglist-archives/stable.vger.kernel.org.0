Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403C2137EC4
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgAKKNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgAKKNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:13:36 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A857420673;
        Sat, 11 Jan 2020 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737615;
        bh=HlecI9gKXoWl/hPCI+PALO7fLagPd1bhdYS2AohH6bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8j6VFAGcH9ORbMddatS4fmcZAuQc6oOqa3lF+Y74aRmXpGvj6cNKq19q9BeAZzol
         xvNJ1s92wqrPup+uRALTd1AvOlY6Sz9it1myfRUoKHmZE6XSpanm/uV5Af5QmJUq/P
         Ezl36EKi6FIqUBmGtDT+9XSmVCEhnO7eT9H2d30Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 51/62] net: stmmac: dwmac-sun8i: Allow all RGMII modes
Date:   Sat, 11 Jan 2020 10:50:33 +0100
Message-Id: <20200111094853.543106050@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit f1239d8aa84dad8fe4b6cc1356f40fc8e842db47 ]

Allow all the RGMII modes to be used. This would allow us to represent
the hardware better in the device tree with RGMII_ID where in most
cases the PHY's internal delay for both RX and TX are used.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -724,6 +724,9 @@ static int sun8i_dwmac_set_syscon(struct
 		/* default */
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		reg |= SYSCON_EPIT | SYSCON_ETCS_INT_GMII;
 		break;
 	case PHY_INTERFACE_MODE_RMII:


