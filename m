Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EDB3C51F1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349577AbhGLHoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349308AbhGLHlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65F760724;
        Mon, 12 Jul 2021 07:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075544;
        bh=1O+RB0jGz8d34aGUcynhQQb25IT28EtM/dWmHEG+1f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHZUQsyID3ZjzLCSCqqItHqBLmKhPstSTG7ElNcoxY295Zdd7zgvHtnqVuzmvmOX5
         ng555So43Q7uVWk8OFPh4WxPSd+gl+mkZlwjBlp6rXmlCWuLEqPLx8nBn5EO7BCQoS
         QXFKqqp1Ot/4/b/1jRwL5rJCLG1C6pVDjVdKQB8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 260/800] mailbox: qcom: Use PLATFORM_DEVID_AUTO to register platform device
Date:   Mon, 12 Jul 2021 08:04:43 +0200
Message-Id: <20210712060951.062640785@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 96e39e95c01283ff5695dafe659df88ada802159 ]

In adding APCS clock support for MSM8939, the second clock registration
fails due to duplicate device name like below.

[    0.519657] sysfs: cannot create duplicate filename '/bus/platform/devices/qcom-apcs-msm8916-clk'
...
[    0.661158] qcom_apcs_ipc b111000.mailbox: failed to register APCS clk

This is because MSM8939 has 3 APCS instances for Cluster0 (little cores),
Cluster1 (big cores) and CCI (Cache Coherent Interconnect).  Although
only APCS of Cluster0 and Cluster1 have IPC bits, each of 3 APCS has
A53PLL clock control bits.  That said, 3 'qcom-apcs-msm8916-clk' devices
need to be registered to instantiate all 3 clocks.  Use PLATFORM_DEVID_AUTO
rather than PLATFORM_DEVID_NONE for platform_device_register_data() call
to fix the issue above.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-apcs-ipc-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-apcs-ipc-mailbox.c b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
index f25324d03842..15236d729625 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -132,7 +132,7 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
 	if (apcs_data->clk_name) {
 		apcs->clk = platform_device_register_data(&pdev->dev,
 							  apcs_data->clk_name,
-							  PLATFORM_DEVID_NONE,
+							  PLATFORM_DEVID_AUTO,
 							  NULL, 0);
 		if (IS_ERR(apcs->clk))
 			dev_err(&pdev->dev, "failed to register APCS clk\n");
-- 
2.30.2



