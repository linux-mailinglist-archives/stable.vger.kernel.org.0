Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76434540628
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346607AbiFGRd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348064AbiFGRbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4E811E1F7;
        Tue,  7 Jun 2022 10:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B6B060BC6;
        Tue,  7 Jun 2022 17:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94588C385A5;
        Tue,  7 Jun 2022 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622950;
        bh=Wx7YnWuj9keFIOHhuf82Tmvlop58HW39xxMEACIdscQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAxcXZzhOahAvRrl0xlJLeh8Fnmq9/UVluyj7gTNTF1VCLQyVlgnh4A7YUniSwRpX
         QjKJ25fnhol2FbFd2LMDnz1zOtX2XCAK3C257RcBvs41h5LS9rT6Su2UDSVsjhzYCK
         MwacsEaqBCxUgP34Ex6Vvt+Xm2cAeysMo/yZMciU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/452] thermal/drivers/bcm2711: Dont clamp temperature at zero
Date:   Tue,  7 Jun 2022 19:01:36 +0200
Message-Id: <20220607164915.681928564@linuxfoundation.org>
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
index 67c2a737bc9d..7b536c8a59dc 100644
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



