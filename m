Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445C6528FB7
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351325AbiEPUDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347246AbiEPT5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:57:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C24832E;
        Mon, 16 May 2022 12:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BF160BB5;
        Mon, 16 May 2022 19:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40900C34115;
        Mon, 16 May 2022 19:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730569;
        bh=ynx/7QHVVjHV4bOAXzGkWyMuH2sZpWlvcEwXWOxepes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufKsylYrUC2JtowH35sc9DR6gmBfdUU/ldCRqn2r98ZYHouRGyzu7sD0XxMRG3nMU
         bpIHSf2+Evug9+ROwgK4Rt2ZR7mEaooRE6zOWHqVDyI1T0Qm2xY6/Vqv6Nl7fBKWdZ
         hoWNGGE9JKwORmx24CqLMzKDYYgQxn6Si+6l8ePI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/102] net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()
Date:   Mon, 16 May 2022 21:36:13 +0200
Message-Id: <20220516193625.122578225@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b7be130c5d52e5224ac7d89568737b37b4c4b785 ]

After commit 2d1f90f9ba83 ("net: dsa/bcm_sf2: fix incorrect usage of
state->link") the interface suspend path would call our mac_link_down()
call back which would forcibly set the link down, thus preventing
Wake-on-LAN packets from reaching our management port.

Fix this by looking at whether the port is enabled for Wake-on-LAN and
not clearing the link status in that case to let packets go through.

Fixes: 2d1f90f9ba83 ("net: dsa/bcm_sf2: fix incorrect usage of state->link")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220512021731.2494261-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 2e314e3021d8..b3a43a3d90e4 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -796,6 +796,9 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 reg, offset;
 
+	if (priv->wol_ports_mask & BIT(port))
+		return;
+
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
-- 
2.35.1



