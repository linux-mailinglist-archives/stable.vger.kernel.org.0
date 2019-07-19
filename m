Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA216E019
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfGSEjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbfGSD61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84429218A0;
        Fri, 19 Jul 2019 03:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508706;
        bh=wUJWAjQzObn3pLeVm9IKlEipJO5fexx9Y4fykdY7Iew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qhdd1+1dwIZ4cDXAfO9D/OppNTW216J2Si1Em5I5QgOQT1nXEMyu891nFhFlz70s3
         EZxEJJlsuwlxsRB14IXyGYgcCvNb4XJtYrikQHv/o3WUPpzwSvIjI722eQ+vDpQeiP
         sMrNetdlsVXLtDEdyLiX5Xrh0cjMwlbwqMBVEus8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajay Gupta <ajayg@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 044/171] i2c: nvidia-gpu: resume ccgx i2c client
Date:   Thu, 18 Jul 2019 23:54:35 -0400
Message-Id: <20190719035643.14300-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

[ Upstream commit 9f2e244d0a39eb437f98324ac315e605e48636db ]

Cypress USB Type-C CCGx controller firmware version 3.1.10
(which is being used in many NVIDIA GPU cards) has known issue of
not triggering interrupt when a USB device is hot plugged to runtime
resume the controller. If any GPU card gets latest kernel with runtime
pm support but does not get latest fixed firmware then also it should
continue to work and therefore a workaround is required to check for
any connector change event

The workaround is to request runtime resume of i2c client
which is UCSI Cypress CCGx driver. CCG driver will call the ISR
for any connector change event only if NVIDIA GPU has old
CCG firmware with the known issue.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-nvidia-gpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nvidia-gpu.c b/drivers/i2c/busses/i2c-nvidia-gpu.c
index 1c8f708f212b..ee2412b7459c 100644
--- a/drivers/i2c/busses/i2c-nvidia-gpu.c
+++ b/drivers/i2c/busses/i2c-nvidia-gpu.c
@@ -51,6 +51,7 @@ struct gpu_i2c_dev {
 	void __iomem *regs;
 	struct i2c_adapter adapter;
 	struct i2c_board_info *gpu_ccgx_ucsi;
+	struct i2c_client *ccgx_client;
 };
 
 static void gpu_enable_i2c_bus(struct gpu_i2c_dev *i2cd)
@@ -261,8 +262,6 @@ static const struct property_entry ccgx_props[] = {
 
 static int gpu_populate_client(struct gpu_i2c_dev *i2cd, int irq)
 {
-	struct i2c_client *ccgx_client;
-
 	i2cd->gpu_ccgx_ucsi = devm_kzalloc(i2cd->dev,
 					   sizeof(*i2cd->gpu_ccgx_ucsi),
 					   GFP_KERNEL);
@@ -274,8 +273,8 @@ static int gpu_populate_client(struct gpu_i2c_dev *i2cd, int irq)
 	i2cd->gpu_ccgx_ucsi->addr = 0x8;
 	i2cd->gpu_ccgx_ucsi->irq = irq;
 	i2cd->gpu_ccgx_ucsi->properties = ccgx_props;
-	ccgx_client = i2c_new_device(&i2cd->adapter, i2cd->gpu_ccgx_ucsi);
-	if (!ccgx_client)
+	i2cd->ccgx_client = i2c_new_device(&i2cd->adapter, i2cd->gpu_ccgx_ucsi);
+	if (!i2cd->ccgx_client)
 		return -ENODEV;
 
 	return 0;
@@ -354,6 +353,13 @@ static __maybe_unused int gpu_i2c_resume(struct device *dev)
 	struct gpu_i2c_dev *i2cd = dev_get_drvdata(dev);
 
 	gpu_enable_i2c_bus(i2cd);
+	/*
+	 * Runtime resume ccgx client so that it can see for any
+	 * connector change event. Old ccg firmware has known
+	 * issue of not triggering interrupt when a device is
+	 * connected to runtime resume the controller.
+	 */
+	pm_request_resume(&i2cd->ccgx_client->dev);
 	return 0;
 }
 
-- 
2.20.1

