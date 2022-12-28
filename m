Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080BD658158
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiL1Q1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiL1Q1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:27:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024A51A813
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A9C6157F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5450C433D2;
        Wed, 28 Dec 2022 16:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244601;
        bh=7rVoRjTFX0hQJ158Wkr7FJhoA8XfOb/Y56W1k8hZyQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lV7Wc2/IV7lugjlp0jEpYt8UFF5vFQHfd4ok5AhryNSYk69QS8bVSgopcWCILIDcM
         2R9fCcy77u9TM68AVq4u4oGFXD9Ay6kOU1iOb5UBJZ0+y0zaOFsnlLDofqw3BxFxyi
         8cj47opHo74snqD/ZHh18OXzbV/Itm8KNDC4BnN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0701/1146] usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
Date:   Wed, 28 Dec 2022 15:37:20 +0100
Message-Id: <20221228144349.185834107@linuxfoundation.org>
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

[ Upstream commit 19c220e9ab00f50edefb9667e3101e84a5112df2 ]

We can't just return if devm_tps6598_psy_register fails since previous
resources are not devres managed and have yet to be cleaned up.

Fixes: 10eb0b6ac63a ("usb: typec: tps6598x: Export some power supply properties")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 2a77bab948f5..83a7a82e55f1 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -814,7 +814,7 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	ret = devm_tps6598_psy_register(tps);
 	if (ret)
-		return ret;
+		goto err_role_put;
 
 	tps->port = typec_register_port(&client->dev, &typec_cap);
 	if (IS_ERR(tps->port)) {
-- 
2.35.1



