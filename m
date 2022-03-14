Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5614D82A3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240622AbiCNMGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240555AbiCNMFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF73846173;
        Mon, 14 Mar 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15FDCB80D24;
        Mon, 14 Mar 2022 12:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5446AC340ED;
        Mon, 14 Mar 2022 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259347;
        bh=qlgUNIR5LdJ8E/CVar6iRKrlBhipwT0fC3JfdrsqBjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4t0/nGf0awnKW5A8PWRTwNZput64heNzgMNzFXuXX6eCrDhBuwJZcWzcwsUTz998
         lqwyNwjhWivKZvqF9HP5NiZZnuKrJDBq6xsw/tG0R65E+3tkcIODQOmAQpou8k5Hfs
         ZvANbyWmoKtPG7f3Uo6gDahe5fkONEZ1s3WnVRyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vikash Chandola <vikash.chandola@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/71] hwmon: (pmbus) Clear pmbus fault/warning bits after read
Date:   Mon, 14 Mar 2022 12:53:34 +0100
Message-Id: <20220314112739.082070941@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b0e2820a2d57..71798fde2ef0 100644
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



