Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3212328C38
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhCASrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240009AbhCASlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:41:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0B965229;
        Mon,  1 Mar 2021 17:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619513;
        bh=URqSUfeg+CbfO1DyDksP7G2pQkvdZe74RRFwn9Tbu2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3Z7GvVUWqZoVCJJ9u1oSk/d1lp8v3H63clRxr7QzyMYCNyVcWGdHlTR+UkafNir8
         9yg85hg3sV0y/ibUWIAzGAoaYi5LN0wM/qqWfKj501iDA8KOzzNZqJF4xE4/bFzsG2
         U+Ex9PNsm1ZuQwEbqOfjYGIr/AmbcObE48hOS33I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 481/663] ACPI: property: Fix fwnode string properties matching
Date:   Mon,  1 Mar 2021 17:12:09 +0100
Message-Id: <20210301161205.661771128@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e1e6bd2995ac0e1ad0c2a2d906a06f59ce2ed293 upstream.

Property matching does not work for ACPI fwnodes if the value of the
given property is not represented as a package in the _DSD package
containing it.  For example, the "compatible" property in the _DSD
below

  Name (_DSD, Package () {
    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
    Package () {
      Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
    }
  })

will not be found by fwnode_property_match_string(), because the ACPI
code handling device properties does not regard the single value as a
"list" in that case.

Namely, fwnode_property_match_string() invoked to match a given
string property value first calls fwnode_property_read_string_array()
with the last two arguments equal to NULL and 0, respectively, in
order to count the items in the value of the given property, with the
assumption that this value may be an array.  For ACPI fwnodes, that
operation is carried out by acpi_node_prop_read() which calls
acpi_data_prop_read() for this purpose.  However, when the return
(val) pointer is NULL, that function only looks for a property whose
value is a package without checking the single-value case at all.

To fix that, make acpi_data_prop_read() check the single-value
case if its return pointer argument is NULL and modify
acpi_data_prop_read_single() handling that case to attempt to
read the value of the property if the return pointer is NULL
and return 1 if that succeeds.

Fixes: 3708184afc77 ("device property: Move FW type specific functionality to FW specific files")
Reported-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc: 4.13+ <stable@vger.kernel.org> # 4.13+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -787,9 +787,6 @@ static int acpi_data_prop_read_single(co
 	const union acpi_object *obj;
 	int ret;
 
-	if (!val)
-		return -EINVAL;
-
 	if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
 		ret = acpi_data_get_property(data, propname, ACPI_TYPE_INTEGER, &obj);
 		if (ret)
@@ -799,28 +796,43 @@ static int acpi_data_prop_read_single(co
 		case DEV_PROP_U8:
 			if (obj->integer.value > U8_MAX)
 				return -EOVERFLOW;
-			*(u8 *)val = obj->integer.value;
+
+			if (val)
+				*(u8 *)val = obj->integer.value;
+
 			break;
 		case DEV_PROP_U16:
 			if (obj->integer.value > U16_MAX)
 				return -EOVERFLOW;
-			*(u16 *)val = obj->integer.value;
+
+			if (val)
+				*(u16 *)val = obj->integer.value;
+
 			break;
 		case DEV_PROP_U32:
 			if (obj->integer.value > U32_MAX)
 				return -EOVERFLOW;
-			*(u32 *)val = obj->integer.value;
+
+			if (val)
+				*(u32 *)val = obj->integer.value;
+
 			break;
 		default:
-			*(u64 *)val = obj->integer.value;
+			if (val)
+				*(u64 *)val = obj->integer.value;
+
 			break;
 		}
+
+		if (!val)
+			return 1;
 	} else if (proptype == DEV_PROP_STRING) {
 		ret = acpi_data_get_property(data, propname, ACPI_TYPE_STRING, &obj);
 		if (ret)
 			return ret;
 
-		*(char **)val = obj->string.pointer;
+		if (val)
+			*(char **)val = obj->string.pointer;
 
 		return 1;
 	} else {
@@ -834,7 +846,7 @@ int acpi_dev_prop_read_single(struct acp
 {
 	int ret;
 
-	if (!adev)
+	if (!adev || !val)
 		return -EINVAL;
 
 	ret = acpi_data_prop_read_single(&adev->data, propname, proptype, val);
@@ -928,10 +940,20 @@ static int acpi_data_prop_read(const str
 	const union acpi_object *items;
 	int ret;
 
-	if (val && nval == 1) {
+	if (nval == 1 || !val) {
 		ret = acpi_data_prop_read_single(data, propname, proptype, val);
-		if (ret >= 0)
+		/*
+		 * The overflow error means that the property is there and it is
+		 * single-value, but its type does not match, so return.
+		 */
+		if (ret >= 0 || ret == -EOVERFLOW)
 			return ret;
+
+		/*
+		 * Reading this property as a single-value one failed, but its
+		 * value may still be represented as one-element array, so
+		 * continue.
+		 */
 	}
 
 	ret = acpi_data_get_property_array(data, propname, ACPI_TYPE_ANY, &obj);


