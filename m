Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62E5451FD4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349972AbhKPApe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343832AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 055EE635F3;
        Mon, 15 Nov 2021 18:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002025;
        bh=m9xtlrF/MyWZVOBJH/qxTGqpGFoMh0xe6oQftKg9N+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RigltHPp4Zrk8ZS8pBGMI1LgneROAT2Mu0k/+AXsQTPdFaVplLk8wzSoy37DPIuyx
         0lJtbBitCSjvH+/944F1RXbZlb2tYgXHe3lIZ+Is+a0RNHRcrCPE3WjxyTYAgj2e+n
         urHb/+2a1k1axZknldvVrsPQ8cup4fcukGLw6IuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/917] media: venus: fix vpp frequency calculation for decoder
Date:   Mon, 15 Nov 2021 17:58:24 +0100
Message-Id: <20211115165442.658817778@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 1444232152ea33f5ae41fc14bade3e74d642b634 ]

In existing video driver implementation vpp frequency calculation in
calculate_inst_freq() is always zero because the value of vpp_freq_per_mb
is always zero for decoder.

Fixed this by correcting the calculating the vpp frequency calculation for
decoder.

Fixes: 3cfe5815ce0e ("media: venus: Enable low power setting for encoder")
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index 3e2345eb47f7c..e031fd17f4e75 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -1085,12 +1085,16 @@ static unsigned long calculate_inst_freq(struct venus_inst *inst,
 	if (inst->state != INST_START)
 		return 0;
 
-	if (inst->session_type == VIDC_SESSION_TYPE_ENC)
+	if (inst->session_type == VIDC_SESSION_TYPE_ENC) {
 		vpp_freq_per_mb = inst->flags & VENUS_LOW_POWER ?
 			inst->clk_data.low_power_freq :
 			inst->clk_data.vpp_freq;
 
-	vpp_freq = mbs_per_sec * vpp_freq_per_mb;
+		vpp_freq = mbs_per_sec * vpp_freq_per_mb;
+	} else {
+		vpp_freq = mbs_per_sec * inst->clk_data.vpp_freq;
+	}
+
 	/* 21 / 20 is overhead factor */
 	vpp_freq += vpp_freq / 20;
 	vsp_freq = mbs_per_sec * inst->clk_data.vsp_freq;
-- 
2.33.0



