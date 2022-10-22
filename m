Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718EB60874C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiJVIAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiJVH5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:57:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747AA2615;
        Sat, 22 Oct 2022 00:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD8EB82E11;
        Sat, 22 Oct 2022 07:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE25C433D6;
        Sat, 22 Oct 2022 07:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424854;
        bh=igiYCLXYnX3P4qwWb2eb2cyMpJjh/OfOIwrUzVmttEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1i6NkRdpNAjfca8jjojXA1hQzvVWkJZJDirwO5mzVd/C6IjUMtSV/TLi1FwSekYk
         7cXrwpwIZVIw5E4gAV124MKNxLb4pkQzQosu0mcPfwheL8FZgqdqW62gPS29Ng6XG/
         lgGHUA66RAP+8Gz+4qae8TiNPE5+ZCTwYDZkZiwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 302/717] drm/bridge: parade-ps8640: Fix regulator supply order
Date:   Sat, 22 Oct 2022 09:23:01 +0200
Message-Id: <20221022072506.305012646@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit fc94224c2e0ae8d83ac511a3ef4962178505469d ]

The datasheet says that VDD12 must be enabled and at full voltage before
VDD33 is enabled.

Reorder the bulk regulator supply names so that VDD12 is enabled before
VDD33. Any enable ramp delays should be handled by setting proper
constraints on the regulators.

Fixes: bc1aee7fc8f0 ("drm/bridge: Add I2C based driver for ps8640 bridge")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220721092258.3397461-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index edb939b14c04..38dcc606b499 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -596,8 +596,8 @@ static int ps8640_probe(struct i2c_client *client)
 	if (!ps_bridge)
 		return -ENOMEM;
 
-	ps_bridge->supplies[0].supply = "vdd33";
-	ps_bridge->supplies[1].supply = "vdd12";
+	ps_bridge->supplies[0].supply = "vdd12";
+	ps_bridge->supplies[1].supply = "vdd33";
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ps_bridge->supplies),
 				      ps_bridge->supplies);
 	if (ret)
-- 
2.35.1



