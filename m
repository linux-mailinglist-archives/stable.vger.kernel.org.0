Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498AA6D2CB2
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbjDABmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjDABmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:42:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DE11EFC5;
        Fri, 31 Mar 2023 18:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE6DB832F5;
        Sat,  1 Apr 2023 01:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4912BC43446;
        Sat,  1 Apr 2023 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313312;
        bh=gi+aNmMLzNAw/upSPG9ogRlXPz1oNELyCI8+p65yLEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP8sFP94PGdrvq4WNfQW/PaD90C9WZkhUNEWdQ+guc/p0zASw9xFCqepK3C92CR6b
         R32El1UztfNcXyvyOoWLv6dRaQT4U3fmuCbbaa7SYWSWzk3StrG7AV8YmUfQOug/h+
         ydhfxhUM1jyJK6ACgzhXytFd2E2wbsD+HA+9rlXVmoeMtyGRBSS5VQftpD9DPQugfK
         KhDkDanJaNp/YV3pONr4DqZJUQ61z2GgK7nA4NICGxayP4HWfJya2BXw86g3AYjOu3
         1NcYyCzi8r7K+HOIzUWMKApBDctmdOWAZSjjSof4angdcYShAoyBNHHTxeM4WTiKt5
         cwujXtFjQLCeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iwona Winiarska <iwona.winiarska@intel.com>,
        Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 15/25] hwmon: (peci/cputemp) Fix miscalculated DTS for SKX
Date:   Fri, 31 Mar 2023 21:41:13 -0400
Message-Id: <20230401014126.3356410-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iwona Winiarska <iwona.winiarska@intel.com>

[ Upstream commit 2b91c4a870c9830eaf95e744454c9c218cccb736 ]

For Skylake, DTS temperature of the CPU is reported in S10.6 format
instead of S8.8.

Reported-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/lkml/ZBhHS7v+98NK56is@home.paul.comp/
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20230321090410.866766-1-iwona.winiarska@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/peci/cputemp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/peci/cputemp.c b/drivers/hwmon/peci/cputemp.c
index 30850a479f61f..87d56f0fc888c 100644
--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -537,6 +537,12 @@ static const struct cpu_info cpu_hsx = {
 	.thermal_margin_to_millidegree = &dts_eight_dot_eight_to_millidegree,
 };
 
+static const struct cpu_info cpu_skx = {
+	.reg		= &resolved_cores_reg_hsx,
+	.min_peci_revision = 0x33,
+	.thermal_margin_to_millidegree = &dts_ten_dot_six_to_millidegree,
+};
+
 static const struct cpu_info cpu_icx = {
 	.reg		= &resolved_cores_reg_icx,
 	.min_peci_revision = 0x40,
@@ -558,7 +564,7 @@ static const struct auxiliary_device_id peci_cputemp_ids[] = {
 	},
 	{
 		.name = "peci_cpu.cputemp.skx",
-		.driver_data = (kernel_ulong_t)&cpu_hsx,
+		.driver_data = (kernel_ulong_t)&cpu_skx,
 	},
 	{
 		.name = "peci_cpu.cputemp.icx",
-- 
2.39.2

