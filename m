Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D8E34CA8C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhC2Iix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234882AbhC2Iha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43ED261581;
        Mon, 29 Mar 2021 08:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007020;
        bh=IJNgelM50h95wEQJOuS/zBn3+TZ9z3APLfoIBV8bF0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCIQfQ2rr8fkDkCf7UYDYSFn7Ny98Fj2qUns+G54wTzIeHI3X27hWW+uBWlu6rqQg
         AhKZ4QK1dZQSdjqxIFW0rGMVggtu+LNXGreiZjFxU7qB5kAoxiGk7ThC2bCKE9R04y
         fQqS7Vh8kYl47RNKdobZmi/6aZlsA0vj9dDIiB34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Alexander Naumann <alexandernaumann@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 190/254] platform/x86: dell-wmi-sysman: Fix possible NULL pointer deref on exit
Date:   Mon, 29 Mar 2021 09:58:26 +0200
Message-Id: <20210329075639.363754680@linuxfoundation.org>
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

[ Upstream commit c59ab4cedab70a1a117a2dba3c48bb78e66c55ca ]

It is possible for release_attributes_data() to get called when the
main_dir_kset has not been created yet, move the removal of the bios-reset
sysfs attr to under a if (main_dir_kset) check to avoid a NULL pointer
deref.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Reported-by: Alexander Naumann <alexandernaumann@gmx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index c1997db74cca..8b251b2c37a2 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -225,12 +225,6 @@ static int create_attributes_level_sysfs_files(void)
 	return ret;
 }
 
-static void release_reset_bios_data(void)
-{
-	sysfs_remove_file(&wmi_priv.main_dir_kset->kobj, &reset_bios.attr);
-	sysfs_remove_file(&wmi_priv.main_dir_kset->kobj, &pending_reboot.attr);
-}
-
 static ssize_t wmi_sysman_attr_show(struct kobject *kobj, struct attribute *attr,
 				    char *buf)
 {
@@ -373,8 +367,6 @@ static void destroy_attribute_objs(struct kset *kset)
  */
 static void release_attributes_data(void)
 {
-	release_reset_bios_data();
-
 	mutex_lock(&wmi_priv.mutex);
 	exit_enum_attributes();
 	exit_int_attributes();
@@ -386,12 +378,13 @@ static void release_attributes_data(void)
 		wmi_priv.authentication_dir_kset = NULL;
 	}
 	if (wmi_priv.main_dir_kset) {
+		sysfs_remove_file(&wmi_priv.main_dir_kset->kobj, &reset_bios.attr);
+		sysfs_remove_file(&wmi_priv.main_dir_kset->kobj, &pending_reboot.attr);
 		destroy_attribute_objs(wmi_priv.main_dir_kset);
 		kset_unregister(wmi_priv.main_dir_kset);
 		wmi_priv.main_dir_kset = NULL;
 	}
 	mutex_unlock(&wmi_priv.mutex);
-
 }
 
 /**
-- 
2.30.1



