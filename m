Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91106580C1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiL1QUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiL1QTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:19:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6E21A070
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCA06156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F9BC433D2;
        Wed, 28 Dec 2022 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244260;
        bh=gLUTuFKKWZm43g++dpYY47CMW+GKYZXliwTsGVKxbIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSLNX1NcbeUZyN0BeevynW1gu8iaI3D1Dv4929OrTOCRQRQQnjlXRxv5y3XbOHE4K
         hhvtwZjN0VuQpY55rakNmbAVh8/RvKmv1f8Kd0gB712H3a4KkBJNpTa+PnO7lT3VvL
         oJ1iN1lzNBzOlIjok83IuDsCvgq5zU7SjShX2Kc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0677/1073] usb: typec: tipd: Fix spurious fwnode_handle_put in error path
Date:   Wed, 28 Dec 2022 15:37:45 +0100
Message-Id: <20221228144346.426860950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 782c70edc4852a5d39be12377a85501546236212 ]

The err_role_put error path always calls fwnode_handle_put to release
the fwnode. This path can be reached after probe itself has already
released that fwnode though. Fix that by moving fwnode_handle_put in the
happy path to the very end.

Fixes: 18a6c866bb19 ("usb: typec: tps6598x: Add USB role switching logic")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-2-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 28dd5c3b175b..a5fbbae52525 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -821,7 +821,6 @@ static int tps6598x_probe(struct i2c_client *client)
 		ret = PTR_ERR(tps->port);
 		goto err_role_put;
 	}
-	fwnode_handle_put(fwnode);
 
 	if (status & TPS_STATUS_PLUG_PRESENT) {
 		ret = tps6598x_read16(tps, TPS_REG_POWER_STATUS, &tps->pwr_status);
@@ -845,6 +844,7 @@ static int tps6598x_probe(struct i2c_client *client)
 	}
 
 	i2c_set_clientdata(client, tps);
+	fwnode_handle_put(fwnode);
 
 	return 0;
 
-- 
2.35.1



