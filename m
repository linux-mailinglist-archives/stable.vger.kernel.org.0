Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF26159BE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKBDRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiKBDRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:17:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFEB24BDA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B1A360B72
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1029C433C1;
        Wed,  2 Nov 2022 03:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359019;
        bh=L1/g0wUi8BoqUKPivCprXmieUwYWV9jkqxHWCe6DoOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyZXhkSd+bwlrp4h15dSewWoT9PzMlCtTRR96bOSh4BF1kvSY5qVwEN+hES52TDdE
         3uavsRwYE3PtSnhP2p4lqwzXYElaMm8HELijV40KtfUaGlCzv1/SJFLRXqCdwSKsCt
         kuvNm//SyaPGeSnbany67d6hI06pWQ9Jsf35y4yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dongliang Mu <dzm91@hust.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/91] can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path
Date:   Wed,  2 Nov 2022 03:33:45 +0100
Message-Id: <20221102022056.792731036@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit b1a09b63684cea56774786ca14c13b7041ffee63 ]

In mcp251x_can_probe(), if mcp251x_gpio_setup() fails, it forgets to
unregister the CAN device.

Fix this by unregistering can device in mcp251x_can_probe().

Fixes: 2d52dabbef60 ("can: mcp251x: add GPIO support")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/all/20221024090256.717236-1-dzm91@hust.edu.cn
[mkl: adjust label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5dde3c42d241..ffcb04aac972 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1419,11 +1419,14 @@ static int mcp251x_can_probe(struct spi_device *spi)
 
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
-		goto error_probe;
+		goto out_unregister_candev;
 
 	netdev_info(net, "MCP%x successfully initialized.\n", priv->model);
 	return 0;
 
+out_unregister_candev:
+	unregister_candev(net);
+
 error_probe:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
-- 
2.35.1



