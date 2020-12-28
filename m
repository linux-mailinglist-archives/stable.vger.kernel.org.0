Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8D2E3CA7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437541AbgL1OFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437532AbgL1OFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC2A2063A;
        Mon, 28 Dec 2020 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164293;
        bh=q3NY13z8LWQZ5YfejJIROehaop8JhByp7uRRPIsIRe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3B/o3PPXuP/Ed0pCwPm9J/2aJdLEVKoH3eZg4F5wFaQu3GiHkiSmnBXSAkee7KaH
         52/jM1CVTN3cJ4KXdNGVSv+I/HyyyBgfxic94HJ8YDyC+INoEKlESdbti4wz872S4u
         mheE1APNh0HUOZegCaEJDgtwhFCtM6lMp6jBxiLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/717] media: venus: core: change clk enable and disable order in resume and suspend
Date:   Mon, 28 Dec 2020 13:42:07 +0100
Message-Id: <20201228125027.129998550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 21926d466e3a4f35c2536244d1d56512cc81a0a9 ]

Currently video driver is voting after clk enable and un voting
before clk disable. This is incorrect, video driver should vote
before clk enable and unvote after clk disable.

Corrected this by changing the order of clk enable and clk disable.

suspend")

Fixes: 07f8f22a33a9e ("media: venus: core: remove CNOC voting while device
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 6103aaf43987b..52a3886c496eb 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -355,13 +355,16 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (pm_ops->core_power) {
+		ret = pm_ops->core_power(dev, POWER_OFF);
+		if (ret)
+			return ret;
+	}
+
 	ret = icc_set_bw(core->cpucfg_path, 0, 0);
 	if (ret)
 		return ret;
 
-	if (pm_ops->core_power)
-		ret = pm_ops->core_power(dev, POWER_OFF);
-
 	return ret;
 }
 
@@ -371,16 +374,16 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 	const struct venus_pm_ops *pm_ops = core->pm_ops;
 	int ret;
 
+	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
+	if (ret)
+		return ret;
+
 	if (pm_ops->core_power) {
 		ret = pm_ops->core_power(dev, POWER_ON);
 		if (ret)
 			return ret;
 	}
 
-	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
-	if (ret)
-		return ret;
-
 	return hfi_core_resume(core, false);
 }
 
-- 
2.27.0



