Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2255D643322
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiLETeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbiLETeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B714A25C5D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E62B81151
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC9C433D6;
        Mon,  5 Dec 2022 19:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268549;
        bh=jFWS9svE5rXeHxoXXh0KE869rSj8wgNXlBOTGuBpMI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8i1MhE6dTa7QlqcBlCdwancnOnifS8+O9xU8HyDYAr3Aym8M0zMuv9IJg2mYXlBJ
         Ibiks72+mW+ysCQT7Bo9i94CAoe2jdsUKuF/i/e+9tjU0jiEEeGzRfn78j1pfma1Yo
         DYHD5hbZzy6Y64x2Ga9z9AhY+QW5d3C60TS0Tl4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ninad Malwade <nmalwade@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/92] hwmon: (ina3221) Fix shunt sum critical calculation
Date:   Mon,  5 Dec 2022 20:09:31 +0100
Message-Id: <20221205190804.094153276@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Ninad Malwade <nmalwade@nvidia.com>

[ Upstream commit b8d27d2ce8dfc207e4b67b929a86f2be76fbc6ef ]

The shunt sum critical limit register value should be left shifted
by one bit as its LSB-0 is a reserved bit.

Fixes: 2057bdfb7184 ("hwmon: (ina3221) Add summation feature support")
Signed-off-by: Ninad Malwade <nmalwade@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221108044508.23463-1-nmalwade@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index ad11cbddc3a7..d3c98115042b 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -230,7 +230,7 @@ static int ina3221_read_value(struct ina3221_data *ina, unsigned int reg,
 	 * Shunt Voltage Sum register has 14-bit value with 1-bit shift
 	 * Other Shunt Voltage registers have 12 bits with 3-bit shift
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		*val = sign_extend32(regval >> 1, 14);
 	else
 		*val = sign_extend32(regval >> 3, 12);
@@ -465,7 +465,7 @@ static int ina3221_write_curr(struct device *dev, u32 attr,
 	 *     SHUNT_SUM: (1 / 40uV) << 1 = 1 / 20uV
 	 *     SHUNT[1-3]: (1 / 40uV) << 3 = 1 / 5uV
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 20) & 0xfffe;
 	else
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 5) & 0xfff8;
-- 
2.35.1



