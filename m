Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44859D3FE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbiHWIJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241459AbiHWIIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B8B1208F;
        Tue, 23 Aug 2022 01:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FF1C6123F;
        Tue, 23 Aug 2022 08:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD24C433D6;
        Tue, 23 Aug 2022 08:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241911;
        bh=Q0I/PmJguM5EbQjnODE386mN8aRsJ1nboBw3Kf2fsGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSTu9u8NZDscSVAhG5vUQ2i77J8zrm+xJCg77QjiE6zpzI0+dJnxeALAfjXRS/WmB
         Gfjs1NnHKMWdoN76RT++ma5imxD/e6SGNxgyNvK/H3Ah/fjsXjjSb6lp1HtlE1OpxN
         2EyycM1hoNG8277XFijA2lrGfSjh4k34fct+9p4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.19 017/365] mmc: meson-gx: Fix an error handling path in meson_mmc_probe()
Date:   Tue, 23 Aug 2022 09:58:38 +0200
Message-Id: <20220823080118.902709249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -1172,8 +1172,10 @@ static int meson_mmc_probe(struct platfo
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


