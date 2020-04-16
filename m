Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52851ACBF0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635869AbgDPPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896106AbgDPNcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629922222D;
        Thu, 16 Apr 2020 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043900;
        bh=/pRuMGAn0u2C8xDQzhfpisUenw8c2eLcIQtdrCXZSKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9ABYin6oNrEAi6x7OxIZRY/DMs0unW0lnbG6XLunpFtZz1p6CUiPxOtlMVSlEsJ5
         q0lF9fWne/D9oFm7M8VFiMiMmE3luaVia66qQl9YP6mYe0UmvKOgacias+7gHRbdb7
         zbgJCAXOPv4LpvbxNx7Y2xhNJGw5LkrLs0pP+Tkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/146] etnaviv: perfmon: fix total and idle HI cyleces readout
Date:   Thu, 16 Apr 2020 15:24:47 +0200
Message-Id: <20200416131302.322010649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gmeiner <christian.gmeiner@gmail.com>

[ Upstream commit 15ff4a7b584163b12b118a2c381529f05ff3a94d ]

As seen at CodeAurora's linux-imx git repo in imx_4.19.35_1.0.0 branch.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 43 +++++++++++++++++------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
index f86cb66a84b9c..3ce77cbad4ae3 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -37,13 +37,6 @@ struct etnaviv_pm_domain_meta {
 	u32 nr_domains;
 };
 
-static u32 simple_reg_read(struct etnaviv_gpu *gpu,
-	const struct etnaviv_pm_domain *domain,
-	const struct etnaviv_pm_signal *signal)
-{
-	return gpu_read(gpu, signal->data);
-}
-
 static u32 perf_reg_read(struct etnaviv_gpu *gpu,
 	const struct etnaviv_pm_domain *domain,
 	const struct etnaviv_pm_signal *signal)
@@ -77,6 +70,34 @@ static u32 pipe_reg_read(struct etnaviv_gpu *gpu,
 	return value;
 }
 
+static u32 hi_total_cycle_read(struct etnaviv_gpu *gpu,
+	const struct etnaviv_pm_domain *domain,
+	const struct etnaviv_pm_signal *signal)
+{
+	u32 reg = VIVS_HI_PROFILE_TOTAL_CYCLES;
+
+	if (gpu->identity.model == chipModel_GC880 ||
+		gpu->identity.model == chipModel_GC2000 ||
+		gpu->identity.model == chipModel_GC2100)
+		reg = VIVS_MC_PROFILE_CYCLE_COUNTER;
+
+	return gpu_read(gpu, reg);
+}
+
+static u32 hi_total_idle_cycle_read(struct etnaviv_gpu *gpu,
+	const struct etnaviv_pm_domain *domain,
+	const struct etnaviv_pm_signal *signal)
+{
+	u32 reg = VIVS_HI_PROFILE_IDLE_CYCLES;
+
+	if (gpu->identity.model == chipModel_GC880 ||
+		gpu->identity.model == chipModel_GC2000 ||
+		gpu->identity.model == chipModel_GC2100)
+		reg = VIVS_HI_PROFILE_TOTAL_CYCLES;
+
+	return gpu_read(gpu, reg);
+}
+
 static const struct etnaviv_pm_domain doms_3d[] = {
 	{
 		.name = "HI",
@@ -86,13 +107,13 @@ static const struct etnaviv_pm_domain doms_3d[] = {
 		.signal = (const struct etnaviv_pm_signal[]) {
 			{
 				"TOTAL_CYCLES",
-				VIVS_HI_PROFILE_TOTAL_CYCLES,
-				&simple_reg_read
+				0,
+				&hi_total_cycle_read
 			},
 			{
 				"IDLE_CYCLES",
-				VIVS_HI_PROFILE_IDLE_CYCLES,
-				&simple_reg_read
+				0,
+				&hi_total_idle_cycle_read
 			},
 			{
 				"AXI_CYCLES_READ_REQUEST_STALLED",
-- 
2.20.1



