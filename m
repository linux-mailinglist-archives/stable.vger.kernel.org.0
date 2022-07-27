Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5279583073
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbiG0RiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242620AbiG0Rh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6B97A51C;
        Wed, 27 Jul 2022 09:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68A9F61704;
        Wed, 27 Jul 2022 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C22C433C1;
        Wed, 27 Jul 2022 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940611;
        bh=uSjfjjmA0mMqQuqXklqFXawGwEGcYoWVmhQFzp2fvNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSJLOwF7QSF00hUkoTsTpbKIqjzz54r/YrrFodowVmx7Uuf9wmWrqA3CBG2KLI+we
         9Owa6voqYXb7/l75FqWKw7Y5xoJe02UkeKxHvWAWMNSI1sgrGbqlzpl4m/fzUrFgwd
         OwlQhphYDh61YX8drM3ucpc0gHzQE6J+cHyPhbXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 085/158] net: lan966x: Fix usage of lan966x->mac_lock when entry is added
Date:   Wed, 27 Jul 2022 18:12:29 +0200
Message-Id: <20220727161024.897285986@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 43243bb3195b0dc27741679471e23baed1efe98e ]

To add an entry to the MAC table, it is required first to setup the
entry and then issue a command for the MAC to learn the entry.
So if it happens for two threads to add simultaneously an entry in MAC
table then it would be a race condition.
Fix this by using lan966x->mac_lock to protect the HW access.

Fixes: fc0c3fe7486f2 ("net: lan966x: Add function lan966x_mac_ip_learn()")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 2d2b83c03796..4f8fd5cde950 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -75,6 +75,9 @@ static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
 			       unsigned int vid,
 			       enum macaccess_entry_type type)
 {
+	int ret;
+
+	spin_lock(&lan966x->mac_lock);
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a write command */
@@ -86,7 +89,10 @@ static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
 	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
 	       lan966x, ANA_MACACCESS);
 
-	return lan966x_mac_wait_for_completion(lan966x);
+	ret = lan966x_mac_wait_for_completion(lan966x);
+	spin_unlock(&lan966x->mac_lock);
+
+	return ret;
 }
 
 /* The mask of the front ports is encoded inside the mac parameter via a call
-- 
2.35.1



