Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23A54C9655
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiCAUWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiCAUWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609DB90248;
        Tue,  1 Mar 2022 12:19:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC9266175F;
        Tue,  1 Mar 2022 20:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47354C340EE;
        Tue,  1 Mar 2022 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165949;
        bh=gP5r6uGW4ntjRrb20ZZ/mknKWD98RuT3ui1eEtmxEbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpeny9w6eYw/d1aO0QedaiZZeovE08qUPWeq4DMCw0fC5cmXPUZXDHtbwTq7Mrow5
         OkWk+dOrR55IhQLVNLmq891NMQ27jEfYWXAtrAqITM2rrMJuoCgZASQBwRRyUty3Nn
         70Dw2McbOoMP67jNNRqegE/WqPBwbeqJ2LzgUf4oI78WI/v0bqqbL8jToJkK/qf9FP
         0JUWdDpQ21e3yehVyafubsJHom7X3lYU744+wz6KqKQQ2JbXmbI60ULwb9o2u5+Oic
         lWIs8ZjfutFJCXsY6hx5Bdzb1M9ae+j64zJjI6K62trKaok0s4t6LMLyeYQs6cPsZw
         Yrbik5Bs6Mm4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vikash Chandola <vikash.chandola@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/14] hwmon: (pmbus) Clear pmbus fault/warning bits after read
Date:   Tue,  1 Mar 2022 15:18:19 -0500
Message-Id: <20220301201833.18841-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201833.18841-1-sashal@kernel.org>
References: <20220301201833.18841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikash Chandola <vikash.chandola@linux.intel.com>

[ Upstream commit 35f165f08950a876f1b95a61d79c93678fba2fd6 ]

Almost all fault/warning bits in pmbus status registers remain set even
after fault/warning condition are removed. As per pmbus specification
these faults must be cleared by user.
Modify hwmon behavior to clear fault/warning bit after fetching data if
fault/warning bit was set. This allows to get fresh data in next read.

Signed-off-by: Vikash Chandola <vikash.chandola@linux.intel.com>
Link: https://lore.kernel.org/r/20220222131253.2426834-1-vikash.chandola@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index b0e2820a2d578..71798fde2ef0c 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -898,6 +898,11 @@ static int pmbus_get_boolean(struct i2c_client *client, struct pmbus_boolean *b,
 		pmbus_update_sensor_data(client, s2);
 
 	regval = status & mask;
+	if (regval) {
+		ret = pmbus_write_byte_data(client, page, reg, regval);
+		if (ret)
+			goto unlock;
+	}
 	if (s1 && s2) {
 		s64 v1, v2;
 
-- 
2.34.1

