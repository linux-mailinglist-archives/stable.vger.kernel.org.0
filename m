Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB7E20E713
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgF2VxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgF2Sfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C7F24248;
        Mon, 29 Jun 2020 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443959;
        bh=0RjzG34x4n3ocMS+b94pUtVOFEowTxSu6nALCesgX8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wfwc5suGqvc9kCKRuPU+/dxaDfqXtmXNtwh3SYdLBAhZngjOY7l0Gj9hs68ukOdzd
         EnMahw7Rz1SjDKaoVLP2YR9vnxnDnZ6DwkzKSK0jHeEH/YVcoYwTmmKQ94KI5t7ttk
         udzGsKngxyoL1gxyDKOb1Sp+EXrtydNEr7PTs8Js=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 062/265] Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"
Date:   Mon, 29 Jun 2020 11:14:55 -0400
Message-Id: <20200629151818.2493727-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

commit ad38beb373a14e082f4e64b68c0b6e6b09764680 upstream.

This reverts commit 07f6842341abe978e6375078f84506ec3280ece5.

Since SCLK_SCLK_USBD300 suspend clock need to be configured
for phy module, I wrongly mapped this clock to DWC3 code.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 07f6842341ab ("usb: dwc3: exynos: Add support for Exynos5422 suspend clk")
Link: https://lore.kernel.org/r/20200623074637.756-1-linux.amoon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-exynos.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 48b68b6f0dc82..90bb022737da8 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -162,12 +162,6 @@ static const struct dwc3_exynos_driverdata exynos5250_drvdata = {
 	.suspend_clk_idx = -1,
 };
 
-static const struct dwc3_exynos_driverdata exynos5420_drvdata = {
-	.clk_names = { "usbdrd30", "usbdrd30_susp_clk"},
-	.num_clks = 2,
-	.suspend_clk_idx = 1,
-};
-
 static const struct dwc3_exynos_driverdata exynos5433_drvdata = {
 	.clk_names = { "aclk", "susp_clk", "pipe_pclk", "phyclk" },
 	.num_clks = 4,
@@ -184,9 +178,6 @@ static const struct of_device_id exynos_dwc3_match[] = {
 	{
 		.compatible = "samsung,exynos5250-dwusb3",
 		.data = &exynos5250_drvdata,
-	}, {
-		.compatible = "samsung,exynos5420-dwusb3",
-		.data = &exynos5420_drvdata,
 	}, {
 		.compatible = "samsung,exynos5433-dwusb3",
 		.data = &exynos5433_drvdata,
-- 
2.25.1

