Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA66580B1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiL1QTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiL1QSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CA61A069
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 044DB6156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ED1C433D2;
        Wed, 28 Dec 2022 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244255;
        bh=c0wHV7iAOCGJO9PrE0TOS4SpgYhrfvRKC0MP2K00bWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdy15XQVbuB1B7ihm7xi6Du2wymuzasZ2mGbsXrFEeAfwxo8wcEXF/5aWFWOy8cMF
         pnlwwloECe/9ZuO1zQkJge6gsK+sIRrFYzsnpVK6YW3pdwwTsRIHhkzxt7m+s6Y8Cd
         B4NHPh7fvivePSxzTUS503i/KubcRoFGpKx7kGhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Peter <sven@svenpeter.dev>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0676/1073] usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
Date:   Wed, 28 Dec 2022 15:37:44 +0100
Message-Id: <20221228144346.399782847@linuxfoundation.org>
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
index 92e35e62e78c..28dd5c3b175b 100644
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



