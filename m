Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D854112C648
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfL2RpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbfL2RpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E260207FD;
        Sun, 29 Dec 2019 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641518;
        bh=/15pi5qSvB4ceV78bERpn7re2axBK/lYD0PAppSjBj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGQcBkmaFnMJPwh5z/4twO2GO/8MHDZzu5wxl4hzZw4/y4mPAV6ygJpvjPMLBqzdt
         wNxLkOuI7nUgfIKzUhkuY5D5e/BwpzM7aG8Nhl6xsuaZtcFj+Gx+xeT9wU69Czg3/o
         lZxH2foV0tD4/HIfTe5N0ldHvzvo3sg8LlgcyrPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/434] media: venus: Fix occasionally failures to suspend
Date:   Sun, 29 Dec 2019 18:22:31 +0100
Message-Id: <20191229172708.099982918@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index 7129a2aea09a..0d8855014ab3 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1472,6 +1472,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(core);
 	struct device *dev = core->dev;
+	u32 ctrl_status;
 	bool val;
 	int ret;
 
@@ -1487,6 +1488,10 @@ static int venus_suspend_3xx(struct venus_core *core)
 		return -EINVAL;
 	}
 
+	ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
+	if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)
+		goto power_off;
+
 	/*
 	 * Power collapse sequence for Venus 3xx and 4xx versions:
 	 * 1. Check for ARM9 and video core to be idle by checking WFI bit
@@ -1511,6 +1516,7 @@ static int venus_suspend_3xx(struct venus_core *core)
 	if (ret)
 		return ret;
 
+power_off:
 	mutex_lock(&hdev->lock);
 
 	ret = venus_power_off(hdev);
-- 
2.20.1



