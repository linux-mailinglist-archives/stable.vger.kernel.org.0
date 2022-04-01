Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D345B4EF120
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347940AbiDAOg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348357AbiDAOeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:34:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E778BC7;
        Fri,  1 Apr 2022 07:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8F13B8250D;
        Fri,  1 Apr 2022 14:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF5C340F2;
        Fri,  1 Apr 2022 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823540;
        bh=ZGaxMcWNsjnV7aChUyzy0LngDkKW2UJ0gqGlphnc+j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CamOCylMwarYqsVeFHzx3c/1kDZ9LZe6CIUgLAkfzJ2oKxRyFr+J6xk8+MFd7ZjvA
         QXfBHAlcufJ/64GfEyT2SOO+XAFvcE2O7DiEXK8ZpcX+RrtWwipwzFdPfbw8PHG2Hf
         V4FLQTrTM30hLcBpy5DqxCJpjRI/Uq9OgwxyitFmOYaNs/Snh7U7mOReq8JrCZB83/
         Qh5dnSk0aEWQDSZR/R7suxuzMJrr8w94jqLXdszPkbFC2i1zgaKO4IeZ1QwU4n+Jmk
         D3eQ+riqF3/g5tkDwFmybomSohA0Xx8o6iS+2lp21DQAezQcEpjRjWX+rH5hi9BucW
         NBwMEhxS6KSFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 134/149] platform/x86: hp-wmi: Fix 0x05 error code reported by several WMI calls
Date:   Fri,  1 Apr 2022 10:25:21 -0400
Message-Id: <20220401142536.1948161-134-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit be9d73e64957bbd31ee9a0d11adc0f720974c558 ]

Several WMI queries leverage hp_wmi_read_int function to read their
data. hp_wmi_read_int function was corrected in a previous patch.
Now, this function invokes hp_wmi_perform_query with input parameter
of size zero and the output buffer of size 4.

WMI commands calling hp_wmi_perform_query with input buffer size value
of zero are listed below.

HPWMI_DISPLAY_QUERY
HPWMI_HDDTEMP_QUERY
HPWMI_ALS_QUERY
HPWMI_HARDWARE_QUERY
HPWMI_WIRELESS_QUERY
HPWMI_BIOS_QUERY
HPWMI_FEATURE_QUERY
HPWMI_HOTKEY_QUERY
HPWMI_FEATURE2_QUERY
HPWMI_WIRELESS2_QUERY
HPWMI_POSTCODEERROR_QUERY
HPWMI_THERMAL_PROFILE_QUERY
HPWMI_FAN_SPEED_MAX_GET_QUERY

Invoking those WMI commands with an input buffer size greater
than zero will cause error 0x05 to be returned.

All WMI commands executed by the driver were reviewed and changes
were made to ensure the expected input and output buffer size match
the WMI specification.

Changes were validated on a HP ZBook Workstation notebook,
HP EliteBook x360, and HP EliteBook 850 G8.  Additional
validation was included in the test process to ensure no other
commands were incorrectly handled.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20220310210853.28367-4-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index f822ef6eb93c..88f0bfd6ecf1 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -330,7 +330,7 @@ static int hp_wmi_get_fan_speed(int fan)
 	char fan_data[4] = { fan, 0, 0, 0 };
 
 	int ret = hp_wmi_perform_query(HPWMI_FAN_SPEED_GET_QUERY, HPWMI_GM,
-				       &fan_data, sizeof(fan_data),
+				       &fan_data, sizeof(char),
 				       sizeof(fan_data));
 
 	if (ret != 0)
@@ -399,7 +399,7 @@ static int omen_thermal_profile_set(int mode)
 		return -EINVAL;
 
 	ret = hp_wmi_perform_query(HPWMI_SET_PERFORMANCE_MODE, HPWMI_GM,
-				   &buffer, sizeof(buffer), sizeof(buffer));
+				   &buffer, sizeof(buffer), 0);
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -436,7 +436,7 @@ static int hp_wmi_fan_speed_max_set(int enabled)
 	int ret;
 
 	ret = hp_wmi_perform_query(HPWMI_FAN_SPEED_MAX_SET_QUERY, HPWMI_GM,
-				   &enabled, sizeof(enabled), sizeof(enabled));
+				   &enabled, sizeof(enabled), 0);
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -449,7 +449,7 @@ static int hp_wmi_fan_speed_max_get(void)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(HPWMI_FAN_SPEED_MAX_GET_QUERY, HPWMI_GM,
-				   &val, sizeof(val), sizeof(val));
+				   &val, 0, sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -461,7 +461,7 @@ static int __init hp_wmi_bios_2008_later(void)
 {
 	int state = 0;
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE_QUERY, HPWMI_READ, &state,
-				       sizeof(state), sizeof(state));
+				       0, sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -472,7 +472,7 @@ static int __init hp_wmi_bios_2009_later(void)
 {
 	u8 state[128];
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
-				       sizeof(state), sizeof(state));
+				       0, sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -550,7 +550,7 @@ static int hp_wmi_rfkill2_refresh(void)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   sizeof(state), sizeof(state));
+				   0, sizeof(state));
 	if (err)
 		return err;
 
@@ -639,7 +639,7 @@ static ssize_t als_store(struct device *dev, struct device_attribute *attr,
 		return ret;
 
 	ret = hp_wmi_perform_query(HPWMI_ALS_QUERY, HPWMI_WRITE, &tmp,
-				       sizeof(tmp), sizeof(tmp));
+				       sizeof(tmp), 0);
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
 
@@ -660,9 +660,9 @@ static ssize_t postcode_store(struct device *dev, struct device_attribute *attr,
 	if (clear == false)
 		return -EINVAL;
 
-	/* Clear the POST error code. It is kept until until cleared. */
+	/* Clear the POST error code. It is kept until cleared. */
 	ret = hp_wmi_perform_query(HPWMI_POSTCODEERROR_QUERY, HPWMI_WRITE, &tmp,
-				       sizeof(tmp), sizeof(tmp));
+				       sizeof(tmp), 0);
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
 
@@ -952,7 +952,7 @@ static int __init hp_wmi_rfkill2_setup(struct platform_device *device)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   sizeof(state), sizeof(state));
+				   0, sizeof(state));
 	if (err)
 		return err < 0 ? err : -EINVAL;
 
-- 
2.34.1

