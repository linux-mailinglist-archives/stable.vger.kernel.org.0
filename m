Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A7F657BE2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiL1P0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiL1P01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FA4C34
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F52C6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9CFC433D2;
        Wed, 28 Dec 2022 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241185;
        bh=SQKDysGymzgVK+IS8HVsZSd60O6qAgSzzMMTcmRj2lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QR+eA3R5sP2uv8eN4f7RzMbf4ulsZfa1iSc6S15sxvhKy3JZluu4/EC1sGl1+bUlb
         JctQ0PPUw7RhxXACT8BCVVHrs65lm3+WmrGnJs+MBPDr1roKsuqJtfQI333oyT1pdV
         jXGx8t1dmCwk8yP0TWqjslvkxsFLdd91PulcjRhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/731] usb: typec: tipd: Fix spurious fwnode_handle_put in error path
Date:   Wed, 28 Dec 2022 15:39:17 +0100
Message-Id: <20221228144309.599013032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index dd35b3ee2c5a..2f32c3fceef8 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -691,7 +691,6 @@ static int tps6598x_probe(struct i2c_client *client)
 		ret = PTR_ERR(tps->port);
 		goto err_role_put;
 	}
-	fwnode_handle_put(fwnode);
 
 	if (status & TPS_STATUS_PLUG_PRESENT) {
 		ret = tps6598x_connect(tps, status);
@@ -710,6 +709,7 @@ static int tps6598x_probe(struct i2c_client *client)
 	}
 
 	i2c_set_clientdata(client, tps);
+	fwnode_handle_put(fwnode);
 
 	return 0;
 
-- 
2.35.1



