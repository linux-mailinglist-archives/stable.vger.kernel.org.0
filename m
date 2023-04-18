Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5266E64B5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjDRMvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjDRMvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BEF16B2D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78AF463407
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF7C433D2;
        Tue, 18 Apr 2023 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822277;
        bh=gi+aNmMLzNAw/upSPG9ogRlXPz1oNELyCI8+p65yLEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQdCfLtJO4chc+wXo1M3BYVeIVbMiJ9qLYf0fBsydT4IYNluN9oBg5+uuSNVRtFlV
         /xITTyXj08Yh9cCnLUbW1kDkaI1iajP9ABOqQhLRanpO02lcH+M+mqlUwezvUWdGAE
         3CZb+IZjgW9fnR9qTLEnEGBVRoeCEpKKwQvNX6eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Fertser <fercerpav@gmail.com>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 089/139] hwmon: (peci/cputemp) Fix miscalculated DTS for SKX
Date:   Tue, 18 Apr 2023 14:22:34 +0200
Message-Id: <20230418120317.139847151@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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



