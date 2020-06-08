Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9950E1F2F95
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgFHXKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbgFHXKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C17214F1;
        Mon,  8 Jun 2020 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657814;
        bh=aAJYvm9d6p5eO8dZlrOnhcqUZPhDSrpeh5Xn8NraI1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4EiJ4Aa9art/OcN1e+Ro7TpC7JKLxd+oHj64pUT1Yb7SlaUw3C9jJo+jWfEPXukh
         bVuXWnFuuulSl2uyDuf872AhFx77ToIn+SbLPWSD4T/7Z2Qmff1lBpjja2wnxXT3Nm
         oUW8W2Zjgg7JDyz+jxvkHlXBUAr/mUoO4WhQwOgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mattia Dongili <malattia@linux.it>,
        Dominik Mierzejewski <dominik@greysector.net>,
        William Bader <williambader@hotmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 189/274] platform/x86: sony-laptop: SNC calls should handle BUFFER types
Date:   Mon,  8 Jun 2020 19:04:42 -0400
Message-Id: <20200608230607.3361041-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattia Dongili <malattia@linux.it>

[ Upstream commit 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef ]

After commit 6d232b29cfce ("ACPICA: Dispatcher: always generate buffer
objects for ASL create_field() operator") ACPICA creates buffers even
when new fields are small enough to fit into an integer.
Many SNC calls counted on the old behaviour.
Since sony-laptop already handles the INTEGER/BUFFER case in
sony_nc_buffer_call, switch sony_nc_int_call to use its more generic
function instead.

Fixes: 6d232b29cfce ("ACPICA: Dispatcher: always generate buffer objects for ASL create_field() operator")
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207491
Reported-by: William Bader <williambader@hotmail.com>
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1830150
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/sony-laptop.c | 53 +++++++++++++-----------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index e4ef3dc3bc2f..e5a1b5533408 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,33 +757,6 @@ static union acpi_object *__call_snc_method(acpi_handle handle, char *method,
 	return result;
 }
 
-static int sony_nc_int_call(acpi_handle handle, char *name, int *value,
-		int *result)
-{
-	union acpi_object *object = NULL;
-	if (value) {
-		u64 v = *value;
-		object = __call_snc_method(handle, name, &v);
-	} else
-		object = __call_snc_method(handle, name, NULL);
-
-	if (!object)
-		return -EINVAL;
-
-	if (object->type != ACPI_TYPE_INTEGER) {
-		pr_warn("Invalid acpi_object: expected 0x%x got 0x%x\n",
-				ACPI_TYPE_INTEGER, object->type);
-		kfree(object);
-		return -EINVAL;
-	}
-
-	if (result)
-		*result = object->integer.value;
-
-	kfree(object);
-	return 0;
-}
-
 #define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
@@ -795,17 +768,20 @@ static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 	if (!object)
 		return -EINVAL;
 
-	if (object->type == ACPI_TYPE_BUFFER) {
+	if (!buffer) {
+		/* do nothing */
+	} else if (object->type == ACPI_TYPE_BUFFER) {
 		len = MIN(buflen, object->buffer.length);
+		memset(buffer, 0, buflen);
 		memcpy(buffer, object->buffer.pointer, len);
 
 	} else if (object->type == ACPI_TYPE_INTEGER) {
 		len = MIN(buflen, sizeof(object->integer.value));
+		memset(buffer, 0, buflen);
 		memcpy(buffer, &object->integer.value, len);
 
 	} else {
-		pr_warn("Invalid acpi_object: expected 0x%x got 0x%x\n",
-				ACPI_TYPE_BUFFER, object->type);
+		pr_warn("Unexpected acpi_object: 0x%x\n", object->type);
 		ret = -EINVAL;
 	}
 
@@ -813,6 +789,23 @@ static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 	return ret;
 }
 
+static int sony_nc_int_call(acpi_handle handle, char *name, int *value, int
+		*result)
+{
+	int ret;
+
+	if (value) {
+		u64 v = *value;
+
+		ret = sony_nc_buffer_call(handle, name, &v, result,
+				sizeof(*result));
+	} else {
+		ret =  sony_nc_buffer_call(handle, name, NULL, result,
+				sizeof(*result));
+	}
+	return ret;
+}
+
 struct sony_nc_handles {
 	u16 cap[0x10];
 	struct device_attribute devattr;
-- 
2.25.1

