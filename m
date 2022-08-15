Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82A1594213
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbiHOVIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbiHOVFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF98D5DC1;
        Mon, 15 Aug 2022 12:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B10ED60F68;
        Mon, 15 Aug 2022 19:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07032C433D7;
        Mon, 15 Aug 2022 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590909;
        bh=RobEPk0ktDvBzpclkbB/iJ3rx8WyTbt0060Tx09Tb4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SJb5p3dePnUNfEQq/DUsXZxjpwGKAzZI0XeqZRyAsDPDy9RpS+kUQKY8ii1vnfq4
         nTYQK6Lyh/4NmEEqwl7FtV3vpm8W0CNrz5dbTdubJoTMosncj3zvzcszWvM4MJdcYa
         Lf+AsOkrilaVfSgUDfa4Tw7y4LlvZrjvsZoizL1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0410/1095] drm/rockchip: Fix an error handling path rockchip_dp_probe()
Date:   Mon, 15 Aug 2022 19:56:49 +0200
Message-Id: <20220815180446.673524098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index c82901d9a9cc..8a9bb618f872 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -398,7 +398,15 @@ static int rockchip_dp_probe(struct platform_device *pdev)
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



