Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD4593C9D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347171AbiHOUYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347172AbiHOUXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A033A38;
        Mon, 15 Aug 2022 12:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A3CB810A2;
        Mon, 15 Aug 2022 19:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80322C433C1;
        Mon, 15 Aug 2022 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590167;
        bh=EU74vkKkp1wsrARBHmW0R9rKUvYeRIF5kWIHuk3CaDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/quCe+ttvfyGFuQxzr+WP5Lp0XhwjBng6MEQsjUNKw8rfVTtdLap8Q5X40bjSgr+
         yP8DY2NsjD9tDKPhxRR+pWmf8slvdVIAGc8tvI5tfUsfOkFl/xOqX/Byhy6EWw4bMU
         zwxSlX+T3+GHwQa0YObN3bn3pXd9QNBtIUXrInv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0174/1095] hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist
Date:   Mon, 15 Aug 2022 19:52:53 +0200
Message-Id: <20220815180436.833058414@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 385e5f57053ff293282fea84c1c27186d53f66e1 ]

A user reported that the program dell-bios-fan-control
worked on his Dell XPS 13 7390 to switch off automatic
fan control.
Since it uses the same mechanism as the dell_smm_hwmon
module, add this model to the fan control whitelist.

Compile-tested only.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220612041806.11367-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 84cb1ede7bc0..a0df9a0abeb9 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1262,6 +1262,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
 		},
 		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
 	},
+	{
+		.ident = "Dell XPS 13 7390",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 13 7390"),
+		},
+		.driver_data = (void *)&i8k_fan_control_data[I8K_FAN_34A3_35A3],
+	},
 	{ }
 };
 
-- 
2.35.1



