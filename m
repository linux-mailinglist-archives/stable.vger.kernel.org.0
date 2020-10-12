Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C493928B829
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389965AbgJLNts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731900AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C4222264;
        Mon, 12 Oct 2020 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510457;
        bh=xLlwv3BfOtBg1Qea2YolZf4wEjtSX7kRHJ34V/YGpj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNu+RhI+L2Inxguy9SoJD+pOdKz3/++YBgqM+u/Jbfbrg//8KlmPosOMpGnzFHAQB
         skfhjJ+P1deOY2pPlffrY7OiHLNABGdKViGJwTnak5xay7MtVgPFwxdaNotiL0EyNM
         kcrNw5LyRxQ4/jXWdwY74QakcEhu5kmPctpE8dxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 107/124] net: mscc: ocelot: divide watermark value by 60 when writing to SYS_ATOP
Date:   Mon, 12 Oct 2020 15:31:51 +0200
Message-Id: <20201012133152.038822796@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 601e984f23abcaa7cf3eb078c13de4db3cf6a4f0 ]

Tail dropping is enabled for a port when:

1. A source port consumes more packet buffers than the watermark encoded
   in SYS:PORT:ATOP_CFG.ATOP.

AND

2. Total memory use exceeds the consumption watermark encoded in
   SYS:PAUSE_CFG:ATOP_TOT_CFG.

The unit of these watermarks is a 60 byte memory cell. That unit is
programmed properly into ATOP_TOT_CFG, but not into ATOP. Actually when
written into ATOP, it would get truncated and wrap around.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1438839e3f6ea..61bbb7a090042 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2001,7 +2001,7 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int maxlen = sdu + ETH_HLEN + ETH_FCS_LEN;
 	int pause_start, pause_stop;
-	int atop_wm;
+	int atop, atop_tot;
 
 	if (port == ocelot->npi) {
 		maxlen += OCELOT_TAG_LEN;
@@ -2022,12 +2022,12 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	ocelot_rmw_rix(ocelot, SYS_PAUSE_CFG_PAUSE_STOP(pause_stop),
 		       SYS_PAUSE_CFG_PAUSE_STOP_M, SYS_PAUSE_CFG, port);
 
-	/* Tail dropping watermark */
-	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
+	/* Tail dropping watermarks */
+	atop_tot = (ocelot->shared_queue_sz - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(9 * maxlen),
-			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+	atop = (9 * maxlen) / OCELOT_BUFFER_CELL_SZ;
+	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(atop), SYS_ATOP, port);
+	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_tot), SYS_ATOP_TOT_CFG);
 }
 EXPORT_SYMBOL(ocelot_port_set_maxlen);
 
-- 
2.25.1



