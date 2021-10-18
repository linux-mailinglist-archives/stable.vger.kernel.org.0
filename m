Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6984315F9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbhJRK0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229985AbhJRK0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 06:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 006C960FF2;
        Mon, 18 Oct 2021 10:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634552672;
        bh=hL722ThGjO12J4SGudAMACn6P/rOcj4lylQ1GR0bJ0I=;
        h=Subject:To:Cc:From:Date:From;
        b=YXQfclBj02RCPRT5EL+FNtYNs4cvaWRmfHJayRP8np40oTx5LiJUHJq8nVArUmROH
         r1Fr5MVY1MUORlJXQfkqOSFYseT4CsMPu4ez7iLDO4w9YTIOS/o5nZvP4BOaEY/fx1
         AsUypuNXR8l0WVcojDRad+1a19YvovDfv/qNBTjQ=
Subject: FAILED: patch "[PATCH] tee: optee: Fix missing devices unregister during" failed to apply to 5.4-stable tree
To:     sumit.garg@linaro.org, jens.wiklander@linaro.org,
        sudeep.holla@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 12:24:29 +0200
Message-ID: <163455266972200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7f565d0ead264329749c0da488de9c8dfa2f18ce Mon Sep 17 00:00:00 2001
From: Sumit Garg <sumit.garg@linaro.org>
Date: Tue, 12 Oct 2021 13:01:16 +0530
Subject: [PATCH] tee: optee: Fix missing devices unregister during
 optee_remove

When OP-TEE driver is built as a module, OP-TEE client devices
registered on TEE bus during probe should be unregistered during
optee_remove. So implement optee_unregister_devices() accordingly.

Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 5ce13b099d7d..5363ebebfc35 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -585,6 +585,9 @@ static int optee_remove(struct platform_device *pdev)
 {
 	struct optee *optee = platform_get_drvdata(pdev);
 
+	/* Unregister OP-TEE specific client devices on TEE bus */
+	optee_unregister_devices();
+
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index ec1d24693eba..128a2d2a50a1 100644
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -53,6 +53,13 @@ static int get_devices(struct tee_context *ctx, u32 session,
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
@@ -63,6 +70,7 @@ static int optee_register_device(const uuid_t *device_uuid)
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
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index dbdd367be156..f6bb4a763ba9 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -184,6 +184,7 @@ void optee_fill_pages_list(u64 *dst, struct page **pages, int num_pages,
 #define PTA_CMD_GET_DEVICES		0x0
 #define PTA_CMD_GET_DEVICES_SUPP	0x1
 int optee_enumerate_devices(u32 func);
+void optee_unregister_devices(void);
 
 /*
  * Small helpers

