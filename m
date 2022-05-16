Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D736528FC1
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347956AbiEPUC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbiEPTu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46FC43ADE;
        Mon, 16 May 2022 12:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A62A2B81604;
        Mon, 16 May 2022 19:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F5DC385AA;
        Mon, 16 May 2022 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730318;
        bh=sBNFGDHK2fsl+hkbfNDprXdpmW3c6JSB43OoPzzX5yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLmWENYD8SAaEJEkB2qsVfyYT6dnlNV9tF4lj9tPK49bkf+yoR5t+TiGwAjh+mjR8
         CGt7BNmGUyYg29ZgrwuwUSc2McryxUneomagovKuHInX0YjhZzTqsY9/FdvALQPe07
         FZteOwVcZV/mFNIJ+KmB9n0B31HfpOyHlxEO/IrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/66] net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()
Date:   Mon, 16 May 2022 21:36:26 +0200
Message-Id: <20220516193620.173990378@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
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
index 08a675a5328d..b712b4f27efd 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -710,6 +710,9 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 reg, offset;
 
+	if (priv->wol_ports_mask & BIT(port))
+		return;
+
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
 		if (priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
-- 
2.35.1



