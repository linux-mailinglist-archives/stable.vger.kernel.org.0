Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D644451318
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347778AbhKOTqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245330AbhKOTUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A926263345;
        Mon, 15 Nov 2021 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001166;
        bh=+vlmXETn4KzWYzIoABm278j6u+g5LO+u0OFh/n778Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvM05t7xSsTeJ5HlCl26tqgec6FVXJRdfcQ3/9avJkOm1Jd3Y/YbBf5m2cHQVuPHZ
         gF9mxDJrZPzQFYTGEU/Ao65eH0WZJ9JeZ+0tXa96ci231+Vj92XBkxklZMnckLWNeU
         hNxvYaTf968aQknpe93akiXlibroWducjN0B9F08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 085/917] platform/surface: aggregator_registry: Add support for Surface Laptop Studio
Date:   Mon, 15 Nov 2021 17:53:00 +0100
Message-Id: <20211115165431.643122646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit 4f042e40199ce8bac6bc2b853e81744ee4ea759c upstream.

Add support for the Surface Laptop Studio.

In contrast to previous Surface Laptop models, this one has its HID
devices attached to target ID 1 (instead of 2). It also has a couple
more of them, including a new notifier for when the pen is stashed /
taken out of its place, a "Sys Control" device, and two other
unidentified HID devices with unknown usages.

Battery and performance profile interfaces remain the same.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20211021130904.862610-2-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/surface_aggregator_registry.c |   54 +++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -77,6 +77,42 @@ static const struct software_node ssam_n
 	.parent = &ssam_node_root,
 };
 
+/* HID keyboard (TID1). */
+static const struct software_node ssam_node_hid_tid1_keyboard = {
+	.name = "ssam:01:15:01:01:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID pen stash (TID1; pen taken / stashed away evens). */
+static const struct software_node ssam_node_hid_tid1_penstash = {
+	.name = "ssam:01:15:01:02:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID touchpad (TID1). */
+static const struct software_node ssam_node_hid_tid1_touchpad = {
+	.name = "ssam:01:15:01:03:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID device instance 6 (TID1, unknown HID device). */
+static const struct software_node ssam_node_hid_tid1_iid6 = {
+	.name = "ssam:01:15:01:06:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID device instance 7 (TID1, unknown HID device). */
+static const struct software_node ssam_node_hid_tid1_iid7 = {
+	.name = "ssam:01:15:01:07:00",
+	.parent = &ssam_node_root,
+};
+
+/* HID system controls (TID1). */
+static const struct software_node ssam_node_hid_tid1_sysctrl = {
+	.name = "ssam:01:15:01:08:00",
+	.parent = &ssam_node_root,
+};
+
 /* HID keyboard. */
 static const struct software_node ssam_node_hid_main_keyboard = {
 	.name = "ssam:01:15:02:01:00",
@@ -159,6 +195,21 @@ static const struct software_node *ssam_
 	NULL,
 };
 
+/* Devices for Surface Laptop Studio. */
+static const struct software_node *ssam_node_group_sls[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_pprof,
+	&ssam_node_hid_tid1_keyboard,
+	&ssam_node_hid_tid1_penstash,
+	&ssam_node_hid_tid1_touchpad,
+	&ssam_node_hid_tid1_iid6,
+	&ssam_node_hid_tid1_iid7,
+	&ssam_node_hid_tid1_sysctrl,
+	NULL,
+};
+
 /* Devices for Surface Laptop Go. */
 static const struct software_node *ssam_node_group_slg1[] = {
 	&ssam_node_root,
@@ -507,6 +558,9 @@ static const struct acpi_device_id ssam_
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Studio */
+	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
+
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, ssam_platform_hub_match);


