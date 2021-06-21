Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856BA3AEF86
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhFUQkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhFUQhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB296142B;
        Mon, 21 Jun 2021 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292936;
        bh=HYbTZRAy8/F/gBN8gsHM9NM5HdJwKFpKx8WWTYqihpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGPT3Ud3T5He89DKq7LR60iKuBO2C5WVnb7KIdbaJ8TYC3+eAGPyWUtDTD8bpEnM3
         /6yGgek5Q7mM3DpW50QwvXCY4iHhXXZ3IWbcoxQxlxr92YwmRMjoiJNT7liYkPwILI
         YKzJqa6pk6yh9jW7XelE5LS0x25r5q1hjCJL9SMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 022/178] net: dsa: felix: re-enable TX flow control in ocelot_port_flush()
Date:   Mon, 21 Jun 2021 18:13:56 +0200
Message-Id: <20210621154922.511835642@linuxfoundation.org>
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
index 46e5c9136bac..0c4c976548c8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -378,6 +378,7 @@ static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
 
 int ocelot_port_flush(struct ocelot *ocelot, int port)
 {
+	unsigned int pause_ena;
 	int err, val;
 
 	/* Disable dequeuing from the egress queues */
@@ -386,6 +387,7 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 		       QSYS_PORT_MODE, port);
 
 	/* Disable flow control */
+	ocelot_fields_read(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, &pause_ena);
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 
 	/* Disable priority flow control */
@@ -421,6 +423,9 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
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



