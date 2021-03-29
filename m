Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564B434CA8E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhC2Ii6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234901AbhC2Ihd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E294E61580;
        Mon, 29 Mar 2021 08:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007029;
        bh=rZ64PLhtiDQUCM6CXMPFjdYiGSdWMpLqdSLZoPJqm/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZJfz1tECl59WmABxGADWqK38r9TjRFkjwc20yS0sVd9deCZ2E8jwHMTGul82KhGn
         5FV+wgofn2QxD0Kih/aRSsWkhnibt4hkEdSO+gY62twdPMrT/8P71ykPPBiUxr3a5t
         dlqH+VoQvoq3IVgo+vRA8h/0Wv1TIIfOBzohcSh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 193/254] platform/x86: dell-wmi-sysman: Cleanup sysman_init() error-exit handling
Date:   Mon, 29 Mar 2021 09:58:29 +0200
Message-Id: <20210329075639.454244531@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9c90cd869747e3492a9306dcd8123c17502ff1fc ]

Cleanup sysman_init() error-exit handling:

1. There is no need for the fail_reset_bios and fail_authentication_kset
   eror-exit cases, these can be handled by release_attributes_data()

2. Rename all the labels from fail_what_failed, to err_what_to_cleanup
   this is the usual way to name these and avoids the need to rename
   them when extra steps are added.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 45 +++++++------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index 58dc4571f987..99dc2f3bdf49 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -508,100 +508,87 @@ static int __init sysman_init(void)
 	ret = init_bios_attr_set_interface();
 	if (ret || !wmi_priv.bios_attr_wdev) {
 		pr_debug("failed to initialize set interface\n");
-		goto fail_set_interface;
+		return ret;
 	}
 
 	ret = init_bios_attr_pass_interface();
 	if (ret || !wmi_priv.password_attr_wdev) {
 		pr_debug("failed to initialize pass interface\n");
-		goto fail_pass_interface;
+		goto err_exit_bios_attr_set_interface;
 	}
 
 	ret = class_register(&firmware_attributes_class);
 	if (ret)
-		goto fail_class;
+		goto err_exit_bios_attr_pass_interface;
 
 	wmi_priv.class_dev = device_create(&firmware_attributes_class, NULL, MKDEV(0, 0),
 				  NULL, "%s", DRIVER_NAME);
 	if (IS_ERR(wmi_priv.class_dev)) {
 		ret = PTR_ERR(wmi_priv.class_dev);
-		goto fail_classdev;
+		goto err_unregister_class;
 	}
 
 	wmi_priv.main_dir_kset = kset_create_and_add("attributes", NULL,
 						     &wmi_priv.class_dev->kobj);
 	if (!wmi_priv.main_dir_kset) {
 		ret = -ENOMEM;
-		goto fail_main_kset;
+		goto err_destroy_classdev;
 	}
 
 	wmi_priv.authentication_dir_kset = kset_create_and_add("authentication", NULL,
 								&wmi_priv.class_dev->kobj);
 	if (!wmi_priv.authentication_dir_kset) {
 		ret = -ENOMEM;
-		goto fail_authentication_kset;
+		goto err_release_attributes_data;
 	}
 
 	ret = create_attributes_level_sysfs_files();
 	if (ret) {
 		pr_debug("could not create reset BIOS attribute\n");
-		goto fail_reset_bios;
+		goto err_release_attributes_data;
 	}
 
 	ret = init_bios_attributes(ENUM, DELL_WMI_BIOS_ENUMERATION_ATTRIBUTE_GUID);
 	if (ret) {
 		pr_debug("failed to populate enumeration type attributes\n");
-		goto fail_create_group;
+		goto err_release_attributes_data;
 	}
 
 	ret = init_bios_attributes(INT, DELL_WMI_BIOS_INTEGER_ATTRIBUTE_GUID);
 	if (ret) {
 		pr_debug("failed to populate integer type attributes\n");
-		goto fail_create_group;
+		goto err_release_attributes_data;
 	}
 
 	ret = init_bios_attributes(STR, DELL_WMI_BIOS_STRING_ATTRIBUTE_GUID);
 	if (ret) {
 		pr_debug("failed to populate string type attributes\n");
-		goto fail_create_group;
+		goto err_release_attributes_data;
 	}
 
 	ret = init_bios_attributes(PO, DELL_WMI_BIOS_PASSOBJ_ATTRIBUTE_GUID);
 	if (ret) {
 		pr_debug("failed to populate pass object type attributes\n");
-		goto fail_create_group;
+		goto err_release_attributes_data;
 	}
 
 	return 0;
 
-fail_create_group:
+err_release_attributes_data:
 	release_attributes_data();
 
-fail_reset_bios:
-	if (wmi_priv.authentication_dir_kset) {
-		kset_unregister(wmi_priv.authentication_dir_kset);
-		wmi_priv.authentication_dir_kset = NULL;
-	}
-
-fail_authentication_kset:
-	if (wmi_priv.main_dir_kset) {
-		kset_unregister(wmi_priv.main_dir_kset);
-		wmi_priv.main_dir_kset = NULL;
-	}
-
-fail_main_kset:
+err_destroy_classdev:
 	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 
-fail_classdev:
+err_unregister_class:
 	class_unregister(&firmware_attributes_class);
 
-fail_class:
+err_exit_bios_attr_pass_interface:
 	exit_bios_attr_pass_interface();
 
-fail_pass_interface:
+err_exit_bios_attr_set_interface:
 	exit_bios_attr_set_interface();
 
-fail_set_interface:
 	return ret;
 }
 
-- 
2.30.1



