Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8280524733E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbgHQPvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbgHQPvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CDEB2072E;
        Mon, 17 Aug 2020 15:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679492;
        bh=aA5Kts/EOMrSJOwXS+IBSah7je7tbYhhRPRHVnVJbmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzHs/NAQoOAAtjxm//IyX1BOF92gWDAoVxRJ9t9pfc5Bly73T1Jsotq9v2MlMh289
         CWWZn4Qku66nei64khRcpMSIVQt5UWIyVajvzQ5N4FdUMUngOetXwoNIwKrZr7Ixsv
         DFAMrtfyhDWtXnSQuZ8Wz6lpECvN+MtmE0rVv0ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 231/393] coresight: etm4x: Fix save/restore during cpu idle
Date:   Mon, 17 Aug 2020 17:14:41 +0200
Message-Id: <20200817143830.831016065@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 342c8a1d1d9e418d32fa02d635cf96989f9a986e ]

The ETM state save/restore incorrectly reads/writes some of the 64bit
registers (e.g, address comparators, vmid/cid comparators etc.) using
32bit accesses. Ensure we use the appropriate width accessors for
the registers.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200716175746.3338735-18-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 16 ++++++++--------
 drivers/hwtracing/coresight/coresight-etm4x.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 942b362a1f220..13c362cddd6a6 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1213,8 +1213,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	}
 
 	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
-		state->trcacvr[i] = readl(drvdata->base + TRCACVRn(i));
-		state->trcacatr[i] = readl(drvdata->base + TRCACATRn(i));
+		state->trcacvr[i] = readq(drvdata->base + TRCACVRn(i));
+		state->trcacatr[i] = readq(drvdata->base + TRCACATRn(i));
 	}
 
 	/*
@@ -1225,10 +1225,10 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	 */
 
 	for (i = 0; i < drvdata->numcidc; i++)
-		state->trccidcvr[i] = readl(drvdata->base + TRCCIDCVRn(i));
+		state->trccidcvr[i] = readq(drvdata->base + TRCCIDCVRn(i));
 
 	for (i = 0; i < drvdata->numvmidc; i++)
-		state->trcvmidcvr[i] = readl(drvdata->base + TRCVMIDCVRn(i));
+		state->trcvmidcvr[i] = readq(drvdata->base + TRCVMIDCVRn(i));
 
 	state->trccidcctlr0 = readl(drvdata->base + TRCCIDCCTLR0);
 	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
@@ -1326,18 +1326,18 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	}
 
 	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
-		writel_relaxed(state->trcacvr[i],
+		writeq_relaxed(state->trcacvr[i],
 			       drvdata->base + TRCACVRn(i));
-		writel_relaxed(state->trcacatr[i],
+		writeq_relaxed(state->trcacatr[i],
 			       drvdata->base + TRCACATRn(i));
 	}
 
 	for (i = 0; i < drvdata->numcidc; i++)
-		writel_relaxed(state->trccidcvr[i],
+		writeq_relaxed(state->trccidcvr[i],
 			       drvdata->base + TRCCIDCVRn(i));
 
 	for (i = 0; i < drvdata->numvmidc; i++)
-		writel_relaxed(state->trcvmidcvr[i],
+		writeq_relaxed(state->trcvmidcvr[i],
 			       drvdata->base + TRCVMIDCVRn(i));
 
 	writel_relaxed(state->trccidcctlr0, drvdata->base + TRCCIDCCTLR0);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index b0d633daf7162..47729e04aac72 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -334,7 +334,7 @@ struct etmv4_save_state {
 	u64	trcacvr[ETM_MAX_SINGLE_ADDR_CMP];
 	u64	trcacatr[ETM_MAX_SINGLE_ADDR_CMP];
 	u64	trccidcvr[ETMv4_MAX_CTXID_CMP];
-	u32	trcvmidcvr[ETM_MAX_VMID_CMP];
+	u64	trcvmidcvr[ETM_MAX_VMID_CMP];
 	u32	trccidcctlr0;
 	u32	trccidcctlr1;
 	u32	trcvmidcctlr0;
-- 
2.25.1



