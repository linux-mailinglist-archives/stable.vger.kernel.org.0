Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EE311995B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfLJVps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbfLJVcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F684207FF;
        Tue, 10 Dec 2019 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013574;
        bh=mvXvOd2QmF66LP5aLAmLb7idpOcK3Y9vW51ob+koF4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKH1RvXSqaA+mycOTuGr+JYX+caiY9YA2jL2SHex3M+l1121CFt7L/bmDZVCSfDU4
         VRm0QppHgH3cdfutLapeoOf5PWxZDlh/gKmahRboff23uFmXlyrZHVRBPUpe2DK1Tp
         OvzafCk3DQiB62/7Vl8BR2pRbyGpiA28KOk0haP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/177] media: venus: Fix occasionally failures to suspend
Date:   Tue, 10 Dec 2019 16:29:51 -0500
Message-Id: <20191210213221.11921-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit 8dbebb2bd01e6f36e9a215dcde99ace70408f2c8 ]

Failure to suspend (venus_suspend_3xx) happens when the system
is fresh booted and loading venus driver. This happens once and
after reload the venus driver modules the problem disrepair.

Fix the failure by skipping the check for WFI and IDLE bits if
PC_READY is on in control status register.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 124085556b94b..fbcc67c10993f 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1484,6 +1484,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 	struct device *dev = core->dev;
+	u32 ctrl_status;
 	bool val;
 	int ret;
 
@@ -1499,6 +1500,10 @@ static int venus_suspend_3xx(struct venus_core *core)
 		return -EINVAL;
 	}
 
+	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+	if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)
+		goto power_off;
+
 	/*
 	 * Power collapse sequence for Venus 3xx and 4xx versions:
 	 * 1. Check for ARM9 and video core to be idle by checking WFI bit
@@ -1523,6 +1528,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 	if (ret)
 		return ret;
 
+power_off:
 	mutex_lock(&hdev->lock);
 
 	ret = venus_power_off(hdev);
-- 
2.20.1

