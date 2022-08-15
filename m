Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BA5937D3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiHOS5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244715AbiHOSzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51175128;
        Mon, 15 Aug 2022 11:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 657A460F9F;
        Mon, 15 Aug 2022 18:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AFFC433C1;
        Mon, 15 Aug 2022 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588213;
        bh=2VervNbxgxeZXfNV44+wbwlA2Se2WoQVV5BHYKxRI50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw3SgLBYYD/cI2VllJBa4bXww5D7cClzDgxyQ4+3dt4Y1lDgO/moo7A4nFtAnNTc8
         tPBFvFv5xixsD5IKqkc4fprF8uOqr+VAd/oI25BjB0C8qO4wGRYz76Ix5ugpwe27uO
         4FPTWTEevvo+8cjsapUnA/qHDBvFmqIvj1cV8k8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/779] drm/mcde: Fix refcount leak in mcde_dsi_bind
Date:   Mon, 15 Aug 2022 19:58:53 +0200
Message-Id: <20220815180349.642523280@linuxfoundation.org>
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

[ Upstream commit 3a149169e4a2f9127022fec6ef5d71b4e804b3b9 ]

Every iteration of for_each_available_child_of_node() decrements
the reference counter of the previous node. There is no decrement
when break out from the loop and results in refcount leak.
Add missing of_node_put() to fix this.

Fixes: 5fc537bfd000 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525115411.65455-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mcde/mcde_dsi.c b/drivers/gpu/drm/mcde/mcde_dsi.c
index 180ebbccbeda..0b58d7f4ba78 100644
--- a/drivers/gpu/drm/mcde/mcde_dsi.c
+++ b/drivers/gpu/drm/mcde/mcde_dsi.c
@@ -1111,6 +1111,7 @@ static int mcde_dsi_bind(struct device *dev, struct device *master,
 			bridge = of_drm_find_bridge(child);
 			if (!bridge) {
 				dev_err(dev, "failed to find bridge\n");
+				of_node_put(child);
 				return -EINVAL;
 			}
 		}
-- 
2.35.1



