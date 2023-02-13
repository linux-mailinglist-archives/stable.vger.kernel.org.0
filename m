Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC66948DB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjBMOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBMOxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3199D528
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 379CB6106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514E8C433EF;
        Mon, 13 Feb 2023 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300023;
        bh=hgQPDfxDuqH9PPSbIf5ZCKywezKNqskkVopiWAgPIKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRjbqwELwEG/NrIZkqfAp/pYl5no6wzS8VudWogkRtA6gJGBSI8c56SWNpUDwoAm/
         zLUfDepopwsqEtfoIYfddqOsO58ZTXdLTeHz1BRjsc4vAZk+n4ZoFsXABe5+fKCg5R
         I1eKVf+vtd6/u320jy9F9JQNKpEwlzJqCkg4PHc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Casper Andersson <casper.casan@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/114] net: microchip: sparx5: fix PTP init/deinit not checking all ports
Date:   Mon, 13 Feb 2023 15:47:49 +0100
Message-Id: <20230213144743.914798814@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit d7d94b2612f5dc25d61dc7bf58aafe7b31f40191 ]

Check all ports instead of just port_count ports. PTP init was only
checking ports 0 to port_count. If the hardware ports are not mapped
starting from 0 then they would be missed, e.g. if only ports 20-30 were
mapped it would attempt to init ports 0-10, resulting in NULL pointers
when attempting to timestamp. Now it will init all mapped ports.

Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0ed1ea7727c54..69e76634f9aa8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -633,7 +633,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	/* Enable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
@@ -649,7 +649,7 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
-- 
2.39.0



