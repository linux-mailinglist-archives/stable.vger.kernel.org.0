Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B846F28B7E8
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgJLNrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389777AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A520221FF;
        Mon, 12 Oct 2020 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510352;
        bh=nrUCIaPMPD9SNcAvHONx1hFsQi93OF+qt8Xn/CI3OyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVc86xcA5THxgKWLpHxJptjHpZaD+oGqvyCGbfLdrTAY9HMo59smTqhnkODVn6ugu
         gKNzeocJ70pxDnSPsREwMZwXmJTKwXApCtUI4ONe0XET6DsT4DYpRaRfhYgVYJkjaq
         MgEfuAzf5+4p8u2HKCUoTIBcnCZSqdmMwDhJ9cOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 063/124] net: dsa: felix: convert TAS link speed based on phylink speed
Date:   Mon, 12 Oct 2020 15:31:07 +0200
Message-Id: <20201012133149.910888010@linuxfoundation.org>
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

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit dba1e4660a87927bdc03c23e36fd2c81a16a7ab1 ]

state->speed holds a value of 10, 100, 1000 or 2500, but
QSYS_TAG_CONFIG_LINK_SPEED expects a value of 0, 1, 2, 3. So convert the
speed to a proper value.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7c167a394b762..a83ecd1c5d6c2 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1215,8 +1215,28 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
+	u8 tas_speed;
+
+	switch (speed) {
+	case SPEED_10:
+		tas_speed = OCELOT_SPEED_10;
+		break;
+	case SPEED_100:
+		tas_speed = OCELOT_SPEED_100;
+		break;
+	case SPEED_1000:
+		tas_speed = OCELOT_SPEED_1000;
+		break;
+	case SPEED_2500:
+		tas_speed = OCELOT_SPEED_2500;
+		break;
+	default:
+		tas_speed = OCELOT_SPEED_1000;
+		break;
+	}
+
 	ocelot_rmw_rix(ocelot,
-		       QSYS_TAG_CONFIG_LINK_SPEED(speed),
+		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
 }
-- 
2.25.1



