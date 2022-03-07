Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85A4CFAC1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiCGKXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241772AbiCGKVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF10290FD7;
        Mon,  7 Mar 2022 01:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45D04B810B2;
        Mon,  7 Mar 2022 09:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6A2C340F3;
        Mon,  7 Mar 2022 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647101;
        bh=J76EK4Gg0zKonoDusSRUDGSGYSXcFIUSgfL51l/8jB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvp47+Iz8QYbW/v6ZkKYc58Fc0RU0+be0f7x1y6fEj2GyX99u2hbIsS7MH/V6F1yE
         m9oHegh2U5d16ao3cRV18ELnXWF3NI24g8ZIyN/G+KP4IPZ6eFBmUhiUAgMjhMCiyr
         QMq/6kOsxn+mRjfscYyJ5YM+dCmboG69GacYpQ1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 157/186] drm/bridge: ti-sn65dsi86: Properly undo autosuspend
Date:   Mon,  7 Mar 2022 10:19:55 +0100
Message-Id: <20220307091658.466374511@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 26d3474348293dc752c55fe6d41282199f73714c ]

The PM Runtime docs say:
  Drivers in ->remove() callback should undo the runtime PM changes done
  in ->probe(). Usually this means calling pm_runtime_disable(),
  pm_runtime_dont_use_autosuspend() etc.

We weren't doing that for autosuspend. Let's do it.

Fixes: 9bede63127c6 ("drm/bridge: ti-sn65dsi86: Use pm_runtime autosuspend")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220222141838.1.If784ba19e875e8ded4ec4931601ce6d255845245@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 83d06c16d4d7..b7f74c146dee 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1474,6 +1474,7 @@ static inline void ti_sn_gpio_unregister(void) {}
 
 static void ti_sn65dsi86_runtime_disable(void *data)
 {
+	pm_runtime_dont_use_autosuspend(data);
 	pm_runtime_disable(data);
 }
 
@@ -1533,11 +1534,11 @@ static int ti_sn65dsi86_probe(struct i2c_client *client,
 				     "failed to get reference clock\n");
 
 	pm_runtime_enable(dev);
+	pm_runtime_set_autosuspend_delay(pdata->dev, 500);
+	pm_runtime_use_autosuspend(pdata->dev);
 	ret = devm_add_action_or_reset(dev, ti_sn65dsi86_runtime_disable, dev);
 	if (ret)
 		return ret;
-	pm_runtime_set_autosuspend_delay(pdata->dev, 500);
-	pm_runtime_use_autosuspend(pdata->dev);
 
 	ti_sn65dsi86_debugfs_init(pdata);
 
-- 
2.34.1



