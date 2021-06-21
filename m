Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8263AEE30
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFUQ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhFUQY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9F8613BD;
        Mon, 21 Jun 2021 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292491;
        bh=piiJn/vqQ4NodYHaGlI0T4JMB2f61o0iphmtpgrFU14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh5KozJr4/zFiIMSxSWXNYYT4/e2nU5kfqU8UzWLQH5vjRKf00H3U6pAlDr5/MJmq
         qPNRY3wMgoGdTPRnRrynffdDO2ihmxoJimHBYDPEW9i8uimk5iYk5uB6d0/i0FDRW6
         z+Ffug/rNONhFk5nnHWz2SVx7EVnh3XRJKxHwhhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/146] net: dsa: felix: re-enable TX flow control in ocelot_port_flush()
Date:   Mon, 21 Jun 2021 18:14:10 +0200
Message-Id: <20210621154911.958549234@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1650bdb1c516c248fb06f6d076559ff6437a5853 ]

Because flow control is set up statically in ocelot_init_port(), and not
in phylink_mac_link_up(), what happens is that after the blamed commit,
the flow control remains disabled after the port flushing procedure.

Fixes: eb4733d7cffc ("net: dsa: felix: implement port flushing on .phylink_mac_link_down")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index aa400b925b08..5bfc7acfd13a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -355,6 +355,7 @@ static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
 
 int ocelot_port_flush(struct ocelot *ocelot, int port)
 {
+	unsigned int pause_ena;
 	int err, val;
 
 	/* Disable dequeuing from the egress queues */
@@ -363,6 +364,7 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 		       QSYS_PORT_MODE, port);
 
 	/* Disable flow control */
+	ocelot_fields_read(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, &pause_ena);
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 
 	/* Disable priority flow control */
@@ -398,6 +400,9 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 	/* Clear flushing again. */
 	ocelot_rmw_gix(ocelot, 0, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG, port);
 
+	/* Re-enable flow control */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, pause_ena);
+
 	return err;
 }
 EXPORT_SYMBOL(ocelot_port_flush);
-- 
2.30.2



