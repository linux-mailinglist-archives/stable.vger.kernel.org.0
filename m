Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC5E657908
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiL1O4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiL1O4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340EDDCD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C52B0614B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E6DC433EF;
        Wed, 28 Dec 2022 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239409;
        bh=MbAb0bNy8l/E5IppMg6LDyvbtgW8oiWqlw+mbO+kd0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4N1gmi8rueSGjbfFOhsczX/X393zuxtk8Ibi27/HcIDNrkAs5Kto6OUDRe5gbzRT
         BN54pY2fF1m08QfpOS97hYkMk5i1yk1rK55gz9GuJYPbuuYUA4vN1jM15IMyMogEcx
         PwXMw9rTtmak5F4fV8zM8eFg8T/nxdwX18jocwnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhangPeng <zhangpeng362@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/731] pinctrl: k210: call of_node_put()
Date:   Wed, 28 Dec 2022 15:35:27 +0100
Message-Id: <20221228144302.941264210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit a8acc11643082a706de86a19f1f824712d971984 ]

Since for_each_available_child_of_node() will increase the refcount of
node, we need to call of_node_put() manually when breaking out of the
iteration.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221122075853.2496680-1-zhangpeng362@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k210.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index ecab6bf63dc6..ad4db99094a7 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -862,8 +862,10 @@ static int k210_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	for_each_available_child_of_node(np_config, np) {
 		ret = k210_pinctrl_dt_subnode_to_map(pctldev, np, map,
 						     &reserved_maps, num_maps);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(np);
 			goto err;
+		}
 	}
 	return 0;
 
-- 
2.35.1



