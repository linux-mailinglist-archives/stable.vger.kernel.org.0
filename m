Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F188D54147F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358817AbiFGUSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376463AbiFGUQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2EB1CE7B8;
        Tue,  7 Jun 2022 11:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E9F4B822C0;
        Tue,  7 Jun 2022 18:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA758C385A2;
        Tue,  7 Jun 2022 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626551;
        bh=InK2P2719+ucxNiXUq5akHXves7w4RjNdOe6zfMyDME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLqxQ0RUa5Zkzjm+qzHbbRWExW/fm6otGb91Y2yA8L0XsiKS1ZgEaJHj5ZcjTkTf6
         pr/Yt0EWtW0giZQlgPoAMctyEZKuZAafEZBVQB3DGW+UHnRyt9VQflsGm2t03uXdws
         Fvjgoi1ppzrn8yzHxkOjcoftttBBYbJVLPjh/bLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 418/772] thermal/drivers/bcm2711: Dont clamp temperature at zero
Date:   Tue,  7 Jun 2022 19:00:10 +0200
Message-Id: <20220607165001.324177732@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 106e0121e243de4da7d634338089a68a8da2abe9 ]

The thermal sensor on BCM2711 is capable of negative temperatures, so don't
clamp the measurements at zero. Since this was the only use for variable t,
drop it.

This change based on a patch by Dom Cobley, who also tested the fix.

Fixes: 59b781352dc4 ("thermal: Add BCM2711 thermal driver")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220412195423.104511-1-stefan.wahren@i2se.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/bcm2711_thermal.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/thermal/broadcom/bcm2711_thermal.c b/drivers/thermal/broadcom/bcm2711_thermal.c
index 1ec57d9ecf53..e9bef5c3414b 100644
--- a/drivers/thermal/broadcom/bcm2711_thermal.c
+++ b/drivers/thermal/broadcom/bcm2711_thermal.c
@@ -38,7 +38,6 @@ static int bcm2711_get_temp(void *data, int *temp)
 	int offset = thermal_zone_get_offset(priv->thermal);
 	u32 val;
 	int ret;
-	long t;
 
 	ret = regmap_read(priv->regmap, AVS_RO_TEMP_STATUS, &val);
 	if (ret)
@@ -50,9 +49,7 @@ static int bcm2711_get_temp(void *data, int *temp)
 	val &= AVS_RO_TEMP_STATUS_DATA_MSK;
 
 	/* Convert a HW code to a temperature reading (millidegree celsius) */
-	t = slope * val + offset;
-
-	*temp = t < 0 ? 0 : t;
+	*temp = slope * val + offset;
 
 	return 0;
 }
-- 
2.35.1



