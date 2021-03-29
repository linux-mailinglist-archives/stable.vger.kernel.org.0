Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F07E34CAC3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhC2Iju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:32832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhC2Iic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D632A61580;
        Mon, 29 Mar 2021 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007112;
        bh=L0yof3fYAZhQJATqRhsgBP0IB9pNDg/DsJmCJqCVAyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrrJ/Fb/YL1WcbSp9DFkDNq4l4tRxjEYxS9PMkowzmzUzmPcidralBBANj3XKMbtE
         UwcsLqjMnZZ6if/sL8wx7pUZC25r0M5yfFwCq+Dl/+PJt9EUTPLeTdJUfXrcq6eSA4
         zdO7wuC3uA2MOJwwV50C5q/VzeVMZ5ZmmGFRm4Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 224/254] platform/x86: dell-wmi-sysman: Cleanup create_attributes_level_sysfs_files()
Date:   Mon, 29 Mar 2021 09:59:00 +0200
Message-Id: <20210329075640.449647237@linuxfoundation.org>
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

[ Upstream commit 35471138a9f7193482a2019e39643f575f8098dc ]

Cleanup create_attributes_level_sysfs_files():

1. There is no need to call sysfs_remove_file() on error, sysman_init()
will already call release_attributes_data() on failure which already does
this.

2. There is no need for the pr_debug() calls sysfs_create_file() should
never fail and if it does it will already complain about the problem
itself.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-8-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index 5dd9b29d939c..7410ccae650c 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -210,19 +210,17 @@ static struct kobj_attribute pending_reboot = __ATTR_RO(pending_reboot);
  */
 static int create_attributes_level_sysfs_files(void)
 {
-	int ret = sysfs_create_file(&wmi_priv.main_dir_kset->kobj, &reset_bios.attr);
+	int ret;
 
-	if (ret) {
-		pr_debug("could not create reset_bios file\n");
+	ret = sysfs_create_file(&wmi_priv.main_dir_kset->kobj, &reset_bios.attr);
+	if (ret)
 		return ret;
-	}
 
 	ret = sysfs_create_file(&wmi_priv.main_dir_kset->kobj, &pending_reboot.attr);
-	if (ret) {
-		pr_debug("could not create changing_pending_reboot file\n");
-		sysfs_remove_file(&wmi_priv.main_dir_kset->kobj, &reset_bios.attr);
-	}
-	return ret;
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static ssize_t wmi_sysman_attr_show(struct kobject *kobj, struct attribute *attr,
-- 
2.30.1



