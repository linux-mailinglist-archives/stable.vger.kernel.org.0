Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AC551A823
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355597AbiEDRIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353151AbiEDRFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E75850E16;
        Wed,  4 May 2022 09:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A69AB827AD;
        Wed,  4 May 2022 16:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26102C385A5;
        Wed,  4 May 2022 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683251;
        bh=vzEX6Tq9n68EdutGIw5T+UJNk47l/3TGbuch2cwKSbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y71IOSKfQjSk+KpJQJBtc9NT637Hka7ODM+v+Z88h43YF/xwbBkwUNpQLVNByefE8
         ZlO+OIRdmy5QlEju4W4DbkVLrbzhiRR4RPwElxa85F3cj8NQFGHVxXvOIprxBD06zp
         InwOoOEcbZekOy+8KZXBrjVXyfFXEKNqC3SkcCig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/177] clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()
Date:   Wed,  4 May 2022 18:44:57 +0200
Message-Id: <20220504153102.499192036@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f58ca215cda1975f77b2b762903684a3c101bec9 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Fixes: 7a6fca879f59 ("clk: sunxi: Add driver for A80 MMC config clocks/resets")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220421134308.2885094-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi/clk-sun9i-mmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/sunxi/clk-sun9i-mmc.c b/drivers/clk/sunxi/clk-sun9i-mmc.c
index 542b31d6e96d..636bcf2439ef 100644
--- a/drivers/clk/sunxi/clk-sun9i-mmc.c
+++ b/drivers/clk/sunxi/clk-sun9i-mmc.c
@@ -109,6 +109,8 @@ static int sun9i_a80_mmc_config_clk_probe(struct platform_device *pdev)
 	spin_lock_init(&data->lock);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
 	/* one clock/reset pair per word */
 	count = DIV_ROUND_UP((resource_size(r)), SUN9I_MMC_WIDTH);
 	data->membase = devm_ioremap_resource(&pdev->dev, r);
-- 
2.35.1



