Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403AF6B4856
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjCJPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjCJPBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBD4124E8E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E5A4B822EA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE89C4339E;
        Fri, 10 Mar 2023 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460033;
        bh=NXjnBuRPVl8nFjPNRYUxu+pKxAy0jV74Q/MAJfYHBw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAxN68vNEXi+rDf/jjEBP7Q6wJUn+Rd3tfpoEEScz2ob0kipgfyDLRHsxmrxzFZ2C
         BhSvsEc8HUGioATj4YKVCDBw4vNlC0k1iAmAG9OI/bSfL/Yfg2RNylOaURYaWig6zK
         jQIdrOFfaglPr0uFIrHHbqjNfFZd25dljeI4h4JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cormier <jcormier@criticallink.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/529] hwmon: (ltc2945) Handle error case in ltc2945_value_store
Date:   Fri, 10 Mar 2023 14:35:43 +0100
Message-Id: <20230310133814.269106897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index ba9c868a8641e..65d792f184255 100644
--- a/drivers/hwmon/ltc2945.c
+++ b/drivers/hwmon/ltc2945.c
@@ -248,6 +248,8 @@ static ssize_t ltc2945_value_store(struct device *dev,
 
 	/* convert to register value, then clamp and write result */
 	regval = ltc2945_val_to_reg(dev, reg, val);
+	if (regval < 0)
+		return regval;
 	if (is_power_reg(reg)) {
 		regval = clamp_val(regval, 0, 0xffffff);
 		regbuf[0] = regval >> 16;
-- 
2.39.2



