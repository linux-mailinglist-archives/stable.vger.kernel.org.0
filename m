Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BDE65815D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiL1Q15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiL1Q1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9048C1A834
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B54E61595
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3773DC43392;
        Wed, 28 Dec 2022 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244614;
        bh=Fzen1X2nxP3bIyKqMjdY6S9lKbA1bv5WP00OtNn+BYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eV+ZmdWeG1LRcgu8Sf9fHFmuh7kATjGGM0kryYfoELaZ2RhnT3mVxrVcUfuiFCMBd
         zmXxb1vouLI2esmGKppl3XVhahbpY9OkqOinSissi8QnHVSdZBNjseLsv6/k+4maAW
         KNugqx+XzzqJzS8RjO7uEYPZ2LY1y4BX/qXlkZas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0703/1146] usb: typec: tipd: Fix typec_unregister_port error paths
Date:   Wed, 28 Dec 2022 15:37:22 +0100
Message-Id: <20221228144349.240705853@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 4c8f27ba9ede0118cac9d775204f9b0ecdb877b0 ]

typec_unregister_port is only called for some error paths after
typec_register_port was successful. Ensure it's called in all
cases.

Fixes: 92440202a880 ("usb: typec: tipd: Only update power status on IRQ")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-3-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 59059310ba74..195c9c16f817 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -826,7 +826,7 @@ static int tps6598x_probe(struct i2c_client *client)
 		ret = tps6598x_read16(tps, TPS_REG_POWER_STATUS, &tps->pwr_status);
 		if (ret < 0) {
 			dev_err(tps->dev, "failed to read power status: %d\n", ret);
-			goto err_role_put;
+			goto err_unregister_port;
 		}
 		ret = tps6598x_connect(tps, status);
 		if (ret)
@@ -839,8 +839,7 @@ static int tps6598x_probe(struct i2c_client *client)
 					dev_name(&client->dev), tps);
 	if (ret) {
 		tps6598x_disconnect(tps, 0);
-		typec_unregister_port(tps->port);
-		goto err_role_put;
+		goto err_unregister_port;
 	}
 
 	i2c_set_clientdata(client, tps);
@@ -848,6 +847,8 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	return 0;
 
+err_unregister_port:
+	typec_unregister_port(tps->port);
 err_role_put:
 	usb_role_switch_put(tps->role_sw);
 err_fwnode_put:
-- 
2.35.1



