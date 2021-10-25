Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1C43A06D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhJYTaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhJYT3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B585A61175;
        Mon, 25 Oct 2021 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189967;
        bh=yuMxkcj64nG2DT/aG1po/8hWBrLRwMRDmEOEN/Y0QfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KefOtGF//2rY282iUY7RlBFRctqphxBArQf8ei01+1lK7gcjUm2+bJzC0beBmt0O1
         mLNmn85XAfpwSkMXHIK2AWcmDxvI+u9Xft1tttIhVP1OpubiC8mZWU1EGtFWTsge3B
         D8zdKXjK30cHkj3GRcwuWV28zfbOvC9rVdBoY3MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 03/58] tee: optee: Fix missing devices unregister during optee_remove
Date:   Mon, 25 Oct 2021 21:14:20 +0200
Message-Id: <20211025190938.169353788@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
[SG: backport to 5.4, dev name s/optee-ta/optee-clnt/]
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/core.c          |    3 +++
 drivers/tee/optee/device.c        |   22 ++++++++++++++++++++++
 drivers/tee/optee/optee_private.h |    1 +
 3 files changed, 26 insertions(+)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -582,6 +582,9 @@ static struct optee *optee_probe(struct
 	if (sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pool = optee_config_dyn_shm();
 
+	/* Unregister OP-TEE specific client devices on TEE bus */
+	optee_unregister_devices();
+
 	/*
 	 * If dynamic shared memory is not available or failed - try static one
 	 */
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -65,6 +65,13 @@ static int get_devices(struct tee_contex
 	return 0;
 }
 
+static void optee_release_device(struct device *dev)
+{
+	struct tee_client_device *optee_device = to_tee_client_device(dev);
+
+	kfree(optee_device);
+}
+
 static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
 {
 	struct tee_client_device *optee_device = NULL;
@@ -75,6 +82,7 @@ static int optee_register_device(const u
 		return -ENOMEM;
 
 	optee_device->dev.bus = &tee_bus_type;
+	optee_device->dev.release = optee_release_device;
 	dev_set_name(&optee_device->dev, "optee-clnt%u", device_id);
 	uuid_copy(&optee_device->id.uuid, device_uuid);
 
@@ -158,3 +166,17 @@ out_ctx:
 
 	return rc;
 }
+
+static int __optee_unregister_device(struct device *dev, void *data)
+{
+	if (!strncmp(dev_name(dev), "optee-clnt", strlen("optee-clnt")))
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
@@ -175,6 +175,7 @@ void optee_fill_pages_list(u64 *dst, str
 			   size_t page_offset);
 
 int optee_enumerate_devices(void);
+void optee_unregister_devices(void);
 
 /*
  * Small helpers


