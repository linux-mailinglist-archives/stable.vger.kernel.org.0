Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9986AE9DF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjCGR2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjCGR2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2521E82341
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B429AB819AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1639BC4339B;
        Tue,  7 Mar 2023 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209802;
        bh=67OCwc+LVHg9FPPDq6kewUuKRH61FPvgBIA2w2Eg5yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13jhZOJuM8Wxn2J/Yi5sHws8Yyc++icyBI1icp8RVAtdVgZL4vWGOUcgcKyH0afl5
         CEpg8iwlH24Cu0P2xKpDbvseDWFB60/HBobgcc+V0Htt+ndd6TFUNg8Bnf+UhyjOkq
         0AUkPW/pBN7LfCipJ+EeoAimAeHfQbQQoHlECb5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pin-yen Lin <treapking@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0337/1001] drm/bridge: it6505: Guard bridge power in IRQ handler
Date:   Tue,  7 Mar 2023 17:51:49 +0100
Message-Id: <20230307170036.099543518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 5eb9a4314053bda7642643f70f49a2b415920812 ]

Add a pair of pm_runtime_get_if_in_use and pm_runtime_put_sync in the
interrupt handler to make sure the bridge won't be powered off during
the interrupt handlings. Also remove the irq_lock mutex because it's not
guarding anything now.

Fixes: ab28896f1a83 ("drm/bridge: it6505: Improve synchronization between extcon subsystem")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221109095227.3320919-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 21a9b8422bda5..e7f7d0ce13805 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -412,7 +412,6 @@ struct it6505 {
 	 * Mutex protects extcon and interrupt functions from interfering
 	 * each other.
 	 */
-	struct mutex irq_lock;
 	struct mutex extcon_lock;
 	struct mutex mode_lock; /* used to bridge_detect */
 	struct mutex aux_lock; /* used to aux data transfers */
@@ -2494,10 +2493,8 @@ static irqreturn_t it6505_int_threaded_handler(int unused, void *data)
 	};
 	int int_status[3], i;
 
-	mutex_lock(&it6505->irq_lock);
-
-	if (it6505->enable_drv_hold || !it6505->powered)
-		goto unlock;
+	if (it6505->enable_drv_hold || pm_runtime_get_if_in_use(dev) <= 0)
+		return IRQ_HANDLED;
 
 	int_status[0] = it6505_read(it6505, INT_STATUS_01);
 	int_status[1] = it6505_read(it6505, INT_STATUS_02);
@@ -2515,16 +2512,14 @@ static irqreturn_t it6505_int_threaded_handler(int unused, void *data)
 	if (it6505_test_bit(irq_vec[0].bit, (unsigned int *)int_status))
 		irq_vec[0].handler(it6505);
 
-	if (!it6505->hpd_state)
-		goto unlock;
-
-	for (i = 1; i < ARRAY_SIZE(irq_vec); i++) {
-		if (it6505_test_bit(irq_vec[i].bit, (unsigned int *)int_status))
-			irq_vec[i].handler(it6505);
+	if (it6505->hpd_state) {
+		for (i = 1; i < ARRAY_SIZE(irq_vec); i++) {
+			if (it6505_test_bit(irq_vec[i].bit, (unsigned int *)int_status))
+				irq_vec[i].handler(it6505);
+		}
 	}
 
-unlock:
-	mutex_unlock(&it6505->irq_lock);
+	pm_runtime_put_sync(dev);
 
 	return IRQ_HANDLED;
 }
@@ -3277,7 +3272,6 @@ static int it6505_i2c_probe(struct i2c_client *client,
 	if (!it6505)
 		return -ENOMEM;
 
-	mutex_init(&it6505->irq_lock);
 	mutex_init(&it6505->extcon_lock);
 	mutex_init(&it6505->mode_lock);
 	mutex_init(&it6505->aux_lock);
-- 
2.39.2



