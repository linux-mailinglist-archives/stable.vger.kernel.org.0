Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8D766CAEE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbjAPRJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbjAPRIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:08:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAA52E0E3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C9CB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7792C433EF;
        Mon, 16 Jan 2023 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887731;
        bh=82MbbYdidBYo1hvF/Exm3EvzXWEpopgEaaldIMzi1Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auIXhxj2//g4TYnWXoDFOJ5zXzKJNPwRS6uye9k/NMFhlU8jY4rdP0pYG68Bm6I1G
         e4TOTtd8GyEk3pVhcV7PloYi9MEAAOlHINb1XLTLit7ECquK+wmc5M3+7rBol0OF68
         UfJGh3njbSfHmoQfaiLV1LRlXtmgN3nOGOilKrOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/521] HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
Date:   Mon, 16 Jan 2023 16:48:41 +0100
Message-Id: <20230116154858.707819424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 15ecc4bc8de6..b91a6b6c0d7a 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -572,9 +572,9 @@ static int ssi_probe(struct platform_device *pd)
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



