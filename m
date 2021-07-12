Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504D63C4563
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhGLGZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235148AbhGLGYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B4561151;
        Mon, 12 Jul 2021 06:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070878;
        bh=rNG5DcWA9KDHMgAglAzkWJWc5snz95lOb8j/k4helOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns4VpueGZt/0Gru+if0uxQ2pKaRM1K0I2HrcgHYgLco9zaglyXYqKWQnaM+I6OMzz
         IGXOza5GzWO9qfyOgdP5pIlaZzKSdOe8Bw2eY0RuDxNrmjapvoiQkcwwfjy0sCELn/
         n7Pq4X1GGNNlryGO+HjKlaS0GVq215W2STmovG0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/348] ACPI: bgrt: Fix CFI violation
Date:   Mon, 12 Jul 2021 08:09:24 +0200
Message-Id: <20210712060724.774999925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f37ccf8fce155d08ae2a4fb3db677911ced0c21a ]

clang's Control Flow Integrity requires that every indirect call has a
valid target, which is based on the type of the function pointer. The
*_show() functions in this file are written as if they will be called
from dev_attr_show(); however, they will be called from
sysfs_kf_seq_show() because the files were created by
sysfs_create_group() and the sysfs ops are based on kobj_sysfs_ops
because of kobject_add_and_create(). Because the *_show() functions do
not match the type of the show() member in struct kobj_attribute, there
is a CFI violation.

$ cat /sys/firmware/acpi/bgrt/{status,type,version,{x,y}offset}}
1
0
1
522
307

$ dmesg | grep "CFI failure"
[  267.761825] CFI failure (target: type_show.d5e1ad21498a5fd14edbc5c320906598.cfi_jt+0x0/0x8):
[  267.762246] CFI failure (target: xoffset_show.d5e1ad21498a5fd14edbc5c320906598.cfi_jt+0x0/0x8):
[  267.762584] CFI failure (target: status_show.d5e1ad21498a5fd14edbc5c320906598.cfi_jt+0x0/0x8):
[  267.762973] CFI failure (target: yoffset_show.d5e1ad21498a5fd14edbc5c320906598.cfi_jt+0x0/0x8):
[  267.763330] CFI failure (target: version_show.d5e1ad21498a5fd14edbc5c320906598.cfi_jt+0x0/0x8):

Convert these functions to the type of the show() member in struct
kobj_attribute so that there is no more CFI violation. Because these
functions are all so similar, combine them into a macro.

Fixes: d1ff4b1cdbab ("ACPI: Add support for exposing BGRT data")
Link: https://github.com/ClangBuiltLinux/linux/issues/1406
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bgrt.c | 57 ++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 19bb7f870204..e0d14017706e 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -15,40 +15,19 @@
 static void *bgrt_image;
 static struct kobject *bgrt_kobj;
 
-static ssize_t version_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.version);
-}
-static DEVICE_ATTR_RO(version);
-
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.status);
-}
-static DEVICE_ATTR_RO(status);
-
-static ssize_t type_show(struct device *dev,
-			 struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_type);
-}
-static DEVICE_ATTR_RO(type);
-
-static ssize_t xoffset_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_x);
-}
-static DEVICE_ATTR_RO(xoffset);
-
-static ssize_t yoffset_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_y);
-}
-static DEVICE_ATTR_RO(yoffset);
+#define BGRT_SHOW(_name, _member) \
+	static ssize_t _name##_show(struct kobject *kobj,			\
+				    struct kobj_attribute *attr, char *buf)	\
+	{									\
+		return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab._member);	\
+	}									\
+	struct kobj_attribute bgrt_attr_##_name = __ATTR_RO(_name)
+
+BGRT_SHOW(version, version);
+BGRT_SHOW(status, status);
+BGRT_SHOW(type, image_type);
+BGRT_SHOW(xoffset, image_offset_x);
+BGRT_SHOW(yoffset, image_offset_y);
 
 static ssize_t image_read(struct file *file, struct kobject *kobj,
 	       struct bin_attribute *attr, char *buf, loff_t off, size_t count)
@@ -60,11 +39,11 @@ static ssize_t image_read(struct file *file, struct kobject *kobj,
 static BIN_ATTR_RO(image, 0);	/* size gets filled in later */
 
 static struct attribute *bgrt_attributes[] = {
-	&dev_attr_version.attr,
-	&dev_attr_status.attr,
-	&dev_attr_type.attr,
-	&dev_attr_xoffset.attr,
-	&dev_attr_yoffset.attr,
+	&bgrt_attr_version.attr,
+	&bgrt_attr_status.attr,
+	&bgrt_attr_type.attr,
+	&bgrt_attr_xoffset.attr,
+	&bgrt_attr_yoffset.attr,
 	NULL,
 };
 
-- 
2.30.2



