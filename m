Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6882E3CAF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437665AbgL1OFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437659AbgL1OFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0CD20791;
        Mon, 28 Dec 2020 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164298;
        bh=Snkvk+AWRDH5BzQpZp6bCd4k6sBOTEMGA5ZiyqCsS0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4yZHHvabKjinHbCpegFutaj8e1tgK3Pn2XD6BAblPi20AG9dug5vgenb0vn3J2Tb
         pL5xdoUzsINAuQcPpuANJQ7skruAADftmd/b+0nxbvJ3yKsCgiBh/Uh5dAAgM2AqSY
         X/owbTmJoZHo8wBi+Kta09dWGIPlBZqDil/JYrws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/717] media: venus: core: vote with average bandwidth and peak bandwidth as zero
Date:   Mon, 28 Dec 2020 13:42:09 +0100
Message-Id: <20201228125027.222875788@linuxfoundation.org>
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

[ Upstream commit e44fb034b03231cd117d6db73fb8048deab6ea41 ]

As per bandwidth table video driver is voting with average bandwidth
for "video-mem" and "cpu-cfg" paths as peak bandwidth is zero
in bandwidth table.

suspend")

Fixes: 07f8f22a33a9e ("media: venus: core: remove CNOC voting while device
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index fa363b8ddc070..d5bfd6fff85b4 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -385,11 +385,11 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 	const struct venus_pm_ops *pm_ops = core->pm_ops;
 	int ret;
 
-	ret = icc_set_bw(core->video_path, 0, kbps_to_icc(1000));
+	ret = icc_set_bw(core->video_path, kbps_to_icc(20000), 0);
 	if (ret)
 		return ret;
 
-	ret = icc_set_bw(core->cpucfg_path, 0, kbps_to_icc(1000));
+	ret = icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
 	if (ret)
 		return ret;
 
-- 
2.27.0



