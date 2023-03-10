Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954666B429A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjCJOE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCJOEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045A15177
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EEF461771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62E4C433EF;
        Fri, 10 Mar 2023 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457072;
        bh=G5Tt5UtAX9wH11AZdDhFBNI+5/gV5rrhZrVOdn0oV9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAmnZnDdlt9ibODDYTKBe5RQZ7pc47GjxVM68/zbXKzHdf0ItIjxCUeEYYdQhjtUU
         X5Ed0nz55i1IHaKLYVj+lUdTFKePSFkZOrHahWT1ZKfxxrI6uidIrtgMiDRjD9Zeff
         Iz0CydmGag159xiToNTlWhq7sBEG9UMWxZHcCVdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/200] soc: mediatek: mtk-svs: Enable the IRQ later
Date:   Fri, 10 Mar 2023 14:36:58 +0100
Message-Id: <20230310133717.396616425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit b74952aba6c3f47e7f2c5165abaeefa44c377140 ]

If the system does not come from reset (like when is booted via
kexec()), the peripheral might triger an IRQ before the data structures
are initialised.

Fixes:

[    0.227710] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000f08
[    0.227913] Call trace:
[    0.227918]  svs_isr+0x8c/0x538

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20221127-mtk-svs-v2-0-145b07663ea8@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 0469c9dfeb04e..75b2f534aa9d0 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2385,14 +2385,6 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_free_resource;
 	}
 
-	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
-					IRQF_ONESHOT, svsp->name, svsp);
-	if (ret) {
-		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
-			svsp_irq, ret);
-		goto svs_probe_free_resource;
-	}
-
 	svsp->main_clk = devm_clk_get(svsp->dev, "main");
 	if (IS_ERR(svsp->main_clk)) {
 		dev_err(svsp->dev, "failed to get clock: %ld\n",
@@ -2414,6 +2406,14 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_clk_disable;
 	}
 
+	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
+					IRQF_ONESHOT, svsp->name, svsp);
+	if (ret) {
+		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
+			svsp_irq, ret);
+		goto svs_probe_iounmap;
+	}
+
 	ret = svs_start(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs start fail: %d\n", ret);
-- 
2.39.2



