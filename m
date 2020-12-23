Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EBD2E1E17
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgLWPeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgLWPef (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 922C323382;
        Wed, 23 Dec 2020 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737598;
        bh=7RVfjl/KNWMrR4HzNnolRlL8h78aEhowNgRbnHZ0Gak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sndp78AH8DHbEOoE/olxI6a1fruDmGm/QnuGBItlr4KGyILzLe1zIyXjdpC3C4keS
         LeFpCEiqhRAjGNTJFYOBtW68uxbGYLNCJyTfdumc/njqjhGgBAxhNNRyvnKKB2S3Kc
         QBc5pr69W6cz78v6UuzjZWrzEALwdyc9glVO0OdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 23/40] coresight: etm4x: Handle TRCVIPCSSCTLR accesses
Date:   Wed, 23 Dec 2020 16:33:24 +0100
Message-Id: <20201223150516.668717311@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 60c519c5d3629c21ba356782434d5b612d312de4 upstream.

TRCVIPCSSCTLR is not present if the TRCIDR4.NUMPC > 0. Thus we
should only access the register if it is present, preventing
any undesired behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-8-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -141,8 +141,9 @@ static int etm4_enable_hw(struct etmv4_d
 	writel_relaxed(config->viiectlr, drvdata->base + TRCVIIECTLR);
 	writel_relaxed(config->vissctlr,
 		       drvdata->base + TRCVISSCTLR);
-	writel_relaxed(config->vipcssctlr,
-		       drvdata->base + TRCVIPCSSCTLR);
+	if (drvdata->nr_pe_cmp)
+		writel_relaxed(config->vipcssctlr,
+			       drvdata->base + TRCVIPCSSCTLR);
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		writel_relaxed(config->seq_ctrl[i],
 			       drvdata->base + TRCSEQEVRn(i));
@@ -1197,7 +1198,8 @@ static int etm4_cpu_save(struct etmv4_dr
 	state->trcvictlr = readl(drvdata->base + TRCVICTLR);
 	state->trcviiectlr = readl(drvdata->base + TRCVIIECTLR);
 	state->trcvissctlr = readl(drvdata->base + TRCVISSCTLR);
-	state->trcvipcssctlr = readl(drvdata->base + TRCVIPCSSCTLR);
+	if (drvdata->nr_pe_cmp)
+		state->trcvipcssctlr = readl(drvdata->base + TRCVIPCSSCTLR);
 	state->trcvdctlr = readl(drvdata->base + TRCVDCTLR);
 	state->trcvdsacctlr = readl(drvdata->base + TRCVDSACCTLR);
 	state->trcvdarcctlr = readl(drvdata->base + TRCVDARCCTLR);
@@ -1305,7 +1307,8 @@ static void etm4_cpu_restore(struct etmv
 	writel_relaxed(state->trcvictlr, drvdata->base + TRCVICTLR);
 	writel_relaxed(state->trcviiectlr, drvdata->base + TRCVIIECTLR);
 	writel_relaxed(state->trcvissctlr, drvdata->base + TRCVISSCTLR);
-	writel_relaxed(state->trcvipcssctlr, drvdata->base + TRCVIPCSSCTLR);
+	if (drvdata->nr_pe_cmp)
+		writel_relaxed(state->trcvipcssctlr, drvdata->base + TRCVIPCSSCTLR);
 	writel_relaxed(state->trcvdctlr, drvdata->base + TRCVDCTLR);
 	writel_relaxed(state->trcvdsacctlr, drvdata->base + TRCVDSACCTLR);
 	writel_relaxed(state->trcvdarcctlr, drvdata->base + TRCVDARCCTLR);


