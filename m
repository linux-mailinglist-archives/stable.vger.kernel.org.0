Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757694F2FA8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350480AbiDEJ6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344015AbiDEJQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F7E01A;
        Tue,  5 Apr 2022 02:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D0ED61003;
        Tue,  5 Apr 2022 09:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D151C385A1;
        Tue,  5 Apr 2022 09:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149409;
        bh=51sy4X4YTqI8Sb8nHAkRrY2YedwTbhlXXttqjSn2IrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgLK+PEm2lqCQJIZPtXjPu+m25/er706oiqalfm5UEeo0cmxNalxZospZ6laxYhHn
         GiOP0B/+QiBrXHId0LEpQR3hye8wdxK8YUxkEjwkCKTFy2a+Jfmeu5bWXWe80fcH2c
         t2Kn1rPmMTFsQHL3xQxNLQ4npgEyiyBMoNG0DGhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0703/1017] pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe
Date:   Tue,  5 Apr 2022 09:26:56 +0200
Message-Id: <20220405070415.138123076@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 89388f8730699c259f8090ec435fb43569efe4ac ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 1e747e59cc4d ("pinctrl: rockchip: base regmap supplied by a syscon")
Fixes: 14dee8677e19 ("pinctrl: rockchip: let pmu registers be supplied by a syscon")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220307120234.28657-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index dc52da94af0b..923ff21a44c0 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2702,6 +2702,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,grf", 0);
 	if (node) {
 		info->regmap_base = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_base))
 			return PTR_ERR(info->regmap_base);
 	} else {
@@ -2738,6 +2739,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
 	if (node) {
 		info->regmap_pmu = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_pmu))
 			return PTR_ERR(info->regmap_pmu);
 	}
-- 
2.34.1



