Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A3259DB50
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357307AbiHWLR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiHWLR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2945FF43;
        Tue, 23 Aug 2022 02:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E16B81B1F;
        Tue, 23 Aug 2022 09:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24409C433C1;
        Tue, 23 Aug 2022 09:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246446;
        bh=H5MXShAtHWxxOpSOSpBdOoTIxXQrfmWAG0T7BIY0HVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VH9lNhrjzGtZZ4kyH7wz2w1CaMU3oRJfKHXkz7T8r6PnS5j5aMdRhTezaokFZMunB
         13JwF8+IUYUbKsx1TI+5LMjb0q6lsBJHXTaNZQT1ijx0BRA+1kWMH72bNEwPVbkAKy
         aA3gjAbwZv5k5U2XqyK3zSAnskV/MQ3p6fVDSsD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/389] drm/rockchip: Fix an error handling path rockchip_dp_probe()
Date:   Tue, 23 Aug 2022 10:23:11 +0200
Message-Id: <20220823080120.348857799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5074376822fe99fa4ce344b851c5016d00c0444f ]

Should component_add() fail, we should call analogix_dp_remove() in the
error handling path, as already done in the remove function.

Fixes: 152cce0006ab ("drm/bridge: analogix_dp: Split bind() into probe() and real bind()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/b719d9061bb97eb85145fbd3c5e63f4549f2e13e.1655572071.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index ce98c08aa8b4..48281e29b5d4 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -401,7 +401,15 @@ static int rockchip_dp_probe(struct platform_device *pdev)
 	if (IS_ERR(dp->adp))
 		return PTR_ERR(dp->adp);
 
-	return component_add(dev, &rockchip_dp_component_ops);
+	ret = component_add(dev, &rockchip_dp_component_ops);
+	if (ret)
+		goto err_dp_remove;
+
+	return 0;
+
+err_dp_remove:
+	analogix_dp_remove(dp->adp);
+	return ret;
 }
 
 static int rockchip_dp_remove(struct platform_device *pdev)
-- 
2.35.1



