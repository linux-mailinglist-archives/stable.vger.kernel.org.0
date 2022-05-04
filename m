Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B2251A8A6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355605AbiEDRMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357320AbiEDRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3254A932;
        Wed,  4 May 2022 09:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73474618D7;
        Wed,  4 May 2022 16:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C600DC385A5;
        Wed,  4 May 2022 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683434;
        bh=fiEjsMwi+sx83CopIVwfDXjNiCaih6WW+Reo85LpXa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuA83JlATmvj+/jJjzJURhnjuffKtc02qLVBuKh9OJcQnTCh9oK8gdqnFD0HwfknM
         crRAOuQj+gLk4EVNLGCmg5cO5jE6C8kR2CFYjeQtg4cv3g+yEVY5eD11AF8mhxZJOG
         NBiItB2OVBuuBhZTkxl4NkTQ4/79n1TuCZqg4IME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 085/225] phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe
Date:   Wed,  4 May 2022 18:45:23 +0200
Message-Id: <20220504153118.619333350@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d644e0d79829b1b9a14beedbdb0dc1256fc3677d ]

The pm_runtime_enable will increase power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable(). And use pm_runtime_dont_use_autosuspend() to
undo pm_runtime_use_autosuspend()
In the PM Runtime docs:
    Drivers in ->remove() callback should undo the runtime PM changes done
    in ->probe(). Usually this means calling pm_runtime_disable(),
    pm_runtime_dont_use_autosuspend() etc.

We should do this in error handling.

Fixes: f7f50b2a7b05 ("phy: mapphone-mdm6600: Add runtime PM support for n_gsm on USB suspend")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220301024615.31899-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/phy-mapphone-mdm6600.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/motorola/phy-mapphone-mdm6600.c b/drivers/phy/motorola/phy-mapphone-mdm6600.c
index 5172971f4c36..3cd4d51c247c 100644
--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -629,7 +629,8 @@ static int phy_mdm6600_probe(struct platform_device *pdev)
 cleanup:
 	if (error < 0)
 		phy_mdm6600_device_power_off(ddata);
-
+	pm_runtime_disable(ddata->dev);
+	pm_runtime_dont_use_autosuspend(ddata->dev);
 	return error;
 }
 
-- 
2.35.1



