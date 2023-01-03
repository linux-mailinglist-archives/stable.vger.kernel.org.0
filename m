Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130BE65BF50
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 12:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjACLpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 06:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbjACLo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 06:44:57 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20062625D;
        Tue,  3 Jan 2023 03:44:54 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 5731241F72;
        Tue,  3 Jan 2023 11:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672746292; bh=wOgcEgG9+pZDSbBKY1gb2vXCECwZ3HDBdpb7Vw0TlGs=;
        h=From:To:Cc:Subject:Date;
        b=obvVnoOOwOgqZwleUIuXZh9Vut/Qr8xCsjjEGEDUK7cgkhzG/0tkJewmuk8VkWCYe
         EwODwQrvmpRpqnz6xHlxkTym6m+P+2IFzxV28IKhexwbIYipjnQNaQa0kpExRCR08+
         /w0XNFrsj/NzBwHRpnUGVHufxSJM1xtkcmyXK4En8C/kLtfPhk+QIrNSvnWlTw5ei1
         4EXD2bnSDVniVAowOk4X7e2j+6sb/uV0aZmOujrssMN8LyYcuyDk+bJbKwJ3IYpWPY
         Hki9fHU0f+0M9ZpdX5UEFLDvMr1Juh3ezFBYDjNi4wQMpdt3Rqh41RhbzRmeQuBSxh
         9NUNLXKZf7uuQ==
From:   Hector Martin <marcan@marcan.st>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Hector Martin <marcan@marcan.st>, stable@vger.kernel.org,
        Eric Curtin <ecurtin@redhat.com>
Subject: [PATCH v2] nvmem: core: Fix race in nvmem_register()
Date:   Tue,  3 Jan 2023 20:44:28 +0900
Message-Id: <20230103114427.1825-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

nvmem_register() currently registers the device before adding the nvmem
cells, which creates a race window where consumers may find the nvmem
device (and not get PROBE_DEFERred), but then fail to find the cells and
error out.

Move device registration to the end of nvmem_register(), to close the
race.

Observed when the stars line up on Apple Silicon machines with the (not
yet upstream, but trivial) spmi nvmem driver and the macsmc-rtc client:

[    0.487375] macsmc-rtc macsmc-rtc: error -ENOENT: Failed to get rtc_offset NVMEM cell

Fixes: eace75cfdcf7 ("nvmem: Add a simple NVMEM framework for nvmem providers")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/nvmem/core.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 321d7d63e068..606f428d6292 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 		break;
 	}

-	if (rval) {
-		ida_free(&nvmem_ida, nvmem->id);
-		kfree(nvmem);
-		return ERR_PTR(rval);
-	}
+	if (rval)
+		goto err_gpiod_put;

 	nvmem->read_only = device_property_present(config->dev, "read-only") ||
 			   config->read_only || !nvmem->reg_write;
@@ -837,20 +834,16 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)

 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);

-	rval = device_register(&nvmem->dev);
-	if (rval)
-		goto err_put_device;
-
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
 		if (rval)
-			goto err_device_del;
+			goto err_gpiod_put;
 	}

 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)
-			goto err_device_del;
+			goto err_gpiod_put;
 	}

 	if (config->cells) {
@@ -867,6 +860,15 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (rval)
 		goto err_remove_cells;

+	rval = device_register(&nvmem->dev);
+	if (rval) {
+		nvmem_device_remove_all_cells(nvmem);
+		if (config->compat)
+			nvmem_sysfs_remove_compat(nvmem, config);
+		put_device(&nvmem->dev);
+		return ERR_PTR(rval);
+	}
+
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);

 	return nvmem;
@@ -876,10 +878,10 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
-err_device_del:
-	device_del(&nvmem->dev);
-err_put_device:
-	put_device(&nvmem->dev);
+err_gpiod_put:
+	gpiod_put(nvmem->wp_gpio);
+	ida_free(&nvmem_ida, nvmem->id);
+	kfree(nvmem);

 	return ERR_PTR(rval);
 }
--
2.35.1

