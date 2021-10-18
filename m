Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752AE431CE2
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhJRNpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhJRNnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF15A61378;
        Mon, 18 Oct 2021 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564093;
        bh=X3ObWkAPaz0Q6ij8Vde/caH4aQ/NT4FzE0Y0IRNZV5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgcaWKZim96S0CT+iEUaH5sXuu5pfE/Z2f3wAi2WIlxrwQj/l2Klku2e50XdYQyDk
         EJPjoprJE3XrQB5+WUzo0M3/xrO59q7Cas0jz3RzhZhJNSE00iD18VXM7kxcQtmO6O
         eALJpsGzSAEp/Bf11zVL22W6AMpFrUHPNxT7NBEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.10 062/103] tee: optee: Fix missing devices unregister during optee_remove
Date:   Mon, 18 Oct 2021 15:24:38 +0200
Message-Id: <20211018132336.839057678@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit 7f565d0ead264329749c0da488de9c8dfa2f18ce upstream.

When OP-TEE driver is built as a module, OP-TEE client devices
registered on TEE bus during probe should be unregistered during
optee_remove. So implement optee_unregister_devices() accordingly.

Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/core.c          |    3 +++
 drivers/tee/optee/device.c        |   22 ++++++++++++++++++++++
 drivers/tee/optee/optee_private.h |    1 +
 3 files changed, 26 insertions(+)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -585,6 +585,9 @@ static int optee_remove(struct platform_
 {
 	struct optee *optee = platform_get_drvdata(pdev);
 
+	/* Unregister OP-TEE specific client devices on TEE bus */
+	optee_unregister_devices();
+
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -53,6 +53,13 @@ static int get_devices(struct tee_contex
 	return 0;
 }
 
+static void optee_release_device(struct device *dev)
+{
+	struct tee_client_device *optee_device = to_tee_client_device(dev);
+
+	kfree(optee_device);
+}
+
 static int optee_register_device(const uuid_t *device_uuid)
 {
 	struct tee_client_device *optee_device = NULL;
@@ -63,6 +70,7 @@ static int optee_register_device(const u
 		return -ENOMEM;
 
 	optee_device->dev.bus = &tee_bus_type;
+	optee_device->dev.release = optee_release_device;
 	if (dev_set_name(&optee_device->dev, "optee-ta-%pUb", device_uuid)) {
 		kfree(optee_device);
 		return -ENOMEM;
@@ -154,3 +162,17 @@ int optee_enumerate_devices(u32 func)
 {
 	return  __optee_enumerate_devices(func);
 }
+
+static int __optee_unregister_device(struct device *dev, void *data)
+{
+	if (!strncmp(dev_name(dev), "optee-ta", strlen("optee-ta")))
+		device_unregister(dev);
+
+	return 0;
+}
+
+void optee_unregister_devices(void)
+{
+	bus_for_each_dev(&tee_bus_type, NULL, NULL,
+			 __optee_unregister_device);
+}
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -184,6 +184,7 @@ void optee_fill_pages_list(u64 *dst, str
 #define PTA_CMD_GET_DEVICES		0x0
 #define PTA_CMD_GET_DEVICES_SUPP	0x1
 int optee_enumerate_devices(u32 func);
+void optee_unregister_devices(void);
 
 /*
  * Small helpers


