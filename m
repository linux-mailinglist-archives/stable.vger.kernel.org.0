Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A060F1FB99D
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731699AbgFPQFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgFPPsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FC021475;
        Tue, 16 Jun 2020 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322534;
        bh=y8cfdbQibXcJDfHzrqAL9SwyOZYbGVxecBSRh0btBE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBNFSGkGEVdnCptAmetj9bBORrwGQSWtVh8d/TW4DHml9UQkSW9aKSvRyPt2mNQfi
         EVPSFIGYJxiDbJdhfA6BuUM9c36a6s/CD1UhOTv99AQsN9A5AW04mT3VYbCcPxtleV
         PRssCnVE8bU07MiMJbR0DzanZ00qzlIaEB0uM0q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Mierzejewski <dominik@greysector.net>,
        William Bader <williambader@hotmail.com>,
        Mattia Dongili <malattia@linux.it>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 160/163] platform/x86: sony-laptop: SNC calls should handle BUFFER types
Date:   Tue, 16 Jun 2020 17:35:34 +0200
Message-Id: <20200616153114.470282930@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattia Dongili <malattia@linux.it>

commit 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |   53 ++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,33 +757,6 @@ static union acpi_object *__call_snc_met
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
@@ -795,17 +768,20 @@ static int sony_nc_buffer_call(acpi_hand
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
 
@@ -813,6 +789,23 @@ static int sony_nc_buffer_call(acpi_hand
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


