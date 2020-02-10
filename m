Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35802157648
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgBJMu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgBJMoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:18 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 768E320661;
        Mon, 10 Feb 2020 12:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338658;
        bh=xG5SeJcEhEvE6IkzAVa8Fi15ahVA/6ZM/EBQpVj+dV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0OpRDdIFqN8cmQVFAw8DWqu308q8Vy9qYP93PNH+a2YqItXI5Hxx2f/f+Tzb01fs
         rXcTYTk3R7/FCa7zQEDmg5LWDYz9X15KXmZTQJMTYwIJWeXqscromZNzQL3Rorjjxw
         UxxrFhvZuqGqmsWvxWL5XInS2wKPqtyh5sfFeRF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tan, Tee Min" <tee.min.tan@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 333/367] net: stmmac: xgmac: fix missing IFF_MULTICAST checki in dwxgmac2_set_filter
Date:   Mon, 10 Feb 2020 04:34:06 -0800
Message-Id: <20200210122453.546037048@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tan, Tee Min" <tee.min.tan@intel.com>

[ Upstream commit 2f633d5820e4ed870f408957322acb9263bce2f4 ]

Without checking for IFF_MULTICAST flag, it is wrong to assume multicast
filtering is always enabled. By checking against IFF_MULTICAST, now
the driver behaves correctly when the multicast support is toggled by below
command:-
  ip link set <devname> multicast off|on

Fixes: 0efedbf11f07a ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -458,7 +458,7 @@ static void dwxgmac2_set_filter(struct m
 
 		for (i = 0; i < XGMAC_MAX_HASH_TABLE; i++)
 			writel(~0x0, ioaddr + XGMAC_HASH_TABLE(i));
-	} else if (!netdev_mc_empty(dev)) {
+	} else if (!netdev_mc_empty(dev) && (dev->flags & IFF_MULTICAST)) {
 		struct netdev_hw_addr *ha;
 
 		value |= XGMAC_FILTER_HMC;


