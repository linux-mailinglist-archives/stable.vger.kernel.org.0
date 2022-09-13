Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9005B76F4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiIMQ4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiIMQ4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:56:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9738C1643;
        Tue, 13 Sep 2022 08:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE827CE1273;
        Tue, 13 Sep 2022 14:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CF8C433C1;
        Tue, 13 Sep 2022 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078451;
        bh=3BSSrrckkiUT+M4KgCKxJzZ3guEYDiztQUWQfifjOCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtmR4/OLMyFlFtYL6xCzeoBM8zlp1fi3RtlvUKWv350E5bP1dg7ZNrc7ZWGDQS+Mm
         GZopTdlz1XUgfiDInDgkKvPBpTYLsxzgDdBSzmKsbnArjoKUVAMONmFQK2Vk1XtJMF
         cXbILqUHCm+nNJAlJoJ0nPE03IyXATIF5DGUTvBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 145/192] net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set
Date:   Tue, 13 Sep 2022 16:04:11 +0200
Message-Id: <20220913140417.244377226@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a4bb481aeb9d84cb53112a478e6db4705b794c34 ]

The read-modify-write of QSYS_TAG_CONFIG from vsc9959_sched_speed_set()
runs unlocked with respect to the other functions that access it, which
are vsc9959_tas_guard_bands_update(), vsc9959_qos_port_tas_set() and
vsc9959_tas_clock_adjust(). All the others are under ocelot->tas_lock,
so move the vsc9959_sched_speed_set() access under that lock as well, to
resolve the concurrency.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2a5822c619ef3..f1767a6b9271c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1664,13 +1664,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		break;
 	}
 
+	mutex_lock(&ocelot->tas_lock);
+
 	ocelot_rmw_rix(ocelot,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
 
-	mutex_lock(&ocelot->tas_lock);
-
 	if (ocelot_port->taprio)
 		vsc9959_tas_guard_bands_update(ocelot, port);
 
-- 
2.35.1



