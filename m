Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219ED5489DA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385629AbiFMOph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385743AbiFMOnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:43:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA79B36D1;
        Mon, 13 Jun 2022 04:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528D8B80EE7;
        Mon, 13 Jun 2022 11:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DB3C3411B;
        Mon, 13 Jun 2022 11:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121056;
        bh=uhW25EozutZzWs6MSLcekzyeWE4XPsjrZvvnzpYVt2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6M9u1rvUBzKIWh6A7MwW+tW1hoFt8C27HAifYScbzIpVjROMhCVeb+H5zP+QNbkj
         6bKlWm7zb4jJuecaE7blkBVODj1GPEStXxyAUzrCQaxmX5nykjNLY8ZXGR1McWO5ea
         ziPEMJInF0rL6TWrqWyREEjXVIR7zN4FUbIC6h0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bedant Patnaik <bedant.patnaik@gmail.com>,
        Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 256/298] platform/x86: hp-wmi: Use zero insize parameter only when supported
Date:   Mon, 13 Jun 2022 12:12:30 +0200
Message-Id: <20220613094932.841909472@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bedant Patnaik <bedant.patnaik@gmail.com>

[ Upstream commit 65f936f3535950d2643eac5bf34a735a0e428cdd ]

commit be9d73e64957 ("platform/x86: hp-wmi: Fix 0x05 error code reported by
several WMI calls") and commit 12b19f14a21a ("platform/x86: hp-wmi: Fix
hp_wmi_read_int() reporting error (0x05)") cause ACPI BIOS Error (bug):
Attempt to CreateField of length zero (20211217/dsopcode-133) because of
the ACPI method HWMC, which unconditionally creates a Field of
size (insize*8) bits:
	CreateField (Arg1, 0x80, (Local5 * 0x08), DAIN)
In cases where args->insize = 0, the Field size is 0, resulting in
an error.

Fix this by using zero insize only if 0x5 error code is returned

Tested on Omen 15 AMD (2020) board ID: 8786.

Fixes: be9d73e64957 ("platform/x86: hp-wmi: Fix 0x05 error code reported by several WMI calls")
Signed-off-by: Bedant Patnaik <bedant.patnaik@gmail.com>
Tested-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/41be46743d21c78741232a47bbb5f1cdbcc3d21e.camel@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 29ae35d15a41..c573bfd9ab0e 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -38,6 +38,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_EVENT_GUID "95F24279-4D7B-4334-9387-ACCDC67EF61C"
 #define HPWMI_BIOS_GUID "5FB7F034-2C63-45e9-BE91-3D44E2C707E4"
 #define HP_OMEN_EC_THERMAL_PROFILE_OFFSET 0x95
+#define zero_if_sup(tmp) (zero_insize_support?0:sizeof(tmp)) // use when zero insize is required
 
 /* DMI board names of devices that should use the omen specific path for
  * thermal profiles.
@@ -200,6 +201,7 @@ static struct input_dev *hp_wmi_input_dev;
 static struct platform_device *hp_wmi_platform_dev;
 static struct platform_profile_handler platform_profile_handler;
 static bool platform_profile_support;
+static bool zero_insize_support;
 
 static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
@@ -347,7 +349,7 @@ static int hp_wmi_read_int(int query)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(query, HPWMI_READ, &val,
-				   0, sizeof(val));
+				   zero_if_sup(val), sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -383,7 +385,8 @@ static int hp_wmi_get_tablet_mode(void)
 		return -ENODEV;
 
 	ret = hp_wmi_perform_query(HPWMI_SYSTEM_DEVICE_MODE, HPWMI_READ,
-				   system_device_mode, 0, sizeof(system_device_mode));
+				   system_device_mode, zero_if_sup(system_device_mode),
+				   sizeof(system_device_mode));
 	if (ret < 0)
 		return ret;
 
@@ -449,7 +452,7 @@ static int hp_wmi_fan_speed_max_get(void)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(HPWMI_FAN_SPEED_MAX_GET_QUERY, HPWMI_GM,
-				   &val, 0, sizeof(val));
+				   &val, zero_if_sup(val), sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -461,7 +464,7 @@ static int __init hp_wmi_bios_2008_later(void)
 {
 	int state = 0;
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE_QUERY, HPWMI_READ, &state,
-				       0, sizeof(state));
+				       zero_if_sup(state), sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -472,7 +475,7 @@ static int __init hp_wmi_bios_2009_later(void)
 {
 	u8 state[128];
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
-				       0, sizeof(state));
+				       zero_if_sup(state), sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -550,7 +553,7 @@ static int hp_wmi_rfkill2_refresh(void)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   zero_if_sup(state), sizeof(state));
 	if (err)
 		return err;
 
@@ -952,7 +955,7 @@ static int __init hp_wmi_rfkill2_setup(struct platform_device *device)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   zero_if_sup(state), sizeof(state));
 	if (err)
 		return err < 0 ? err : -EINVAL;
 
@@ -1410,11 +1413,15 @@ static int __init hp_wmi_init(void)
 {
 	int event_capable = wmi_has_guid(HPWMI_EVENT_GUID);
 	int bios_capable = wmi_has_guid(HPWMI_BIOS_GUID);
-	int err;
+	int err, tmp = 0;
 
 	if (!bios_capable && !event_capable)
 		return -ENODEV;
 
+	if (hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, HPWMI_READ, &tmp,
+				 sizeof(tmp), sizeof(tmp)) == HPWMI_RET_INVALID_PARAMETERS)
+		zero_insize_support = true;
+
 	if (event_capable) {
 		err = hp_wmi_input_setup();
 		if (err)
-- 
2.35.1



