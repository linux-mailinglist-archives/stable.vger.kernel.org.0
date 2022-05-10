Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0B52177D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbiEJN1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242815AbiEJNYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286911DF679;
        Tue, 10 May 2022 06:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B84326123F;
        Tue, 10 May 2022 13:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0148C385C6;
        Tue, 10 May 2022 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188657;
        bh=MKudbu7vHv3XJ8MbvM3xZDs4i7yKHou2tCtg+kv73Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMQ3H341tl95AD4z+mLnElCD9PTDjFMV9JbXvKdhNn6YWutHO1z3ZakDcJLbCx0ZP
         PGCzHNfxwnVJ0kS6jwMcHiWR93hOg69pH8+C/CXr5otJWnAQ/25X8h+RcrLUvl0jEj
         nd8GlBlNZCMBav6wYe9bijjLhdc+5Hl5tznT4Nmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/78] clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()
Date:   Tue, 10 May 2022 15:07:24 +0200
Message-Id: <20220510130733.661922005@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index f69f9e8c6f38..7e9d1624032f 100644
--- a/drivers/clk/sunxi/clk-sun9i-mmc.c
+++ b/drivers/clk/sunxi/clk-sun9i-mmc.c
@@ -117,6 +117,8 @@ static int sun9i_a80_mmc_config_clk_probe(struct platform_device *pdev)
 	spin_lock_init(&data->lock);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EINVAL;
 	/* one clock/reset pair per word */
 	count = DIV_ROUND_UP((resource_size(r)), SUN9I_MMC_WIDTH);
 	data->membase = devm_ioremap_resource(&pdev->dev, r);
-- 
2.35.1



