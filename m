Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5A6AE9F0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCGR3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjCGR2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEF3746D3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDF24614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4175C433D2;
        Tue,  7 Mar 2023 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209837;
        bh=rkIUUQKZZ0ZJ6XWIzFg0s+PHN8hbgDdjJhcK2IiGOxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6kR7i1HyX8Yg0d86PcAT4bJVhrh+LECrZKxhRPzPqB4FBm2EEalS/0E0fasRLHsU
         U41jrsg0ZHhUl3slhZazsZmOBC71oUIVX3OSmWtIy469S42Jqv/pX5dEp4/5zS/s8K
         0S+T+wij20EKCRdu3bddZv6uDCce9jD/jMvqWxUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0347/1001] pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
Date:   Tue,  7 Mar 2023 17:51:59 +0100
Message-Id: <20230307170036.507843569@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c818ae563bf99457f02e8170aabd6b174f629f65 ]

of_find_node_by_phandle() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: d3e5116119bd ("pinctrl: add pinctrl driver for Rockchip SoCs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230102112845.3982407-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 5eeac92f610a0..0276b52f37168 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3045,6 +3045,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
-- 
2.39.2



