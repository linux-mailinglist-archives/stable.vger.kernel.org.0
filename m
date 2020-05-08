Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F251CAF77
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgEHMi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgEHMiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71393215A4;
        Fri,  8 May 2020 12:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941533;
        bh=xKYlgra1bjz4M+bEPOOEvT6lJyexDCQK/RPwfLRVI/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=he4J6LqiZB9wzP+Nesa1v8zPvADzboLSxXCT9fat51fC048KRzahru3Y3pC+PN+wt
         HjsqsOhSBn+uVbVEapY/4bnQnaFOyEVTlnW4iA905uVbIZUaR3m98HNAgr1lVG/cjc
         8FlidofO7Xkiu7dv4J5qmIsIS3s2V5MZ3E7amn+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 071/312] [media] c8sectpfe: Rework firmware loading mechanism
Date:   Fri,  8 May 2020 14:31:02 +0200
Message-Id: <20200508123129.537219276@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

commit c23ac90f78aa9190643c82c1975a0cfe480d7c60 upstream.

c8sectpfe driver relied on CONFIG_FW_LOADER_USER_HELPER_FALLBACK option
for loading its xp70 firmware. A previous commit removed this Kconfig
option, as it is apparently harmful, but did not update the driver
code which relied on it.

This patch reworks the firmware loading into the start_feed callback.
At this point we can be sure the rootfs is present, thereby removing
the depedency on CONFIG_FW_LOADER_USER_HELPER_FALLBACK.

Fixes: 79f5b6ae960d ('[media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK')

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c |   65 ++++++------------
 1 file changed, 22 insertions(+), 43 deletions(-)

--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -49,7 +49,7 @@ MODULE_FIRMWARE(FIRMWARE_MEMDMA);
 #define PID_TABLE_SIZE 1024
 #define POLL_MSECS 50
 
-static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei);
+static int load_c8sectpfe_fw(struct c8sectpfei *fei);
 
 #define TS_PKT_SIZE 188
 #define HEADER_SIZE (4)
@@ -143,6 +143,7 @@ static int c8sectpfe_start_feed(struct d
 	struct channel_info *channel;
 	u32 tmp;
 	unsigned long *bitmap;
+	int ret;
 
 	switch (dvbdmxfeed->type) {
 	case DMX_TYPE_TS:
@@ -171,8 +172,9 @@ static int c8sectpfe_start_feed(struct d
 	}
 
 	if (!atomic_read(&fei->fw_loaded)) {
-		dev_err(fei->dev, "%s: c8sectpfe fw not loaded\n", __func__);
-		return -EINVAL;
+		ret = load_c8sectpfe_fw(fei);
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&fei->lock);
@@ -267,8 +269,9 @@ static int c8sectpfe_stop_feed(struct dv
 	unsigned long *bitmap;
 
 	if (!atomic_read(&fei->fw_loaded)) {
-		dev_err(fei->dev, "%s: c8sectpfe fw not loaded\n", __func__);
-		return -EINVAL;
+		ret = load_c8sectpfe_fw(fei);
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&fei->lock);
@@ -882,13 +885,6 @@ static int c8sectpfe_probe(struct platfo
 		goto err_clk_disable;
 	}
 
-	/* ensure all other init has been done before requesting firmware */
-	ret = load_c8sectpfe_fw_step1(fei);
-	if (ret) {
-		dev_err(dev, "Couldn't load slim core firmware\n");
-		goto err_clk_disable;
-	}
-
 	c8sectpfe_debugfs_init(fei);
 
 	return 0;
@@ -1093,15 +1089,14 @@ static void load_dmem_segment(struct c8s
 		phdr->p_memsz - phdr->p_filesz);
 }
 
-static int load_slim_core_fw(const struct firmware *fw, void *context)
+static int load_slim_core_fw(const struct firmware *fw, struct c8sectpfei *fei)
 {
-	struct c8sectpfei *fei = context;
 	Elf32_Ehdr *ehdr;
 	Elf32_Phdr *phdr;
 	u8 __iomem *dst;
 	int err = 0, i;
 
-	if (!fw || !context)
+	if (!fw || !fei)
 		return -EINVAL;
 
 	ehdr = (Elf32_Ehdr *)fw->data;
@@ -1153,29 +1148,35 @@ static int load_slim_core_fw(const struc
 	return err;
 }
 
-static void load_c8sectpfe_fw_cb(const struct firmware *fw, void *context)
+static int load_c8sectpfe_fw(struct c8sectpfei *fei)
 {
-	struct c8sectpfei *fei = context;
+	const struct firmware *fw;
 	int err;
 
+	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
+
+	err = request_firmware(&fw, FIRMWARE_MEMDMA, fei->dev);
+	if (err)
+		return err;
+
 	err = c8sectpfe_elf_sanity_check(fei, fw);
 	if (err) {
 		dev_err(fei->dev, "c8sectpfe_elf_sanity_check failed err=(%d)\n"
 			, err);
-		goto err;
+		return err;
 	}
 
-	err = load_slim_core_fw(fw, context);
+	err = load_slim_core_fw(fw, fei);
 	if (err) {
 		dev_err(fei->dev, "load_slim_core_fw failed err=(%d)\n", err);
-		goto err;
+		return err;
 	}
 
 	/* now the firmware is loaded configure the input blocks */
 	err = configure_channels(fei);
 	if (err) {
 		dev_err(fei->dev, "configure_channels failed err=(%d)\n", err);
-		goto err;
+		return err;
 	}
 
 	/*
@@ -1188,28 +1189,6 @@ static void load_c8sectpfe_fw_cb(const s
 	writel(0x1,  fei->io + DMA_CPU_RUN);
 
 	atomic_set(&fei->fw_loaded, 1);
-err:
-	complete_all(&fei->fw_ack);
-}
-
-static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
-{
-	int err;
-
-	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
-
-	init_completion(&fei->fw_ack);
-	atomic_set(&fei->fw_loaded, 0);
-
-	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
-				FIRMWARE_MEMDMA, fei->dev, GFP_KERNEL, fei,
-				load_c8sectpfe_fw_cb);
-
-	if (err) {
-		dev_err(fei->dev, "request_firmware_nowait err: %d.\n", err);
-		complete_all(&fei->fw_ack);
-		return err;
-	}
 
 	return 0;
 }


