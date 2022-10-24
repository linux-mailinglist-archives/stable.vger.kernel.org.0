Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8AB60A427
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiJXMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiJXMEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:04:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA66C54675;
        Mon, 24 Oct 2022 04:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFEF612BB;
        Mon, 24 Oct 2022 11:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC17C433D7;
        Mon, 24 Oct 2022 11:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612257;
        bh=0uWZkCQZvSSzBLwJUw8HecZ+r/KnHBzmlr7A/oiemN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf3G9eab/UXptXFoCPkHVpM/9IDKGQrv8I9iURnvW1nJEFzqaWMKNi6QbTYSs/Nhu
         aSD+189v9QIh2D8WNbq9gtEXaosm6VYlQFHaX2GxZIoK9WX8yvkIHL90LCIUNKzqNC
         qiO/FdwQvB+cLT6/qouqLvpLxWSZLOA4RX9cdACY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/210] mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
Date:   Mon, 24 Oct 2022 13:30:19 +0200
Message-Id: <20221024113000.327016644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5cbedf52608cc3cbc1c2a9a861fb671620427a20 ]

If clk_prepare_enable() fails, there is no point in calling
clk_disable_unprepare() in the error handling path.

Move the out_clk label at the right place.

Fixes: b6507596dfd6 ("MIPS: Alchemy: au1xmmc: use clk framework")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/21d99886d07fa7fcbec74992657dabad98c935c4.1661412818.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/au1xmmc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index ed77fbfa4774..a1667339e21d 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1114,8 +1114,9 @@ static int au1xmmc_probe(struct platform_device *pdev)
 	if (host->platdata && host->platdata->cd_setup &&
 	    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 		host->platdata->cd_setup(mmc, 0);
-out_clk:
+
 	clk_disable_unprepare(host->clk);
+out_clk:
 	clk_put(host->clk);
 out_irq:
 	free_irq(host->irq, host);
-- 
2.35.1



