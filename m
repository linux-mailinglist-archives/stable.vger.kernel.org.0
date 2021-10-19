Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACFA4332C5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 11:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbhJSJr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 05:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhJSJr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 05:47:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757E9C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 02:45:45 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c4so11780727pgv.11
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 02:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gV/xUrPkYIcCqRTWaTYo3fJvU6AhwIAtY9a+Fk30jmo=;
        b=Z402Mphs4YQhkJXtx38jAzJbmUjeEr25TPp4FELDFvTBQRF4DlUKfLTI8RWKhHc6NW
         YTytm0gLNcXmANCpcANv0CZ2sP/JZs6a4VBtdny1Lm2iGaMb9GvlKBRpEfXufqlaL0Wl
         6a9nAZs8halS8WXm9UCo3NaSMUFIxwyz7PPe3rw1W+8be9LMK8kmu6yf7JWtu5dfA5VG
         vV6zvKbbuTjX3rv1fcSNmHumcToogNuEQASJrzNklb4goaVvc0WJ/xa5D4W6qTCeLaoN
         nC/QESW13JJG4BZKxl5MHiSJbFzu2AIRS1ONqdUCBdeedjmiBkcXQM8ydyGRPvEi3MyR
         W0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gV/xUrPkYIcCqRTWaTYo3fJvU6AhwIAtY9a+Fk30jmo=;
        b=uhW7ByCP5fTDwSPScjDUqBi+90UH/Wgk1Iq3lNEoC5mrrpK4G4V8t1eR31dH8kbgfv
         YW5Nx5ObRfzRIoXeCADPEkETZr7bEqEn+Tu/n7SEMAV0DTDLXYL/YxA6XO6juCWkA6FB
         /Fq85MIfo2Epx8dZJ0gAfQTTHUDHTXgbtkov7urpSvvCRiPJgp1L2mq+zsEO8AcU5j24
         cFV2g5vAc+K43JMoC0n/x0DaPGi7BAStpFVvOjlPLXmlVjAIgwMKgT0tb7S+p62qy09R
         X/G0U0c8EfKR/z/t9JvpQRf2GinLZea1Bo4j/gEBV+bGmrM3VaCkRecTdUjJd1mVl7mY
         jDfg==
X-Gm-Message-State: AOAM531oKCJSgQasw2ox1L9eWEAYBeoiaATpWhNHbQk5pCXowo0BxLBT
        aCTmhfU9r03VnqIPXtuoRRZwR/ml3+0BWdq3
X-Google-Smtp-Source: ABdhPJyujZYbYInufDbTQDf8LNLbe+OoDKqzpbRj+ePf4EUq0dqTL/RjFhaG37mDn3HZluGcC6M4Og==
X-Received: by 2002:aa7:949c:0:b0:44c:a0df:2c7f with SMTP id z28-20020aa7949c000000b0044ca0df2c7fmr34807682pfk.34.1634636744534;
        Tue, 19 Oct 2021 02:45:44 -0700 (PDT)
Received: from localhost.localdomain ([223.178.212.208])
        by smtp.gmail.com with ESMTPSA id lb5sm2168348pjb.11.2021.10.19.02.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 02:45:43 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jens.wiklander@linaro.org,
        sudeep.holla@arm.com, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH backport for 5.4] tee: optee: Fix missing devices unregister during optee_remove
Date:   Tue, 19 Oct 2021 15:15:32 +0530
Message-Id: <20211019094532.470845-1-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 7f565d0ead26

When OP-TEE driver is built as a module, OP-TEE client devices
registered on TEE bus during probe should be unregistered during
optee_remove. So implement optee_unregister_devices() accordingly.

Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
[SG: backport to 5.4, dev name s/optee-ta/optee-clnt/]
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/optee/core.c          |  3 +++
 drivers/tee/optee/device.c        | 22 ++++++++++++++++++++++
 drivers/tee/optee/optee_private.h |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 4bb4c8f28cbd..5eaef45799e6 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -582,6 +582,9 @@ static struct optee *optee_probe(struct device_node *np)
 	if (sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pool = optee_config_dyn_shm();
 
+	/* Unregister OP-TEE specific client devices on TEE bus */
+	optee_unregister_devices();
+
 	/*
 	 * If dynamic shared memory is not available or failed - try static one
 	 */
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index e3a148521ec1..acff7dd677d6 100644
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -65,6 +65,13 @@ static int get_devices(struct tee_context *ctx, u32 session,
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
@@ -75,6 +82,7 @@ static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
 		return -ENOMEM;
 
 	optee_device->dev.bus = &tee_bus_type;
+	optee_device->dev.release = optee_release_device;
 	dev_set_name(&optee_device->dev, "optee-clnt%u", device_id);
 	uuid_copy(&optee_device->id.uuid, device_uuid);
 
@@ -158,3 +166,17 @@ int optee_enumerate_devices(void)
 
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
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index 3eeaad2a2868..54c3fa01d002 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -175,6 +175,7 @@ void optee_fill_pages_list(u64 *dst, struct page **pages, int num_pages,
 			   size_t page_offset);
 
 int optee_enumerate_devices(void);
+void optee_unregister_devices(void);
 
 /*
  * Small helpers
-- 
2.25.1

