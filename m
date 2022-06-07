Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0545406C3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347583AbiFGRiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347815AbiFGRft (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE71059F5;
        Tue,  7 Jun 2022 10:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABCE1B82185;
        Tue,  7 Jun 2022 17:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041E3C385A5;
        Tue,  7 Jun 2022 17:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623097;
        bh=Oa09tsOvQ9Bl2U03X5wl5mPwZC6XEVRvJHjy6u3ZsTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfyqv2F7vnxQw2obQsmBlpahvscpkX60sbM2qVMl0PPJ18LELljGa3fhFdDqqH2IY
         nO8wmh/QgaZVHyXGpZamJFrlgIbb5W4H1EJUsGnc9wONLX+rOg0smWakT9k0StbBTF
         Z4Hi0/sxFc+eKDw4SFw6MpsCCZH7/RdE6NcbSsPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/452] thermal/drivers/imx_sc_thermal: Fix refcount leak in imx_sc_thermal_probe
Date:   Tue,  7 Jun 2022 19:01:40 +0200
Message-Id: <20220607164915.801427364@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 09700c504d8e63faffd2a2235074e8c5d130cb8f ]

of_find_node_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: e20db70dba1c ("thermal: imx_sc: add i.MX system controller thermal support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220517055121.18092-1-linmq006@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_sc_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index 8d76dbfde6a9..331a241eb0ef 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -94,8 +94,8 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 		sensor = devm_kzalloc(&pdev->dev, sizeof(*sensor), GFP_KERNEL);
 		if (!sensor) {
 			of_node_put(child);
-			of_node_put(sensor_np);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto put_node;
 		}
 
 		ret = thermal_zone_of_get_sensor_id(child,
@@ -124,7 +124,9 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev, "failed to add hwmon sysfs attributes\n");
 	}
 
+put_node:
 	of_node_put(sensor_np);
+	of_node_put(np);
 
 	return ret;
 }
-- 
2.35.1



