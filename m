Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DE55F2B0A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiJCHqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJCHo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3524F476D5;
        Mon,  3 Oct 2022 00:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DABAB80E77;
        Mon,  3 Oct 2022 07:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D669C433D7;
        Mon,  3 Oct 2022 07:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781359;
        bh=GLpatjvPIRyVVgNUsRmGJsg+QQg8gXy0pZ8E44NzLlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7e+ydVA2ovtLBR9Ff494b8WLYPiXJitq7+tZT4TPcFszgs9VXymKoo76ZOUPemzT
         q/+Qq/mTmkVwNrbN4XGQ8CXq5furGmQkqp6bKIjbgyfnWscC6vtjGiGD48JikP3OND
         s4PcbdIh9FclzwS4uEbQgVeZh/M43Xu+OD6dB2IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Peng Fan <peng.fan@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 093/101] clk: imx93: drop of_match_ptr
Date:   Mon,  3 Oct 2022 09:11:29 +0200
Message-Id: <20221003070726.751403109@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit daaa2fbe678efdaced53d1c635f4d326751addf8 ]

There is build warning when CONFIG_OF is not selected.
>> drivers/clk/imx/clk-imx93.c:324:34: warning: 'imx93_clk_of_match'
>> defined but not used [-Wunused-const-variable=]
     324 | static const struct of_device_id imx93_clk_of_match[] = {
         |                                  ^~~~~~~~~~~~~~~~~~

The driver only support DT table, no sense to use of_match_ptr.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20220830033137.4149542-3-peng.fan@oss.nxp.com
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index f5c9fa40491c..dcc41d178238 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -332,7 +332,7 @@ static struct platform_driver imx93_clk_driver = {
 	.driver = {
 		.name = "imx93-ccm",
 		.suppress_bind_attrs = true,
-		.of_match_table = of_match_ptr(imx93_clk_of_match),
+		.of_match_table = imx93_clk_of_match,
 	},
 };
 module_platform_driver(imx93_clk_driver);
-- 
2.35.1



