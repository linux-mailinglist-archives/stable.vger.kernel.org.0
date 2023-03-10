Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C36B43EC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCJOUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjCJOTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:19:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DC2F777
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B06B561948
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5D8C433EF;
        Fri, 10 Mar 2023 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457869;
        bh=6dr/J/7dEG3YI4o2FHkASAm0CBPKyRgbPmG0hJ5e2kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3BOWRokxw9B1hXCHdID0D01rF0Tj3MBnd2xemAhcZOflG0kbMi1wcJwU8KeYcrT7
         jAdE3svZ9hhgyMI8Tj+CJB1fla0dS8e/qXlLAKQPe75TMXgTaCEWWQc123/w2f8j8s
         /vi6sAnFrapTERYSbL8r3oqiuaVoyMwZNP+UdG0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cormier <jcormier@criticallink.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/252] hwmon: (ltc2945) Handle error case in ltc2945_value_store
Date:   Fri, 10 Mar 2023 14:37:34 +0100
Message-Id: <20230310133721.362761668@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Jonathan Cormier <jcormier@criticallink.com>

[ Upstream commit 178b01eccfb0b8149682f61388400bd3d903dddc ]

ltc2945_val_to_reg errors were not being handled
which would have resulted in register being set to
0 (clamped) instead of being left alone.

Fixes: 6700ce035f83 ("hwmon: Driver for Linear Technologies LTC2945")

Signed-off-by: Jonathan Cormier <jcormier@criticallink.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2945.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index 1b92e4f6e2349..efabe514ec560 100644
--- a/drivers/hwmon/ltc2945.c
+++ b/drivers/hwmon/ltc2945.c
@@ -257,6 +257,8 @@ static ssize_t ltc2945_set_value(struct device *dev,
 
 	/* convert to register value, then clamp and write result */
 	regval = ltc2945_val_to_reg(dev, reg, val);
+	if (regval < 0)
+		return regval;
 	if (is_power_reg(reg)) {
 		regval = clamp_val(regval, 0, 0xffffff);
 		regbuf[0] = regval >> 16;
-- 
2.39.2



