Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14116ECD37
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjDXNVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjDXNVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C854EEB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EEE562218
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E40C433EF;
        Mon, 24 Apr 2023 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342470;
        bh=EidAUh3Dv1OxnMS244VOjuU+4gHPip+54nkFy8EPWcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7phQtv9Q2/Z6u0/vG0yVllr7v+i6QDbBA6dOun3qsMszDV5fFsLlLGgSRyb0U2tU
         HEDpLYdAV/OxngCEqp2i7iJ3gOSTePG07yKoM2BLUbX4mL89VHHeKpjfZSCphdf6PT
         oDSAjiy6+K+v9s+rptPAWeWvNXNDaRNtkDHy/PQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Lanzhe <u202212060@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/73] spi: spi-rockchip: Fix missing unwind goto in rockchip_sfc_probe()
Date:   Mon, 24 Apr 2023 15:16:36 +0200
Message-Id: <20230424131129.829637187@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Lanzhe <u202212060@hust.edu.cn>

[ Upstream commit 359f5b0d4e26b7a7bcc574d6148b31a17cefe47d ]

If devm_request_irq() fails, then we are directly return 'ret' without
clk_disable_unprepare(sfc->clk) and clk_disable_unprepare(sfc->hclk).

Fix this by changing direct return to a goto 'err_irq'.

Fixes: 0b89fc0a367e ("spi: rockchip-sfc: add rockchip serial flash controller")
Signed-off-by: Li Lanzhe <u202212060@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230419115030.6029-1-u202212060@hust.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index a46b385440273..014106f8f978c 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -634,7 +634,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "Failed to request irq\n");
 
-		return ret;
+		goto err_irq;
 	}
 
 	ret = rockchip_sfc_init(sfc);
-- 
2.39.2



