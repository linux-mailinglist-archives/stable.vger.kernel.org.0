Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC159DFF1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359249AbiHWMLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359472AbiHWMIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0CEAB;
        Tue, 23 Aug 2022 02:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 915A961389;
        Tue, 23 Aug 2022 09:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC5DC433C1;
        Tue, 23 Aug 2022 09:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247448;
        bh=IofdAwIDyvUXY6X9Xr4M4jwUuXAIwWHoIICBfaLTqs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPuxVBNFdP0nAUa+Vk6h4CFDXtZn4koTD7bLxcvgNklniLrcW60uNuSG/rhDycRlJ
         m46EeG1QQdGzAHvJPzpiKhCqm5mW9oAjupFKiLV64c7TXm3jCSbtaJFJWtJGXfhcyX
         b6sXKG6bUSGRwD53srroh1OC6Xtsn2X52X54Im0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 008/158] mmc: meson-gx: Fix an error handling path in meson_mmc_probe()
Date:   Tue, 23 Aug 2022 10:25:40 +0200
Message-Id: <20220823080046.400346292@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit b3e1cf31154136da855f3cb6117c17eb0b6bcfb4 upstream.

The commit in Fixes has introduced a new error handling which should goto
the existing error handling path.
Otherwise some resources leak.

Fixes: 19c6beaa064c ("mmc: meson-gx: add device reset")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/be4b863bacf323521ba3a02efdc4fca9cdedd1a6.1659855351.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1161,8 +1161,10 @@ static int meson_mmc_probe(struct platfo
 	}
 
 	ret = device_reset_optional(&pdev->dev);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "device reset failed\n");
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "device reset failed\n");
+		goto free_host;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->regs = devm_ioremap_resource(&pdev->dev, res);


