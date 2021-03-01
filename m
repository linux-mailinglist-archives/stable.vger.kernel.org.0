Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72C328DB5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbhCATQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238330AbhCATKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E19A265013;
        Mon,  1 Mar 2021 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618658;
        bh=auMRN0G+5fsj0k1DzJGn4zdrLsPMVxOR0hAixXmAYjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbJ1frU4wRHOjeTguBGbAUSy1Px4NWnVz0whZD0HWfwUEavTbc1CG/GfoFbn1JlnK
         ZwxrZyFvDLoQgBevwvcXl3meB31aHyryi7INv2axb+FheVhmYVK0XxPHpnYZbnJXrg
         sTbIngThgHFM73EZND6diaHiiriR1ia5rsCpIb4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/663] net: dsa: felix: dont deinitialize unused ports
Date:   Mon,  1 Mar 2021 17:06:16 +0100
Message-Id: <20210301161148.080490383@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 7e506a1d8b2ff..4e53464411edf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -638,8 +638,12 @@ static void felix_teardown(struct dsa_switch *ds)
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



