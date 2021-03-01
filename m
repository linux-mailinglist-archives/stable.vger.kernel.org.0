Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F71F328C91
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbhCASx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240469AbhCASrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:47:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B541F652E8;
        Mon,  1 Mar 2021 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620384;
        bh=zKF3EA8IdtI3KSsqeh/LgauoRD+SL3uLU94cFj6lpAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6WY6VusezsW9SAY8VvvhNNxxY1iP/Quwbg7qifSG9osenE6t3NJRiXcDwi88DikX
         DuT3PvQvWUwsvEQpWmWcNb4/eD70bGnD8FHEB40oThUqgD8C3THclOCEwpc0871zwb
         D7NunzkbaX7zQhACMwowA0kHm6LIdYOxFp/yI95g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 132/775] net: dsa: felix: dont deinitialize unused ports
Date:   Mon,  1 Mar 2021 17:05:00 +0100
Message-Id: <20210301161208.186107956@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 42b5adbbac03bdb396192316c015fa3e64ffd5a1 ]

ocelot_init_port is called only if dsa_is_unused_port == false, however
ocelot_deinit_port is called unconditionally. This causes a warning in
the skb_queue_purge inside ocelot_deinit_port saying that the spin lock
protecting ocelot_port->tx_skbs was not initialized.

Fixes: e5fb512d81d0 ("net: mscc: ocelot: deinitialize only initialized ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4aa81034347e2..0f1ee4a4fa55a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -657,8 +657,12 @@ static void felix_teardown(struct dsa_switch *ds)
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
-	for (port = 0; port < ocelot->num_phys_ports; port++)
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
 		ocelot_deinit_port(ocelot, port);
+	}
 
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
-- 
2.27.0



