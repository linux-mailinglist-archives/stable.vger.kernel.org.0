Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2856FDDA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiGKKBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiGKKAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:00:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58125B7D7D;
        Mon, 11 Jul 2022 02:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93FACCE1268;
        Mon, 11 Jul 2022 09:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010CC34115;
        Mon, 11 Jul 2022 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531687;
        bh=csgxy4ICyoSPVF+d/lXJiIiPKT9K0NdUJw6mNZnSrfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fm/63oiVykF8aNE/G7mhRnpAa0q641V1+ZednRSEq2Hd9eGakPFVCA70jimn07BmK
         lfp/udmRsryySUQLREfUTEzk0tNlvFQ5FZKQe3Kb6mKdnzOHdKX4SfrwnmRXlQfrJ9
         XCzfgmvYVTvxZd91cCvX86L4LWBd/g+YV3krhZ70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Lalaev <andrey.lalaev@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/230] pinctrl: sunxi: sunxi_pconf_set: use correct offset
Date:   Mon, 11 Jul 2022 11:07:31 +0200
Message-Id: <20220711090609.639568498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Andrei Lalaev <andrey.lalaev@gmail.com>

[ Upstream commit cd4c1e65a32afd003b08ad4aafe1e4d3e4e8e61b ]

Some Allwinner SoCs have 2 pinctrls (PIO and R_PIO).
Previous implementation used absolute pin numbering and it was incorrect
for R_PIO pinctrl.
It's necessary to take into account the base pin number.

Fixes: 90be64e27621 ("pinctrl: sunxi: implement pin_config_set")
Signed-off-by: Andrei Lalaev <andrey.lalaev@gmail.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220525190423.410609-1-andrey.lalaev@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index ce3f9ea41511..1431ab21aca6 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -544,6 +544,8 @@ static int sunxi_pconf_set(struct pinctrl_dev *pctldev, unsigned pin,
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	int i;
 
+	pin -= pctl->desc->pin_base;
+
 	for (i = 0; i < num_configs; i++) {
 		enum pin_config_param param;
 		unsigned long flags;
-- 
2.35.1



