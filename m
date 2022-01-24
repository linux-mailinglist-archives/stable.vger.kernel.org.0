Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3949970E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353675AbiAXVJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56402 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445588AbiAXVEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9201260C17;
        Mon, 24 Jan 2022 21:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB6CC340EC;
        Mon, 24 Jan 2022 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058251;
        bh=73OCnF0ijlwNyF0VYdHcUtgcGaBD+/0/qpwxiORDKkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cmkeghe4jxYM7AShIs3h/XivWkyFAg5IeFWfwRTMZbkfPY/iQtQ4GMbiFs69UtpKA
         tkjTh9Y9VDbJHP864PLJ255mzi9I++yGkUUlyK4prI1CoxXbOzyeHlCkZRizws0tp7
         6VsJtcwSgvfto+n+s/SQ7fnyDR440FyC7JdpmJ8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0195/1039] media: venus: correct low power frequency calculation for encoder
Date:   Mon, 24 Jan 2022 19:33:04 +0100
Message-Id: <20220124184131.877920159@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index cedc664ba755f..184f0cea2fdb8 100644
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



