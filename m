Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3464917E9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347942AbiARCnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345110AbiARCiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D219B81132;
        Tue, 18 Jan 2022 02:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27388C36AE3;
        Tue, 18 Jan 2022 02:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473497;
        bh=VjeGrVWKUxuNF7cBz0+iP8hkmF9ifj/wPGSoiuV5FjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIcSZV+O7c5G8YPXRtNpGa3ArKtjfCHe2VAMLz2JXfsAMKZ/WCjgEqoOLAo8lX9Wa
         RCWdlMVcLeA9DvBIctRGaY4Elzfvr40+AD5+jXhRacqvlO31TbUfow4nxCip4ld+nV
         tid8HX2OvsGxuk2prl4342PyBxuJcI784SFlaVXAvG0VkgQMajzZ3D4G/wmkIGNXtA
         uIkWxBYLzfJSdpzHirIxXLC/8MaT5W6qo1FyLsr+EvRgeQLXmttJQlRpjZxqDVUvyV
         80/iLlQXTeaEmSujxFOD4TIk4YmHipn3fNIved4Od2owOS3VrjwNf+QqN/vvO8ZQXo
         /bTRFRm5IOioA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, nks@flawful.org,
        agross@kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 137/188] PM: AVS: qcom-cpr: Use div64_ul instead of do_div
Date:   Mon, 17 Jan 2022 21:31:01 -0500
Message-Id: <20220118023152.1948105-137-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

[ Upstream commit 92c550f9ffd2884bb5def52b5c0485a35e452784 ]

do_div() does a 64-by-32 division. Here the divisor is an unsigned long
which on some platforms is 64 bit wide. So use div64_ul instead of do_div
to avoid a possible truncation.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211125014311.45942-1-deng.changcheng@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cpr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index 4ce8e816154f9..84dd93472a252 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1010,7 +1010,7 @@ static int cpr_interpolate(const struct corner *corner, int step_volt,
 		return corner->uV;
 
 	temp = f_diff * (uV_high - uV_low);
-	do_div(temp, f_high - f_low);
+	temp = div64_ul(temp, f_high - f_low);
 
 	/*
 	 * max_volt_scale has units of uV/MHz while freq values
-- 
2.34.1

