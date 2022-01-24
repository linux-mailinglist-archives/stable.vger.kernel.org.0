Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7720D49A92E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322272AbiAYDVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57596 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355791AbiAXUSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C00AB81218;
        Mon, 24 Jan 2022 20:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB34C33DE4;
        Mon, 24 Jan 2022 20:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055493;
        bh=lHDIrkJS0aK/qJe448wvM8aM+uv2N3T66ApDFw8VJbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvT6Y5DZMj921BmU9wM5YEi+F5tt+1JxsaXFK5nk87Ie8xvR83H32cb0AUEa/95/y
         wKt9tmt3hm48v3JZ+sqhwzyvmSBuJa/kSxl12nR4oknHhoTu/GHjGNKoJLbdQIi8a7
         hk4UfeiRiU0QNemhXXrzuW/wke3pyELtesvB5qz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/846] media: venus: correct low power frequency calculation for encoder
Date:   Mon, 24 Jan 2022 19:34:46 +0100
Message-Id: <20220124184106.806797081@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit b1f9bb8020783a48151e3a2864fbdc70548566dd ]

In exististing implimentation, in min_loaded_core() for low_power
vpp frequency value is considering as vpp_freq instead of low_power_freq.
Fixed this by correcting vpp frequency calculation for encoder.

Fixes: 3cfe5815ce0e (media: venus: Enable low power setting for encoder)
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index e031fd17f4e75..d382872bc8a08 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -587,8 +587,8 @@ min_loaded_core(struct venus_inst *inst, u32 *min_coreid, u32 *min_load, bool lo
 		if (inst->session_type == VIDC_SESSION_TYPE_DEC)
 			vpp_freq = inst_pos->clk_data.vpp_freq;
 		else if (inst->session_type == VIDC_SESSION_TYPE_ENC)
-			vpp_freq = low_power ? inst_pos->clk_data.vpp_freq :
-				inst_pos->clk_data.low_power_freq;
+			vpp_freq = low_power ? inst_pos->clk_data.low_power_freq :
+				inst_pos->clk_data.vpp_freq;
 		else
 			continue;
 
-- 
2.34.1



