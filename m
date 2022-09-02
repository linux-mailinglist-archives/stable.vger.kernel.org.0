Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71455AB086
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiIBMyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbiIBMxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD5F8FF5;
        Fri,  2 Sep 2022 05:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8CA6621BE;
        Fri,  2 Sep 2022 12:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD90FC433C1;
        Fri,  2 Sep 2022 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122210;
        bh=wbSiZ0CLZonH7ncXPFcG0OikktRRtS3l6RAKoUdrON8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHvTZir5VaxRhkWzdIvZI+KuB3UX5IdO8GCZpY1ILfvs/YIExyPOSpQD3oymBOUkv
         XXzkOAYJbMlDe2r7uuvKGPnhUauqxE9/vJ63bXlayFg7R9Z2sqeBj+uyLyuFMo+1qz
         aHGIsG9N9b/MxMzd6BVVo5sKXhaurOfWVPb8USXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Qiong <liqiong@nfschina.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 47/72] net: lan966x: fix checking for return value of platform_get_irq_byname()
Date:   Fri,  2 Sep 2022 14:19:23 +0200
Message-Id: <20220902121406.313441704@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit 40b4ac880e21d917da7f3752332fa57564a4c202 ]

The platform_get_irq_byname() returns non-zero IRQ number
or negative error number. "if (irq)" always true, chang it
to "if (irq > 0)"

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e6..d928b75f37803 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -710,7 +710,7 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 	disable_irq(lan966x->xtr_irq);
 	lan966x->xtr_irq = -ENXIO;
 
-	if (lan966x->ana_irq) {
+	if (lan966x->ana_irq > 0) {
 		disable_irq(lan966x->ana_irq);
 		lan966x->ana_irq = -ENXIO;
 	}
@@ -718,10 +718,10 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 	if (lan966x->fdma)
 		devm_free_irq(lan966x->dev, lan966x->fdma_irq, lan966x);
 
-	if (lan966x->ptp_irq)
+	if (lan966x->ptp_irq > 0)
 		devm_free_irq(lan966x->dev, lan966x->ptp_irq, lan966x);
 
-	if (lan966x->ptp_ext_irq)
+	if (lan966x->ptp_ext_irq > 0)
 		devm_free_irq(lan966x->dev, lan966x->ptp_ext_irq, lan966x);
 }
 
@@ -1049,7 +1049,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	}
 
 	lan966x->ana_irq = platform_get_irq_byname(pdev, "ana");
-	if (lan966x->ana_irq) {
+	if (lan966x->ana_irq > 0) {
 		err = devm_request_threaded_irq(&pdev->dev, lan966x->ana_irq, NULL,
 						lan966x_ana_irq_handler, IRQF_ONESHOT,
 						"ana irq", lan966x);
-- 
2.35.1



