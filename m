Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E331A658203
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiL1Qct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiL1QcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EE317E0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E15B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B55AC433D2;
        Wed, 28 Dec 2022 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244943;
        bh=BsgjUyPNlvw04NRjzhWVLzO5vKF9Sllk5HnoOPXUJe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdrFItsf09KHjXPyuJgziAnA09XAouCpzMHvu4IpUPevE7JeqjYaxGLKxMZDTgPFi
         2XcJz3Qh+U5Bu8e9ZYUMBuQXF8r9uja6PL1AQV/hzJxfTVEBrql0vIeaSVTLrZMH8d
         TzysdaXeLclAuJlyOVmWO/6s/E+wNxkul4Yj0ymY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0766/1146] HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
Date:   Wed, 28 Dec 2022 15:38:25 +0100
Message-Id: <20221228144350.956585343@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f5181c35ed7ba0ceb6e42872aad1334d994b0175 ]

In error label 'out1' path in ssi_probe(), the pm_runtime_enable()
has not been called yet, so pm_runtime_disable() is not needed.

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index eb9820158318..b23a576ed88a 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -536,9 +536,9 @@ static int ssi_probe(struct platform_device *pd)
 	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
 out2:
 	ssi_remove_controller(ssi);
+	pm_runtime_disable(&pd->dev);
 out1:
 	platform_set_drvdata(pd, NULL);
-	pm_runtime_disable(&pd->dev);
 
 	return err;
 }
-- 
2.35.1



