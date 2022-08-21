Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A654B59B420
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiHUNxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiHUNxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6359AB4B
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0373060EB0
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECDC433C1;
        Sun, 21 Aug 2022 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089995;
        bh=UyIOqK1iHosnZXDrgny6kfZ2X6ZJ95E/YCT/bMV5rKo=;
        h=Subject:To:Cc:From:Date:From;
        b=vM4orTl1S2t5xvPNtN+vpQ7pEa9UEKF1GQ33wzewqlsfpMrqAo2gkVfHgj6+2gOCu
         X1yJMYM5E2Rk58jVtCAxM0NTM3RcgoZ6+R+HSSID57Aj0yQ1inBoN+aN4e6p1TMhHH
         FBx0eIF2S+39tRrZGEczu/gXqmnNzrUeMjGWMRV4=
Subject: FAILED: patch "[PATCH] mmc: meson-gx: Fix an error handling path in" failed to apply to 4.19-stable tree
To:     christophe.jaillet@wanadoo.fr, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:53:03 +0200
Message-ID: <166108998310690@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b3e1cf31154136da855f3cb6117c17eb0b6bcfb4 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 7 Aug 2022 08:56:38 +0200
Subject: [PATCH] mmc: meson-gx: Fix an error handling path in
 meson_mmc_probe()

The commit in Fixes has introduced a new error handling which should goto
the existing error handling path.
Otherwise some resources leak.

Fixes: 19c6beaa064c ("mmc: meson-gx: add device reset")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/be4b863bacf323521ba3a02efdc4fca9cdedd1a6.1659855351.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 2f08d442e557..fc462995cf94 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1172,8 +1172,10 @@ static int meson_mmc_probe(struct platform_device *pdev)
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

