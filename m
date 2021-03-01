Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9AB32907E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbhCAUIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237563AbhCAUAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3206864EC9;
        Mon,  1 Mar 2021 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621406;
        bh=bmVaea+emYjkZm52DEUbyT/Kp0Nrv+3QUeahUHLXD9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I20LU6g3iQQideDwSm+pC7VIxCLVxlh1N4xRwv6hvUQhIrK5/BHJPL6ObDD65FAWR
         OzwE7IkQFiCaqQpaxRNZRaFiNstYdw+pd2krrbYn/t8i5kdid6nU2hY/MZ0MnKljhc
         Df8nwFDCSDz2DpQiIjpSEEtR8v7phhDAIj2TFBDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Tingwei Zhang <tingwei@codeaurora.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 505/775] coresight: etm4x: Skip accessing TRCPDCR in save/restore
Date:   Mon,  1 Mar 2021 17:11:13 +0100
Message-Id: <20210301161226.470165874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit df81b43802f43c0954a55e5d513e8750a1ab4d31 ]

When the ETM is affected by Qualcomm errata, modifying the
TRCPDCR could cause the system hang. Even though this is
taken care of during enable/disable ETM, the ETM state
save/restore could still access the TRCPDCR. Make sure
we skip the access during the save/restore.

Found by code inspection.

Link: https://lore.kernel.org/r/20210110224850.1880240-3-suzuki.poulose@arm.com
Fixes: 02510a5aa78d ("coresight: etm4x: Add support to skip trace unit power up")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc: Tingwei Zhang <tingwei@codeaurora.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210201181351.1475223-5-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index b20b6ff17cf65..200fa1c8aa0be 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1355,7 +1355,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcclaimset = readl(drvdata->base + TRCCLAIMCLR);
 
-	state->trcpdcr = readl(drvdata->base + TRCPDCR);
+	if (!drvdata->skip_power_up)
+		state->trcpdcr = readl(drvdata->base + TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
 	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 1)) {
@@ -1373,9 +1374,9 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	 * potentially save power on systems that respect the TRCPDCR_PU
 	 * despite requesting software to save/restore state.
 	 */
-	writel_relaxed((state->trcpdcr & ~TRCPDCR_PU),
-			drvdata->base + TRCPDCR);
-
+	if (!drvdata->skip_power_up)
+		writel_relaxed((state->trcpdcr & ~TRCPDCR_PU),
+				drvdata->base + TRCPDCR);
 out:
 	CS_LOCK(drvdata->base);
 	return ret;
@@ -1469,7 +1470,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	writel_relaxed(state->trcclaimset, drvdata->base + TRCCLAIMSET);
 
-	writel_relaxed(state->trcpdcr, drvdata->base + TRCPDCR);
+	if (!drvdata->skip_power_up)
+		writel_relaxed(state->trcpdcr, drvdata->base + TRCPDCR);
 
 	drvdata->state_needs_restore = false;
 
-- 
2.27.0



