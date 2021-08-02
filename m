Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077233DD8D2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhHBNzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhHBNyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6168E61158;
        Mon,  2 Aug 2021 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912360;
        bh=rhU+x3Q+q9wRUeuLNNUDEwueUlY9MyUsE1nn2CaTkp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gi2vWv1cs78/FcFtgbjVOlGiWUEn3y6MdSgHfjb4DDZq2zgMRG//HvO4BtHuXu71H
         GuM19TamW+91c37CwOibPUt6Qab3zp+W/FeOU0N/WkTyYu1cSfiDj0xNHCQhIB8HFR
         N3Cs5iE8bCvk95U6bF52Aor6dmwofkrfWtpaZw6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 07/67] ACPI: DPTF: Fix reading of attributes
Date:   Mon,  2 Aug 2021 15:44:30 +0200
Message-Id: <20210802134339.270939936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 41a8457f3f6f829be1f8f8fa7577a46b9b7223ef upstream.

The current assumption that methods to read PCH FIVR attributes will
return integer, is not correct. There is no good way to return integer
as negative numbers are also valid.

These read methods return a package of integers. The first integer returns
status, which is 0 on success and any other value for failure. When the
returned status is zero, then the second integer returns the actual value.

This change fixes this issue by replacing acpi_evaluate_integer() with
acpi_evaluate_object() and use acpi_extract_package() to extract results.

Fixes: 2ce6324eadb01 ("ACPI: DPTF: Add PCH FIVR participant driver")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/dptf/dptf_pch_fivr.c |   51 ++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

--- a/drivers/acpi/dptf/dptf_pch_fivr.c
+++ b/drivers/acpi/dptf/dptf_pch_fivr.c
@@ -9,6 +9,42 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
+struct pch_fivr_resp {
+	u64 status;
+	u64 result;
+};
+
+static int pch_fivr_read(acpi_handle handle, char *method, struct pch_fivr_resp *fivr_resp)
+{
+	struct acpi_buffer resp = { sizeof(struct pch_fivr_resp), fivr_resp};
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer format = { sizeof("NN"), "NN" };
+	union acpi_object *obj;
+	acpi_status status;
+	int ret = -EFAULT;
+
+	status = acpi_evaluate_object(handle, method, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return ret;
+
+	obj = buffer.pointer;
+	if (!obj || obj->type != ACPI_TYPE_PACKAGE)
+		goto release_buffer;
+
+	status = acpi_extract_package(obj, &format, &resp);
+	if (ACPI_FAILURE(status))
+		goto release_buffer;
+
+	if (fivr_resp->status)
+		goto release_buffer;
+
+	ret = 0;
+
+release_buffer:
+	kfree(buffer.pointer);
+	return ret;
+}
+
 /*
  * Presentation of attributes which are defined for INT1045
  * They are:
@@ -23,15 +59,14 @@ static ssize_t name##_show(struct device
 			   char *buf)\
 {\
 	struct acpi_device *acpi_dev = dev_get_drvdata(dev);\
-	unsigned long long val;\
-	acpi_status status;\
+	struct pch_fivr_resp fivr_resp;\
+	int status;\
+\
+	status = pch_fivr_read(acpi_dev->handle, #method, &fivr_resp);\
+	if (status)\
+		return status;\
 \
-	status = acpi_evaluate_integer(acpi_dev->handle, #method,\
-				       NULL, &val);\
-	if (ACPI_SUCCESS(status))\
-		return sprintf(buf, "%d\n", (int)val);\
-	else\
-		return -EINVAL;\
+	return sprintf(buf, "%llu\n", fivr_resp.result);\
 }
 
 #define PCH_FIVR_STORE(name, method) \


