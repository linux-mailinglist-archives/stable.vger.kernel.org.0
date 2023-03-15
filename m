Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4B6BB258
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjCOMfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbjCOMfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B2746D5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1037561D26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B2C433D2;
        Wed, 15 Mar 2023 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883627;
        bh=MGjV63gqIyWrUmynAnkUNc4Qe3ruXoWMQEHnYSSezO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2a7JP+KWT4iLiSBtFTo1DBzHRJIilmLC3PFcq4Ph7S+A/gLKNUwfYwTvQbcftHRf
         1HcyeZhRfDqwt9Q7R912QfN5qKyLqU/7ftVS19yf46zxptrZGme9KVEbnsNvxpaOED
         5exoB+MXK/y3RHb24nfijfpAo4xUKqBRVKlioj0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/143] net: lan966x: Fix port police support using tc-matchall
Date:   Wed, 15 Mar 2023 13:12:36 +0100
Message-Id: <20230315115742.670338008@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 81563d8548b0478075c720666be348d4199b8591 ]

When the police was removed from the port, then it was trying to
remove the police from the police id and not from the actual
police index.
The police id represents the id of the police and police index
represents the position in HW where the police is situated.
The port police id can be any number while the port police index
is a number based on the port chip port.
Fix this by deleting the police from HW that is situated at the
police index and not police id.

Fixes: 5390334b59a3 ("net: lan966x: Add port police support using tc-matchall")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_police.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
index a9aec900d608d..7d66fe75cd3bf 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
@@ -194,7 +194,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
 		return -EINVAL;
 	}
 
-	err = lan966x_police_del(port, port->tc.police_id);
+	err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to add policer to port");
-- 
2.39.2



