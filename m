Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D5F6043F0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiJSLyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiJSLyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:54:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04DE1ACAA1;
        Wed, 19 Oct 2022 04:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57585B823BB;
        Wed, 19 Oct 2022 08:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B711FC433C1;
        Wed, 19 Oct 2022 08:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169643;
        bh=rB+7liTz6fUSTUIeYUpesRGUTcU+4qwtivdpWxzWjnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UW739ri0f9VVT0z+fv6q001rhFUi5lw5S77u7c4w7Qg9bJn6LIsP92DqREqTIIXmF
         rAFG1ubTCW1ePCgRTxuumHQzoIQ4VgYOpBr7kOrNBYZ6gGOnFRJdqubyDy/ZScptni
         Ut8XKxyioZPOBCBPgT3xANxB0oBR8vLhbc+RWHJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 354/862] drm/bridge: anx7625: Fix refcount bug in anx7625_parse_dt()
Date:   Wed, 19 Oct 2022 10:27:21 +0200
Message-Id: <20221019083305.680888969@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 1d43a5120ab49f22ba6c5901ad3994e254510303 ]

In anx7625_parse_dt(), 'pdata->mipi_host_node' will be assigned a
new reference with of_graph_get_remote_node() which will increase
the refcount of the object, correspondingly, we should call
of_node_put() for the old reference stored in the 'pdata->mipi_host_node'.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220719065447.1080817-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index d1f1d525aeb6..79fc7a50b497 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1642,6 +1642,7 @@ static int anx7625_parse_dt(struct device *dev,
 	anx7625_get_swing_setting(dev, pdata);
 
 	pdata->is_dpi = 0; /* default dsi mode */
+	of_node_put(pdata->mipi_host_node);
 	pdata->mipi_host_node = of_graph_get_remote_node(np, 0, 0);
 	if (!pdata->mipi_host_node) {
 		DRM_DEV_ERROR(dev, "fail to get internal panel.\n");
-- 
2.35.1



