Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F465812D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiL1QZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiL1QYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D501AA20
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A9561577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF578C433EF;
        Wed, 28 Dec 2022 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244527;
        bh=my7mB0AxbLAMydQyKfjQyENP7hxSdaQcHGnm0y/FDXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqIjf4j0kD0m6q1cr11F7WaeObddPnqCBEiq3J0kPbakEnF/6b4wyiAYrBlZlKH0z
         Tdcgo/t6D18xJS4bj7gUSRmgl3n3WSkFgsmVEXSMAWZ9aHRCLjoZSJdNWidGByA/Zd
         2BeTLo5T6Wsy+dgShwAtjXMsVXhSbcr3OVDxyHHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca.weiss@fairphone.com>,
        Amit Kucheria <amitk@kernel.org>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0727/1073] thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2
Date:   Wed, 28 Dec 2022 15:38:35 +0100
Message-Id: <20221228144347.771467314@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 8763f8acbf8aef22a2321d4c978cd078aa3b8f64 ]

On gen2 chips the stage2 threshold is not 140 degC but 125 degC.

Make the warning message clearer by using this variable and also by
including the temperature that was checked for.

Fixes: aa92b3310c55 ("thermal/drivers/qcom-spmi-temp-alarm: Add support for GEN2 rev 1 PMIC peripherals")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Amit Kucheria <amitk@kernel.org>
Link: https://lore.kernel.org/r/20221020145237.942146-1-luca.weiss@fairphone.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
index 770f82cc9bca..247b39d57fa7 100644
--- a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
+++ b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
@@ -252,7 +252,8 @@ static int qpnp_tm_update_critical_trip_temp(struct qpnp_tm_chip *chip,
 			disable_s2_shutdown = true;
 		else
 			dev_warn(chip->dev,
-				 "No ADC is configured and critical temperature is above the maximum stage 2 threshold of 140 C! Configuring stage 2 shutdown at 140 C.\n");
+				 "No ADC is configured and critical temperature %d mC is above the maximum stage 2 threshold of %ld mC! Configuring stage 2 shutdown at %ld mC.\n",
+				 temp, stage2_threshold_max, stage2_threshold_max);
 	}
 
 skip:
-- 
2.35.1



