Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F64B5B7047
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiIMOYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiIMOX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EC16613A;
        Tue, 13 Sep 2022 07:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1689614A8;
        Tue, 13 Sep 2022 14:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD94C433D6;
        Tue, 13 Sep 2022 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078552;
        bh=jd9Zv6YwRpLotuy2I9VsONUSxps9HIUE56TFz7juRt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUqF+FwAEDIjLrcEVr9IERR+0Yo9vUOGuZnRLlS/NU2FGmJN6jPPXBmYAlwM+vcM3
         6NCccL6Ie+NNCN0gugjI6FccKGin2fWTBJ5K9YCzrYWYcc8EgIN6GARDAl/xTl7Yif
         ONlKhVS1u2TjBJaDfMPHD5hFrBXjsW/i6WU+urUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 184/192] hwmon: (asus-ec-sensors) add missing sensors for X570-I GAMING
Date:   Tue, 13 Sep 2022 16:04:50 +0200
Message-Id: <20220913140419.224190279@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 1c4e4f4a0e8d9ebe8be1c838fec4fb7053a989d9 ]

VRM and chipset temperature for ROG STRIX X570-I GAMING were missing
according to a user contribution to the LHM project [1].

[1] https://github.com/LibreHardwareMonitor/LibreHardwareMonitor/pull/767

Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20220710085539.1682869-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 88700d1396ba ("hwmon: (asus-ec-sensors) autoload module via DMI data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 625c2baa35ec6..0749cd023a323 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -366,9 +366,10 @@ static const struct ec_board_info board_info[] = {
 	},
 	{
 		.board_names = {"ROG STRIX X570-I GAMING"},
-		.sensors = SENSOR_TEMP_T_SENSOR | SENSOR_FAN_VRM_HS |
-			SENSOR_FAN_CHIPSET | SENSOR_CURR_CPU |
-			SENSOR_IN_CPU_CORE,
+		.sensors = SENSOR_TEMP_CHIPSET | SENSOR_TEMP_VRM |
+			SENSOR_TEMP_T_SENSOR |
+			SENSOR_FAN_VRM_HS | SENSOR_FAN_CHIPSET |
+			SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
 		.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
 		.family = family_amd_500_series,
 	},
-- 
2.35.1



