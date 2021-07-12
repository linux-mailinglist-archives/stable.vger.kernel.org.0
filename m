Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922CB3C490A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbhGLGlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238504AbhGLGkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6F86052B;
        Mon, 12 Jul 2021 06:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071849;
        bh=8sHLODwNgxAOO6mCyft9rWozkeNFZT2RKo4VMIWnhQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2m6Lnxv3EL0FWLu9sfPjMQ6ohW70oppqcJjTbr4K+4ckp5TNM9GKtvn/3bUqfSbEl
         J6hoxBI1huQfCFe5CJH/T/otBvtpdcODGgHY3xiKzdMpbTOfMklpfOYJCx4D4F70pU
         2OZlqY5wFaPyLcizPgPiMZHgac9dyq3dBd/5j4Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/593] mailbox: qcom: Use PLATFORM_DEVID_AUTO to register platform device
Date:   Mon, 12 Jul 2021 08:06:04 +0200
Message-Id: <20210712060905.449972659@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 077e5c6a9ef7..3d100a004760 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -128,7 +128,7 @@ static int qcom_apcs_ipc_probe(struct platform_device *pdev)
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



