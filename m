Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852D9681120
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbjA3OK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbjA3OKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:10:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397463BD86
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C409C61025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB579C433D2;
        Mon, 30 Jan 2023 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087801;
        bh=YqCydz/9pWiIw9CKLXG/IUCHTJZt75WJshE6HVEV/k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijp9GvgyhC8p+W3xF8kDw7gGZ4WBbLv0rLg0yF78w2AqSjtf4b8wPdNBGEQ6GdxGk
         Uz3olHuPP4oZdQtU+DjzAom1TwypT1lpI4QKU2Ip35cl/EmrvTAQKD6+fY1It8Xynf
         ZnYDVKdbMy8ZQYpU0exNjRoU23HhJqXx2UNuhGsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/204] reset: uniphier-glue: Fix possible null-ptr-deref
Date:   Mon, 30 Jan 2023 14:49:40 +0100
Message-Id: <20230130134316.965196567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 3a2390c6777e3f6662980c6cfc25cafe9e4fef98 ]

It will cause null-ptr-deref when resource_size(res) invoked,
if platform_get_resource() returns NULL.

Fixes: 499fef09a323 ("reset: uniphier: add USB3 core reset control")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20221114004958.258513-1-tanghui20@huawei.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-uniphier-glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/reset/reset-uniphier-glue.c b/drivers/reset/reset-uniphier-glue.c
index 6d422c69532c..7493e9618837 100644
--- a/drivers/reset/reset-uniphier-glue.c
+++ b/drivers/reset/reset-uniphier-glue.c
@@ -33,7 +33,6 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct uniphier_glue_reset_priv *priv;
 	struct resource *res;
-	resource_size_t size;
 	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -46,7 +45,6 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	size = resource_size(res);
 	priv->rdata.membase = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->rdata.membase))
 		return PTR_ERR(priv->rdata.membase);
@@ -74,7 +72,7 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 
 	spin_lock_init(&priv->rdata.lock);
 	priv->rdata.rcdev.owner = THIS_MODULE;
-	priv->rdata.rcdev.nr_resets = size * BITS_PER_BYTE;
+	priv->rdata.rcdev.nr_resets = resource_size(res) * BITS_PER_BYTE;
 	priv->rdata.rcdev.ops = &reset_simple_ops;
 	priv->rdata.rcdev.of_node = dev->of_node;
 	priv->rdata.active_low = true;
-- 
2.39.0



