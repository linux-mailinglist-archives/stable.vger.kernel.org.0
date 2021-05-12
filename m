Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BD37CC40
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhELQnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243125AbhELQgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DB4561CC6;
        Wed, 12 May 2021 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835250;
        bh=36XL0zMbkgte9Ebs76dOv6AylxsdfBIJAAGFW+04kM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po3PjGm1+DIvxpUH9oYxvByMUTELVB402SJMyfWXQ80AvranciUhDPvuWusWacvuJ
         1q23WYUWvFwZaNghK7xYb4Ysbze0dDlf8ua2sLQXaj3bJeHGCnCyZMOz1iG1TQdVpB
         1EmpHFY/1Dy8BLBFQcnDq9LVcpUy+Hc2r/JYPlVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 269/677] platform/x86: dell-wmi-sysman: Make init_bios_attributes() ACPI object parsing more robust
Date:   Wed, 12 May 2021 16:45:15 +0200
Message-Id: <20210512144846.165015661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5e3f5973c8dfd2b80268f1825ed2f2ddf81d3267 ]

Make init_bios_attributes() ACPI object parsing more robust:
1. Always check that the type of the return ACPI object is package, rather
   then only checking this for instance_id == 0
2. Check that the package has the minimum amount of elements which will
   be consumed by the populate_foo_data() for the attr_type

Note/TODO: The populate_foo_data() functions should also be made more
robust. The should check the type of each of the elements matches the
type which they expect and in case of populate_enum_data()
obj->package.count should be passed to it as an argument and it should
re-check this itself since it consume a variable number of elements.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321121607.35717-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/dell/dell-wmi-sysman/sysman.c         | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index 7410ccae650c..a90ae6ba4a73 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -399,6 +399,7 @@ static int init_bios_attributes(int attr_type, const char *guid)
 	union acpi_object *obj = NULL;
 	union acpi_object *elements;
 	struct kset *tmp_set;
+	int min_elements;
 
 	/* instance_id needs to be reset for each type GUID
 	 * also, instance IDs are unique within GUID but not across
@@ -409,14 +410,38 @@ static int init_bios_attributes(int attr_type, const char *guid)
 	retval = alloc_attributes_data(attr_type);
 	if (retval)
 		return retval;
+
+	switch (attr_type) {
+	case ENUM:	min_elements = 8;	break;
+	case INT:	min_elements = 9;	break;
+	case STR:	min_elements = 8;	break;
+	case PO:	min_elements = 4;	break;
+	default:
+		pr_err("Error: Unknown attr_type: %d\n", attr_type);
+		return -EINVAL;
+	}
+
 	/* need to use specific instance_id and guid combination to get right data */
 	obj = get_wmiobj_pointer(instance_id, guid);
-	if (!obj || obj->type != ACPI_TYPE_PACKAGE)
+	if (!obj)
 		return -ENODEV;
-	elements = obj->package.elements;
 
 	mutex_lock(&wmi_priv.mutex);
-	while (elements) {
+	while (obj) {
+		if (obj->type != ACPI_TYPE_PACKAGE) {
+			pr_err("Error: Expected ACPI-package type, got: %d\n", obj->type);
+			retval = -EIO;
+			goto err_attr_init;
+		}
+
+		if (obj->package.count < min_elements) {
+			pr_err("Error: ACPI-package does not have enough elements: %d < %d\n",
+			       obj->package.count, min_elements);
+			goto nextobj;
+		}
+
+		elements = obj->package.elements;
+
 		/* sanity checking */
 		if (elements[ATTR_NAME].type != ACPI_TYPE_STRING) {
 			pr_debug("incorrect element type\n");
@@ -481,7 +506,6 @@ nextobj:
 		kfree(obj);
 		instance_id++;
 		obj = get_wmiobj_pointer(instance_id, guid);
-		elements = obj ? obj->package.elements : NULL;
 	}
 
 	mutex_unlock(&wmi_priv.mutex);
-- 
2.30.2



