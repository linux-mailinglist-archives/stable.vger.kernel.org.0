Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE8B12C5C2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfL2RbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbfL2RbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A150520409;
        Sun, 29 Dec 2019 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640670;
        bh=WHsWUyjkT6BtcW+ctw78vQlYzOCMH3wIY6zzM3e/Ubk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAc24KRsGbBgdS6uIPt1PuyADBBuju5qVedlWe6wdij+1P8rk9VJ17d08BexqSyM9
         OJB0ZgeRtE+cC31EOuj7aNqYyEcrTGs4kDKhi1ti1k4hFebBBjpRcc34pPhXWs1yf6
         wteiBgCazhJZNZdHFo8GkmzT/Zjlaui7oXOrPGWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/219] media: venus: Fix occasionally failures to suspend
Date:   Sun, 29 Dec 2019 18:17:33 +0100
Message-Id: <20191229162515.108617394@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 124085556b94..fbcc67c10993 100644
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



