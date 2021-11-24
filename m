Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A61145C51E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352567AbhKXNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354766AbhKXNxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:53:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D915F61391;
        Wed, 24 Nov 2021 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759122;
        bh=rs1tjDI+lPEIwDDqeP9b+T11WSNtJgnx6qfYP84wn90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxyMX0Orcy31awKkFF72u+CeV4sbHiDMeIESCMeizMogLWZlQ+Pjm+CICsMPF92wE
         a9zFcjUY80chLK50yjhcULmiFfLdoVJ/UixM/CF0lPIpaJhP8oqxW2E0DNkuCYvBsQ
         WtfCDqfCEk/zE84xTjntoF78qHTnYvzR98HiY1kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/279] platform/x86: think-lmi: Abort probe on analyze failure
Date:   Wed, 24 Nov 2021 12:57:06 +0100
Message-Id: <20211124115723.589026988@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 812fcc609502096e98cc3918a4b807722dba8fd9 ]

A Lenovo ThinkStation S20 (4157CTO BIOS 60KT41AUS) fails to boot on
recent kernels including the think-lmi driver, due to the fact that
errors returned by the tlmi_analyze() function are ignored by
tlmi_probe(), where  tlmi_sysfs_init() is called unconditionally.
This results in making use of an array of already freed, non-null
pointers and other uninitialized globals, causing all sorts of nasty
kobject and memory faults.

Make use of the analyze function return value, free a couple leaked
allocations, and remove the settings_count field, which is incremented
but never consumed.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Mark Gross <markgross@kernel.org>
Reviewed-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/163639463588.1330483.15850167112490200219.stgit@omen
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 13 ++++++++++---
 drivers/platform/x86/think-lmi.h |  1 -
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 9472aae72df29..c4d9c45350f7c 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -888,8 +888,10 @@ static int tlmi_analyze(void)
 			break;
 		if (!item)
 			break;
-		if (!*item)
+		if (!*item) {
+			kfree(item);
 			continue;
+		}
 
 		/* It is not allowed to have '/' for file name. Convert it into '\'. */
 		strreplace(item, '/', '\\');
@@ -902,6 +904,7 @@ static int tlmi_analyze(void)
 		setting = kzalloc(sizeof(*setting), GFP_KERNEL);
 		if (!setting) {
 			ret = -ENOMEM;
+			kfree(item);
 			goto fail_clear_attr;
 		}
 		setting->index = i;
@@ -916,7 +919,6 @@ static int tlmi_analyze(void)
 		}
 		kobject_init(&setting->kobj, &tlmi_attr_setting_ktype);
 		tlmi_priv.setting[i] = setting;
-		tlmi_priv.settings_count++;
 		kfree(item);
 	}
 
@@ -983,7 +985,12 @@ static void tlmi_remove(struct wmi_device *wdev)
 
 static int tlmi_probe(struct wmi_device *wdev, const void *context)
 {
-	tlmi_analyze();
+	int ret;
+
+	ret = tlmi_analyze();
+	if (ret)
+		return ret;
+
 	return tlmi_sysfs_init();
 }
 
diff --git a/drivers/platform/x86/think-lmi.h b/drivers/platform/x86/think-lmi.h
index f8e26823075fd..2ce5086a5af27 100644
--- a/drivers/platform/x86/think-lmi.h
+++ b/drivers/platform/x86/think-lmi.h
@@ -55,7 +55,6 @@ struct tlmi_attr_setting {
 struct think_lmi {
 	struct wmi_device *wmi_device;
 
-	int settings_count;
 	bool can_set_bios_settings;
 	bool can_get_bios_selections;
 	bool can_set_bios_password;
-- 
2.33.0



