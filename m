Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAFB657EC3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiL1P5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiL1P5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD817E22
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:57:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89962B81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044FCC433F0;
        Wed, 28 Dec 2022 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243031;
        bh=8/sVOYx2bnqClV5wMIKys2+H3FCefamDGqS5rgWovWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNv1CwrxJ/Xot+zmXczFA5STUyBo9wQxDsgDfrtRETZkjJPxnjy9NlL3G0OOF9Kl0
         5ZPaEqcEWsyQZxDC3nbm11hKVh+Ef0pRQD/KMeNsl+V7jDcBkuX5ueV8n0CyxQoGTD
         eNLgT6rTKVA0+Q44yLV5jnLHWTVkjNvqH71x3YVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0442/1146] clk: visconti: Fix memory leak in visconti_register_pll()
Date:   Wed, 28 Dec 2022 15:33:01 +0100
Message-Id: <20221228144342.186273047@linuxfoundation.org>
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

[ Upstream commit b55226f8553d255f5002c751c7c6ba9291f34bf2 ]

@pll->rate_table has allocated memory by kmemdup(), if clk_hw_register()
fails, it should be freed, otherwise it will cause memory leak issue,
this patch fixes it.

Fixes: b4cbe606dc36 ("clk: visconti: Add support common clock driver and reset driver")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221122152353.204132-1-xiujianfeng@huawei.com
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index a484cb945d67..1f3234f22667 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -277,6 +277,7 @@ static struct clk_hw *visconti_register_pll(struct visconti_pll_provider *ctx,
 	ret = clk_hw_register(NULL, &pll->hw);
 	if (ret) {
 		pr_err("failed to register pll clock %s : %d\n", name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		pll_hw_clk = ERR_PTR(ret);
 	}
-- 
2.35.1



