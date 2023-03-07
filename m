Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24A6AEA48
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCGRc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjCGRcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0398E900BA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE653B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00615C4339B;
        Tue,  7 Mar 2023 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210050;
        bh=cDv81CRFHIsoqIGkZy7byR7wvu4GaiIgPSCBNHJh2BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDwXVUohu0yEG1a1Hjb8bihDS9jI7z9qoaI6TCTkb4dcywYR407xo1HPEdYq6p08J
         mE5/maFZX4xk+xYFXCWCLDc9lj/HoOoKxsj9oCzKxkUCttzccZESq40WwGwPtRcW1f
         Ls8fuHnlnjxTChjcDfuOsR9SdPZO+fcBY5/NzxcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Eugene Shalygin <eugene.shalygin@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0416/1001] hwmon: (asus-ec-sensors) add missing mutex path
Date:   Tue,  7 Mar 2023 17:53:08 +0100
Message-Id: <20230307170039.385924749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit e2de0e6abd91b05411cb1f0953115dbbbe9b11ce ]

Add missing mutex path for ProArt X570-CREATOR WIFI.

Fixes: de8fbac5e59e (hwmon: (asus-ec-sensors) implement locking via the ACPI global lock)
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20230121111728.168514-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index a901e4e33d81d..b4d65916b3c00 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -299,6 +299,7 @@ static const struct ec_board_info board_info_pro_art_x570_creator_wifi = {
 	.sensors = SENSOR_SET_TEMP_CHIPSET_CPU_MB | SENSOR_TEMP_VRM |
 		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT |
 		SENSOR_CURR_CPU | SENSOR_IN_CPU_CORE,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_ASMX,
 	.family = family_amd_500_series,
 };
 
-- 
2.39.2



