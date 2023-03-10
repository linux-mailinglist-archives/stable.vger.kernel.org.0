Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538B16B4558
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjCJOdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjCJOdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E99EF8F01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A2F3B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82593C433D2;
        Fri, 10 Mar 2023 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458730;
        bh=zz/PTPwM8i//+kMyOt9rE7zmlKll+ty7ismdgbou/WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5DOJNOvou+Vrmt44sxFL3y5+8ZyGKPUmKnlt8k1VrX7mCoFIQJRaVhiEw7wb0NaG
         OAKeRIPaf6my2taiFdQRv6vPqnSZhUGf/OrYFQpTcLlEVzl17ph7OdAFB1995/hPgU
         OIPwIX8USnX+8n+I1jiNoXa8TJg6xB3bZP7Ox6+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vadim Pasternak <vadimp@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/357] hwmon: (mlxreg-fan) Return zero speed for broken fan
Date:   Fri, 10 Mar 2023 14:36:55 +0100
Message-Id: <20230310133740.225112835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit a1ffd3c46267ee5c807acd780e15df9bb692223f ]

Currently for broken fan driver returns value calculated based on error
code (0xFF) in related fan speed register.
Thus, for such fan user gets fan{n}_fault to 1 and fan{n}_input with
misleading value.

Add check for fan fault prior return speed value and return zero if
fault is detected.

Fixes: 65afb4c8e7e4 ("hwmon: (mlxreg-fan) Add support for Mellanox FAN driver")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20230212145730.24247-1-vadimp@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mlxreg-fan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index bd8f5a3aaad9c..052c897a635d5 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -127,6 +127,12 @@ mlxreg_fan_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 			if (err)
 				return err;
 
+			if (MLXREG_FAN_GET_FAULT(regval, tacho->mask)) {
+				/* FAN is broken - return zero for FAN speed. */
+				*val = 0;
+				return 0;
+			}
+
 			*val = MLXREG_FAN_GET_RPM(regval, fan->divider,
 						  fan->samples);
 			break;
-- 
2.39.2



