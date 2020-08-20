Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDF24BC38
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgHTMmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgHTJqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD14220724;
        Thu, 20 Aug 2020 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916777;
        bh=1Z+yY8883xRpttdCFfESM34OdyzWiQYyO4wws3jJvZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWoGWhtTurHJ0D/WS4rjOG+FAzAVqybfJWCs5TpcuH+s7EX5LW8n29JOT0MaNDVK/
         nYJtvhjGvmj4aMu/ITQjE8St+WThhIEVFEKMiF2Q+wGVYRm3UNzc134ZmEiPYXKZLj
         DUx/2AVZd+OLep9SE8QZLBjMHgVhoLleMRcZhPes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 041/152] net: ethernet: stmmac: Disable hardware multicast filter
Date:   Thu, 20 Aug 2020 11:20:08 +0200
Message-Id: <20200820091555.766037832@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

commit df43dd526e6609769ae513a81443c7aa727c8ca3 upstream.

The IPQ806x does not appear to have a functional multicast ethernet
address filter. This was observed as a failure to correctly receive IPv6
packets on a LAN to the all stations address. Checking the vendor driver
shows that it does not attempt to enable the multicast filter and
instead falls back to receiving all multicast packets, internally
setting ALLMULTI.

Use the new fallback support in the dwmac1000 driver to correctly
achieve the same with the mainline IPQ806x driver. Confirmed to fix IPv6
functionality on an RB3011 router.

Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -350,6 +350,7 @@ static int ipq806x_gmac_probe(struct pla
 	plat_dat->has_gmac = true;
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
+	plat_dat->multicast_filter_bins = 0;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)


