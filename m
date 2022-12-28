Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EEB657DF9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiL1Psy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiL1Pso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56F617E39
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80112B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9450C433D2;
        Wed, 28 Dec 2022 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242520;
        bh=EyQ++/BKTEpOyoxOhcI6CKqke6ZcQmhSGSi5ClADbY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeFUNwB2HuJeT8P34w37EVI2UGduZPncosX/htL77sZ1sp5fm10cIdu5qT6tZteHx
         R7y3/YhE52gc2xBXGvKqvO29w5CHCF241db/qCDLfDrikUL2dR9DwTuTbI7W44edR2
         4ZFDjI5+ip21sn+D3Glcg/9OjBf6QOjKcw4XhKVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0379/1146] clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
Date:   Wed, 28 Dec 2022 15:31:58 +0100
Message-Id: <20221228144340.460430848@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 739a6a6bbdb793bd57938cb24aa5a6df89983546 ]

If clk_register() fails, @pll->rate_table may have allocated memory by
kmemdup(), so it needs to be freed, otherwise will cause memory leak
issue, this patch fixes it.

Fixes: 90c590254051 ("clk: rockchip: add clock type for pll clocks and pll used on rk3066")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123091201.199819-1-xiujianfeng@huawei.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/rockchip/clk-pll.c b/drivers/clk/rockchip/clk-pll.c
index f7827b3b7fc1..6e5e502be44a 100644
--- a/drivers/clk/rockchip/clk-pll.c
+++ b/drivers/clk/rockchip/clk-pll.c
@@ -981,6 +981,7 @@ struct clk *rockchip_clk_register_pll(struct rockchip_clk_provider *ctx,
 	return mux_clk;
 
 err_pll:
+	kfree(pll->rate_table);
 	clk_unregister(mux_clk);
 	mux_clk = pll_clk;
 err_mux:
-- 
2.35.1



