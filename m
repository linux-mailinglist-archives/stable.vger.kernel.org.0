Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4632E3CAE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437650AbgL1OFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437611AbgL1OFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8936C20715;
        Mon, 28 Dec 2020 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164296;
        bh=Dcw8daAD2Yw70GrVEE2n3jG/EPOE9MABbtUUl/o2G4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl715zH295ldfFXPH/QDryM2lb4P45ldSJUTmoOIFLk6N4CpuUJKY8hDiEvoFiwhZ
         Sy14hIBBJ0KJma3CCjbSVfqlsozEcISNewKdM2OPsi7u9jfmD/mCmzdAVTJm5W8S6c
         tfarnCJo0HVd5q8duL/x2gH0Ut0gd8Qsyzcf4ZgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/717] media: venus: core: vote for video-mem path
Date:   Mon, 28 Dec 2020 13:42:08 +0100
Message-Id: <20201228125027.175312018@linuxfoundation.org>
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

[ Upstream commit 9e8efdb5787986cc0d0134925cf5c4f001bb3f2e ]

Currently video driver is voting for venus0-ebi path during buffer
processing with an average bandwidth of all the instances and
unvoting during session release.

While video streaming when we try to do XO-SD using the command
"echo mem > /sys/power/state command" , device is not entering
to suspend state and from interconnect summary seeing votes for venus0-ebi

Corrected this by voting for venus0-ebi path in venus_runtime_resume()
and unvote during venus_runtime_suspend().

suspend")

Fixes: 07f8f22a33a9e ("media: venus: core: remove CNOC voting while device
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 52a3886c496eb..fa363b8ddc070 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -363,7 +363,18 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 
 	ret = icc_set_bw(core->cpucfg_path, 0, 0);
 	if (ret)
-		return ret;
+		goto err_cpucfg_path;
+
+	ret = icc_set_bw(core->video_path, 0, 0);
+	if (ret)
+		goto err_video_path;
+
+	return ret;
+
+err_video_path:
+	icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
+err_cpucfg_path:
+	pm_ops->core_power(dev, POWER_ON);
 
 	return ret;
 }
@@ -374,6 +385,10 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 	const struct venus_pm_ops *pm_ops = core->pm_ops;
 	int ret;
 
+	ret = icc_set_bw(core->video_path, 0, kbps_to_icc(1000));
+	if (ret)
+		return ret;
+
 	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
 	if (ret)
 		return ret;
-- 
2.27.0



