Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171A260ACDA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiJXOQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiJXOOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:14:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83140C97CF;
        Mon, 24 Oct 2022 05:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1047E6121A;
        Mon, 24 Oct 2022 12:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2580DC433D7;
        Mon, 24 Oct 2022 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615465;
        bh=5T+uoGLoWBIVPX3mlIPuMZ7rB+zzNdQkaKpCPmZcVBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcHVWpnOdTk6/fbl/naCYdUlZvx3GBPRX46fJuidV2wZgfpeVo3XN7ZSRmp2WdB/m
         +bf+sVJdtDR8yQcF/5MkYqKr7d8dv3DMf+UGF3HatWifaMnDCnWgoJiB8zI9R64Osv
         HXLE/jzcSg6vgAaiRSqO6z4/iyjWHcL/CdtFfbbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/530] mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
Date:   Mon, 24 Oct 2022 13:29:36 +0200
Message-Id: <20221024113055.584371745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index 0acc237843f7..f5f9cb7a2da5 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1095,8 +1095,9 @@ static int au1xmmc_probe(struct platform_device *pdev)
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



