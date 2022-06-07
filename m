Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C5A540EFF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352136AbiFGS7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354973AbiFGS5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB77B14CDFF;
        Tue,  7 Jun 2022 11:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDB7B82182;
        Tue,  7 Jun 2022 18:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504EFC385A5;
        Tue,  7 Jun 2022 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625052;
        bh=54fPIN8G1JovSP05z2k3xNR+dvWsXyhzfXkHCXyejmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5IxWlJhZFfUUtO8THbU5FO2dVvLDqDUil3gAElWVM0fCZmzQSqJElVAYf37OonUQ
         xpxC05FCtnJm6NLZEUaIr9TaFcvwWU5u5fbTb4N4LAn0UX6dJiQPn92CLKgikcOk27
         0LKyD+H+Z0yYeeED+jFikBJZNTv2kbhwo6VMsuP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 549/667] ACPI: property: Release subnode properties with data nodes
Date:   Tue,  7 Jun 2022 19:03:34 +0200
Message-Id: <20220607164951.166481772@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3bd561e1572ee02a50cd1a5be339abf1a5b78d56 upstream.

struct acpi_device_properties describes one source of properties present
on either struct acpi_device or struct acpi_data_node. When properties are
parsed, both are populated but when released, only those properties that
are associated with the device node are freed.

Fix this by also releasing memory of the data node properties.

Fixes: 5f5e4890d57a ("ACPI / property: Allow multiple property compatible _DSD entries")
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -433,6 +433,16 @@ void acpi_init_properties(struct acpi_de
 		acpi_extract_apple_properties(adev);
 }
 
+static void acpi_free_device_properties(struct list_head *list)
+{
+	struct acpi_device_properties *props, *tmp;
+
+	list_for_each_entry_safe(props, tmp, list, list) {
+		list_del(&props->list);
+		kfree(props);
+	}
+}
+
 static void acpi_destroy_nondev_subnodes(struct list_head *list)
 {
 	struct acpi_data_node *dn, *next;
@@ -445,22 +455,18 @@ static void acpi_destroy_nondev_subnodes
 		wait_for_completion(&dn->kobj_done);
 		list_del(&dn->sibling);
 		ACPI_FREE((void *)dn->data.pointer);
+		acpi_free_device_properties(&dn->data.properties);
 		kfree(dn);
 	}
 }
 
 void acpi_free_properties(struct acpi_device *adev)
 {
-	struct acpi_device_properties *props, *tmp;
-
 	acpi_destroy_nondev_subnodes(&adev->data.subnodes);
 	ACPI_FREE((void *)adev->data.pointer);
 	adev->data.of_compatible = NULL;
 	adev->data.pointer = NULL;
-	list_for_each_entry_safe(props, tmp, &adev->data.properties, list) {
-		list_del(&props->list);
-		kfree(props);
-	}
+	acpi_free_device_properties(&adev->data.properties);
 }
 
 /**


