Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15051F3093
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgFIBAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbgFHXIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E5DA208A7;
        Mon,  8 Jun 2020 23:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657697;
        bh=qMBN6ywlGZR40UxUS7UN9pzv36EbDklsZp2ZsKOoD8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjp1N+VLvRFx2jsRegJPWFxkfXKDJjLb+/4GhWxsL7nu8bu/wEWImgKznLe3gStm6
         mvcmTNcAB8ROGVIOF7NAgDJhD45CgUnvvBTHCXhdj8ltSIoZBXud3KU5WZfW/i0CNj
         TAHUPGQBsOhMx7XmYJU0Rcd2inwFNy0ivcCtAf1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 097/274] media: venus: core: remove CNOC voting while device suspend
Date:   Mon,  8 Jun 2020 19:03:10 -0400
Message-Id: <20200608230607.3361041-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 07f8f22a33a9e3e9955e24a84e2f856dcc8c31c4 ]

The Venus driver is voting Configuration NoC during .probe but not clear
voting in .suspend. Because of this NoC is up during shutdown also. As a
consequence the whole device could leak energy while in .suspend.

So correct this by moving voting in .resume and unvoting
in .suspend

Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 194b10b98767..13fa5076314c 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -242,10 +242,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
-	if (ret)
-		return ret;
-
 	ret = hfi_create(core, &venus_core_ops);
 	if (ret)
 		return ret;
@@ -350,6 +346,10 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	ret = icc_set_bw(core->cpucfg_path, 0, 0);
+	if (ret)
+		return ret;
+
 	if (pm_ops->core_power)
 		ret = pm_ops->core_power(dev, POWER_OFF);
 
@@ -368,6 +368,10 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 			return ret;
 	}
 
+	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
+	if (ret)
+		return ret;
+
 	return hfi_core_resume(core, false);
 }
 
-- 
2.25.1

