Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3A6D4993
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjDCOjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbjDCOjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E1116F2D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80F0561EA4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9463FC433EF;
        Mon,  3 Apr 2023 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532750;
        bh=ybnf0WuouWU08KTr71yU7vBE+kVfFz4SW7MEMzkHpuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpqGtfRtAEyRpcp3KJOoNflu1UrijSzWlkYEYAwyRMb+V+dWdwT+JrgYumug0yVBN
         5vDEBQyV8H6d5DCemzUcIZ4dEgln7qZgIl5ZVS02raLO/twUCoNLIxSu7Vb5PvCi9q
         hJFM0Gn2znS4i7bTRDvq936Iz30lbYGH2tSXyZ0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/181] net: dsa: realtek: fix out-of-bounds access
Date:   Mon,  3 Apr 2023 16:08:40 +0200
Message-Id: <20230403140417.891359754@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit b93eb564869321d0dffaf23fcc5c88112ed62466 ]

The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
with the expectation that priv has enough trailing space.

However, only realtek-smi actually allocated this chip_data space.
Do likewise in realtek-mdio to fix out-of-bounds accesses.

These accesses likely went unnoticed so far, because of an (unused)
buf[4096] member in struct realtek_priv, which caused kmalloc to
round up the allocated buffer to a big enough size, so nothing of
value was overwritten. With a different allocator (like in the barebox
bootloader port of the driver) or with KASAN, the memory corruption
becomes quickly apparent.

Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20230323103735.2331786-1-a.fatoum@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 3e54fac5f9027..5a8fe707ca25e 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/overflow.h>
 #include <linux/regmap.h>
 
 #include "realtek.h"
@@ -152,7 +153,9 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	if (!var)
 		return -EINVAL;
 
-	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&mdiodev->dev,
+			    size_add(sizeof(*priv), var->chip_data_sz),
+			    GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.39.2



