Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772F4603D76
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJSJCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiJSJAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:00:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919296C106;
        Wed, 19 Oct 2022 01:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D94226174B;
        Wed, 19 Oct 2022 08:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7FAC433D6;
        Wed, 19 Oct 2022 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169648;
        bh=KtKdx8ciCkHxA71SnFUdpSaQth5te/5OBQ4Stjo6Rlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itO6kHUSCXqiLVNs1oYyC8hSdys/dRNxTtXJzdTSrTO1ml82YPYoS0L4HymJ2GT/o
         vdk/fRZb6GkT2jH3wM0VXKymlLPZNUuaBAaXB6+XuxSQ2esh8MJC9h2oP1OS/d6Q8g
         oNNlY7PhA8ol1rUkeMZRfB60RIfweIVs3llAaRyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 356/862] drm/bridge: parade-ps8640: Fix regulator supply order
Date:   Wed, 19 Oct 2022 10:27:23 +0200
Message-Id: <20221019083305.759061047@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 31e88cb39f8a..49107a6cdac1 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -631,8 +631,8 @@ static int ps8640_probe(struct i2c_client *client)
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



