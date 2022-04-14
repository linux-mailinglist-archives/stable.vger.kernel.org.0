Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369AA5015A5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbiDNNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbiDNN2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B12939E4;
        Thu, 14 Apr 2022 06:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D880DB82983;
        Thu, 14 Apr 2022 13:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E0C385AA;
        Thu, 14 Apr 2022 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942527;
        bh=EWN/7L55u75adv+qjP3MgLPwUeZ7+C3NKYz1XAHFdGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbSVDTUXoDpit8iXSZIVmUqlS8crhizIMIW9EqRC1cE2X6vcOoFsnzSU0VEdhDtGc
         GFyzR4/u0D70XzdYXyL0MbY6BCCCjrZxeC9FdkuuZQHYPlP+A/23bO4LKqPaGUgNVJ
         wAw/dHDncDQ+apCndEQQGnK1+P9aWhiTQiln9+GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/338] clk: loongson1: Terminate clk_div_table with sentinel element
Date:   Thu, 14 Apr 2022 15:11:12 +0200
Message-Id: <20220414110843.709613554@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 3eb00f89162e80083dfcaa842468b510462cfeaa ]

In order that the end of a clk_div_table can be detected, it must be
terminated with a sentinel element (.div = 0).

Fixes: b4626a7f4892 ("CLK: Add Loongson1C clock support")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Link: https://lore.kernel.org/r/20220218000922.134857-3-j.neuschaefer@gmx.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/loongson1/clk-loongson1c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/loongson1/clk-loongson1c.c b/drivers/clk/loongson1/clk-loongson1c.c
index 3466f7320b40..e3aa502761a3 100644
--- a/drivers/clk/loongson1/clk-loongson1c.c
+++ b/drivers/clk/loongson1/clk-loongson1c.c
@@ -40,6 +40,7 @@ static const struct clk_div_table ahb_div_table[] = {
 	[1] = { .val = 1, .div = 4 },
 	[2] = { .val = 2, .div = 3 },
 	[3] = { .val = 3, .div = 3 },
+	[4] = { /* sentinel */ }
 };
 
 void __init ls1x_clk_init(void)
-- 
2.34.1



