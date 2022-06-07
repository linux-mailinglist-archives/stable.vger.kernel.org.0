Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8B54196D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377720AbiFGVWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380975AbiFGVRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01901455BA;
        Tue,  7 Jun 2022 11:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2CDDB8220B;
        Tue,  7 Jun 2022 18:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F624C3411F;
        Tue,  7 Jun 2022 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628286;
        bh=gbzerGw41nFYcSBVbgsHBzOTUnrtuO+DP0OSHhN634Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL5GjuMgzMh/M2muJkCSJQx8PwE6PDfZJQyY7qdiahRsmmR2DJP+iOSL+ALV3hpyF
         PGulaXvCEyWsNIK+GqMCDhlQoKKLjwJfs7nh9PI+Tjiev7vJ6gjK3rT1AuzdvntTVt
         pfSqNdYtucJYbRSJbxNRHxdxFCraRYfV5f027Jcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 273/879] drm/bridge: anx7625: add missing destroy_workqueue() in anx7625_i2c_probe()
Date:   Tue,  7 Jun 2022 18:56:31 +0200
Message-Id: <20220607165010.773878807@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6f5efd118efafa22139e8670a4e4b506ba757dfd ]

Add the missing destroy_workqueue() before return from
anx7625_i2c_probe() in the error handling case.

Fixes: adca62ec370c ("drm/bridge: anx7625: Support reading edid through aux channel")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220326073326.3389347-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 8e1851a57638..a23e13c29a1d 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2657,7 +2657,7 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 	if (ret) {
 		if (ret != -EPROBE_DEFER)
 			DRM_DEV_ERROR(dev, "fail to parse DT : %d\n", ret);
-		return ret;
+		goto free_wq;
 	}
 
 	if (anx7625_register_i2c_dummy_clients(platform, client) != 0) {
@@ -2672,7 +2672,7 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 	pm_suspend_ignore_children(dev, true);
 	ret = devm_add_action_or_reset(dev, anx7625_runtime_disable, dev);
 	if (ret)
-		return ret;
+		goto free_wq;
 
 	if (!platform->pdata.low_power_mode) {
 		anx7625_disable_pd_protocol(platform);
-- 
2.35.1



