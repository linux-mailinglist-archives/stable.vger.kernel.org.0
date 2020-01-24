Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD536147FE0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbgAXLFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388175AbgAXLFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:48 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1261E20663;
        Fri, 24 Jan 2020 11:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863947;
        bh=MLtqrV57XfQ+KUQpx8Pp5CouItB7JmIkLdZToxk/szs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhAk+wx0WPbG1ihzYe+1mn5TQ0lXgbgl6gCvAwrhDfUs/aBdtRi60qPP58sBVmW/r
         huJ9R58/Sfqwk11RHMP7nfsN3zCZPjkfvI6n6NBMHamZMAhc9undPNBdjNoWpMEHq5
         pxl3+9em9wreKVbM/8sM/aEuytTTpsb3JpjzEaV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/639] remoteproc: qcom: q6v5-mss: Add missing clocks for MSM8996
Date:   Fri, 24 Jan 2020 10:24:47 +0100
Message-Id: <20200124093101.974162137@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6a84b6372897d..073747ba80002 100644
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



