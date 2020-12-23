Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D5C2E1E4B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgLWPge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgLWPeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4359D23340;
        Wed, 23 Dec 2020 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737595;
        bh=tgkQ2CdyB5JXROwK4Jwqut7hXRS3nEgEUNC4QN/HBIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAPdaceFlNig8r5dEhBu74Ks/8mawaROIH9RJ/zhWMhuQ849QMBfBSxdG07x56Zy1
         cqK1asOtoMkR2CzFGHeajVkvJY4776T7MRleS0e+r4S3XtkftuHqpJAvP+1hyv2jPp
         l4tax1hUzTL6s/J7SIDiYTvopaNM9QLWUGgesCao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 22/40] coresight: etm4x: Fix accesses to TRCPROCSELR
Date:   Wed, 23 Dec 2020 16:33:23 +0100
Message-Id: <20201223150516.617664231@linuxfoundation.org>
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

commit 6288b4ceca868eac4bf729532f8d845e3ecbed98 upstream.

TRCPROCSELR is not implemented if the TRCIDR3.NUMPROC == 0. Skip
accessing the register in such cases.

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-7-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -124,8 +124,8 @@ static int etm4_enable_hw(struct etmv4_d
 	if (coresight_timeout(drvdata->base, TRCSTATR, TRCSTATR_IDLE_BIT, 1))
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
-
-	writel_relaxed(config->pe_sel, drvdata->base + TRCPROCSELR);
+	if (drvdata->nr_pe)
+		writel_relaxed(config->pe_sel, drvdata->base + TRCPROCSELR);
 	writel_relaxed(config->cfg, drvdata->base + TRCCONFIGR);
 	/* nothing specific implemented */
 	writel_relaxed(0x0, drvdata->base + TRCAUXCTLR);
@@ -1180,7 +1180,8 @@ static int etm4_cpu_save(struct etmv4_dr
 	state = drvdata->save_state;
 
 	state->trcprgctlr = readl(drvdata->base + TRCPRGCTLR);
-	state->trcprocselr = readl(drvdata->base + TRCPROCSELR);
+	if (drvdata->nr_pe)
+		state->trcprocselr = readl(drvdata->base + TRCPROCSELR);
 	state->trcconfigr = readl(drvdata->base + TRCCONFIGR);
 	state->trcauxctlr = readl(drvdata->base + TRCAUXCTLR);
 	state->trceventctl0r = readl(drvdata->base + TRCEVENTCTL0R);
@@ -1287,7 +1288,8 @@ static void etm4_cpu_restore(struct etmv
 	writel_relaxed(state->trcclaimset, drvdata->base + TRCCLAIMSET);
 
 	writel_relaxed(state->trcprgctlr, drvdata->base + TRCPRGCTLR);
-	writel_relaxed(state->trcprocselr, drvdata->base + TRCPROCSELR);
+	if (drvdata->nr_pe)
+		writel_relaxed(state->trcprocselr, drvdata->base + TRCPROCSELR);
 	writel_relaxed(state->trcconfigr, drvdata->base + TRCCONFIGR);
 	writel_relaxed(state->trcauxctlr, drvdata->base + TRCAUXCTLR);
 	writel_relaxed(state->trceventctl0r, drvdata->base + TRCEVENTCTL0R);


