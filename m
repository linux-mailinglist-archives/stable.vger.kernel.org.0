Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228073291BB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhCAUcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238712AbhCAUYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F6065409;
        Mon,  1 Mar 2021 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621963;
        bh=trFxcuYKqMouF32lxS+/KuRd3gv9PdsV/7cUNEYyQKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbRFD/I0WLfg5IyrVRAR0OISut93VoIo+LtU4HSAowGwSoPpIXg1Qm3GxJmZhgxHC
         uQFVBBoEyDoFoOabiKxl2Wx7y+NtuNRmhHGD/g+czxBCL9NVeGr1mAfbc2e7evJ1ut
         cI6cHVHtpyA838HPEQfZtzgWgMLLIVxB/CeJO2SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.11 708/775] nvmem: qcom-spmi-sdam: Fix uninitialized pdev pointer
Date:   Mon,  1 Mar 2021 17:14:36 +0100
Message-Id: <20210301161236.335425637@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

commit e2057ee29973b9741d43d3f475a6b02fb46a0e61 upstream.

"sdam->pdev" is uninitialized and it is used to print error logs.
Fix it. Since device pointer can be used from sdam_config, use it
directly thereby removing pdev pointer.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210205100853.32372-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/qcom-spmi-sdam.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2017, 2020 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2017, 2020-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/device.h>
@@ -18,7 +18,6 @@
 #define SDAM_PBS_TRIG_CLR		0xE6
 
 struct sdam_chip {
-	struct platform_device		*pdev;
 	struct regmap			*regmap;
 	struct nvmem_config		sdam_config;
 	unsigned int			base;
@@ -65,7 +64,7 @@ static int sdam_read(void *priv, unsigne
 				size_t bytes)
 {
 	struct sdam_chip *sdam = priv;
-	struct device *dev = &sdam->pdev->dev;
+	struct device *dev = sdam->sdam_config.dev;
 	int rc;
 
 	if (!sdam_is_valid(sdam, offset, bytes)) {
@@ -86,7 +85,7 @@ static int sdam_write(void *priv, unsign
 				size_t bytes)
 {
 	struct sdam_chip *sdam = priv;
-	struct device *dev = &sdam->pdev->dev;
+	struct device *dev = sdam->sdam_config.dev;
 	int rc;
 
 	if (!sdam_is_valid(sdam, offset, bytes)) {


