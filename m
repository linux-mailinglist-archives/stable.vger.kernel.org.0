Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B6B593A52
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiHOTfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiHOTdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E9424B;
        Mon, 15 Aug 2022 11:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91898B8105C;
        Mon, 15 Aug 2022 18:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC74C433D6;
        Mon, 15 Aug 2022 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589111;
        bh=9aFWhDb0sLjSYCbmI8Iu1nyBKM24DyHPC+Y0uMpBoEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlAllnD9/w6QbJYCgNaAvb9rj3nDdGwdFbhkWRuVMnualxhCXHzyosqBCDnGsLHKp
         eQBpjdfI82Cu1a+L8MeIGxV7JovSYe5+zewX8EqGw7i1+/w6ZFBqungz+xOqDqBute
         Kvdj+B6ReVIZa1mwe6UGuQUSVImH1GaKn4PrTUZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/779] mfd: max77620: Fix refcount leak in max77620_initialise_fps
Date:   Mon, 15 Aug 2022 20:04:20 +0200
Message-Id: <20220815180403.700238951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 1520669c8255bd637c6b248b2be910e2688d38dd ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 327156c59360 ("mfd: max77620: Add core driver for MAX77620/MAX20024")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220601043222.64441-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max77620.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/max77620.c b/drivers/mfd/max77620.c
index fec2096474ad..a6661e07035b 100644
--- a/drivers/mfd/max77620.c
+++ b/drivers/mfd/max77620.c
@@ -419,9 +419,11 @@ static int max77620_initialise_fps(struct max77620_chip *chip)
 		ret = max77620_config_fps(chip, fps_child);
 		if (ret < 0) {
 			of_node_put(fps_child);
+			of_node_put(fps_np);
 			return ret;
 		}
 	}
+	of_node_put(fps_np);
 
 	config = chip->enable_global_lpm ? MAX77620_ONOFFCNFG2_SLP_LPM_MSK : 0;
 	ret = regmap_update_bits(chip->rmap, MAX77620_REG_ONOFFCNFG2,
-- 
2.35.1



