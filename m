Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38213E2AB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgAPQ5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733228AbgAPQ53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAF121582;
        Thu, 16 Jan 2020 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193848;
        bh=57e9JMOh/+P+iNeORr19G0sF5KFEp/5BykYmob0hcZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrgI9tN4WDQ70CJEca31vIbMx88cVWY4OOj4DDa38dzEWDuTeogoOeJ0adzEQUBRA
         /+hJ9p/PdW4AOFNDj537NY6FOi7Tz5MvXj7hSbsdWFVIkCoIU0QiwP6QU8w/7WB7+n
         BngZDAZLnrH5OIQu3LqEpqz3mZdapzxbY+OiuhSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 100/671] remoteproc: qcom: q6v5-mss: Add missing clocks for MSM8996
Date:   Thu, 16 Jan 2020 11:45:31 -0500
Message-Id: <20200116165502.8838-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 80ec419c3404106c563aaf56aa6b516a59c4cdfb ]

Proxy vote for QDSS clock and remove vote on handover interrupt
to provide MSS PBL with access to STM hardware registers during
boot. Add "snoc_axi" and "mnoc_axi" to the active clock list.
Rename "gpll0_mss_clk" to "gpll0_mss" for consistency across SoCs.

Fixes: 9f058fa2efb1 ("remoteproc: qcom: Add support for mss remoteproc on msm8996")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pil.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pil.c b/drivers/remoteproc/qcom_q6v5_pil.c
index 6a84b6372897..073747ba8000 100644
--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -1271,13 +1271,16 @@ static const struct rproc_hexagon_res msm8996_mss = {
 	.proxy_clk_names = (char*[]){
 			"xo",
 			"pnoc",
+			"qdss",
 			NULL
 	},
 	.active_clk_names = (char*[]){
 			"iface",
 			"bus",
 			"mem",
-			"gpll0_mss_clk",
+			"gpll0_mss",
+			"snoc_axi",
+			"mnoc_axi",
 			NULL
 	},
 	.need_mem_protection = true,
-- 
2.20.1

