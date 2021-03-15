Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825F533B7F6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhCOOBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232546AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E59D564F34;
        Mon, 15 Mar 2021 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816773;
        bh=SmkaahNmjuMD/+bb5iHDas9E0xh7WN3DAKY9tEEcZ9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaKS+fa0ayhgUge8Pr0/DAOSz5byX2MXE1EF4N55tZeg8kUa9PrZK7Y7zApdK17MI
         IVxCDRTC+UalNnx26aQ3dXG1ZLwCmM8eKWwQYsX6iyIpVZT/1hEr8bpT+CtrK4QTDS
         +IIHebYLrkczMKTATiu/Y5QZv4MrLsKBkzUYxuao=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 106/290] media: rc: compile rc-cec.c into rc-core
Date:   Mon, 15 Mar 2021 14:53:19 +0100
Message-Id: <20210315135545.491077454@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

commit f09f9f93afad770a04b35235a0aa465fcc8d6e3d upstream.

The rc-cec keymap is unusual in that it can't be built as a module,
instead it is registered directly in rc-main.c if CONFIG_MEDIA_CEC_RC
is set. This is because it can be called from drm_dp_cec_set_edid() via
cec_register_adapter() in an asynchronous context, and it is not
allowed to use request_module() to load rc-cec.ko in that case. Trying to
do so results in a 'WARN_ON_ONCE(wait && current_is_async())'.

Since this keymap is only used if CONFIG_MEDIA_CEC_RC is set, we
just compile this keymap into the rc-core module and never as a
separate module.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 2c6d1fffa1d9 (drm: add support for DisplayPort CEC-Tunneling-over-AUX)
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/Makefile         |    1 +
 drivers/media/rc/keymaps/Makefile |    1 -
 drivers/media/rc/keymaps/rc-cec.c |   28 +++++++++++-----------------
 drivers/media/rc/rc-main.c        |    6 ++++++
 include/media/rc-map.h            |    7 +++++++
 5 files changed, 25 insertions(+), 18 deletions(-)

--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -5,6 +5,7 @@ obj-y += keymaps/
 obj-$(CONFIG_RC_CORE) += rc-core.o
 rc-core-y := rc-main.o rc-ir-raw.o
 rc-core-$(CONFIG_LIRC) += lirc_dev.o
+rc-core-$(CONFIG_MEDIA_CEC_RC) += keymaps/rc-cec.o
 rc-core-$(CONFIG_BPF_LIRC_MODE2) += bpf-lirc.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -21,7 +21,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t
 			rc-behold.o \
 			rc-behold-columbus.o \
 			rc-budget-ci-old.o \
-			rc-cec.o \
 			rc-cinergy-1400.o \
 			rc-cinergy.o \
 			rc-d680-dmb.o \
--- a/drivers/media/rc/keymaps/rc-cec.c
+++ b/drivers/media/rc/keymaps/rc-cec.c
@@ -1,6 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* Keytable for the CEC remote control
  *
+ * This keymap is unusual in that it can't be built as a module,
+ * instead it is registered directly in rc-main.c if CONFIG_MEDIA_CEC_RC
+ * is set. This is because it can be called from drm_dp_cec_set_edid() via
+ * cec_register_adapter() in an asynchronous context, and it is not
+ * allowed to use request_module() to load rc-cec.ko in that case.
+ *
+ * Since this keymap is only used if CONFIG_MEDIA_CEC_RC is set, we
+ * just compile this keymap into the rc-core module and never as a
+ * separate module.
+ *
  * Copyright (c) 2015 by Kamil Debski
  */
 
@@ -152,7 +162,7 @@ static struct rc_map_table cec[] = {
 	/* 0x77-0xff: Reserved */
 };
 
-static struct rc_map_list cec_map = {
+struct rc_map_list cec_map = {
 	.map = {
 		.scan		= cec,
 		.size		= ARRAY_SIZE(cec),
@@ -160,19 +170,3 @@ static struct rc_map_list cec_map = {
 		.name		= RC_MAP_CEC,
 	}
 };
-
-static int __init init_rc_map_cec(void)
-{
-	return rc_map_register(&cec_map);
-}
-
-static void __exit exit_rc_map_cec(void)
-{
-	rc_map_unregister(&cec_map);
-}
-
-module_init(init_rc_map_cec);
-module_exit(exit_rc_map_cec);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kamil Debski");
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -2069,6 +2069,9 @@ static int __init rc_core_init(void)
 
 	led_trigger_register_simple("rc-feedback", &led_feedback);
 	rc_map_register(&empty_map);
+#ifdef CONFIG_MEDIA_CEC_RC
+	rc_map_register(&cec_map);
+#endif
 
 	return 0;
 }
@@ -2078,6 +2081,9 @@ static void __exit rc_core_exit(void)
 	lirc_dev_exit();
 	class_unregister(&rc_class);
 	led_trigger_unregister_simple(led_feedback);
+#ifdef CONFIG_MEDIA_CEC_RC
+	rc_map_unregister(&cec_map);
+#endif
 	rc_map_unregister(&empty_map);
 }
 
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -175,6 +175,13 @@ struct rc_map_list {
 	struct rc_map map;
 };
 
+#ifdef CONFIG_MEDIA_CEC_RC
+/*
+ * rc_map_list from rc-cec.c
+ */
+extern struct rc_map_list cec_map;
+#endif
+
 /* Routines from rc-map.c */
 
 /**


