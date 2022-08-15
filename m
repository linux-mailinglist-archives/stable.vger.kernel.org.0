Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC2959385A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbiHOSc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243293AbiHOScO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C26033424;
        Mon, 15 Aug 2022 11:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76385B8107E;
        Mon, 15 Aug 2022 18:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA934C433C1;
        Mon, 15 Aug 2022 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587633;
        bh=fJlX3h+MOj3Xfe/dl4vL1uJNZJFo+EAzH1jy8cqdO+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXILqoJvs43UJcfrInA9w0qPXgZugcbtaM4WF6aELFbEGVQ6bLBL5G2rB/abBFM4a
         2oLJOSKBHg9IJ6qdSeKX2tSpzR2bEa06GJhlvFVIcpUTHJfBnnvHb5XT31GMVk2aih
         1uPaIHwmaJHoG5Olsn+qqirrGTatX63NF6a/0Y7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/779] hwmon: (dell-smm) Add Dell XPS 13 7390 to fan control whitelist
Date:   Mon, 15 Aug 2022 19:56:29 +0200
Message-Id: <20220815180343.518187007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 9cb1c3588038..597cbb4391bd 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -1198,6 +1198,14 @@ static const struct dmi_system_id i8k_whitelist_fan_control[] __initconst = {
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



