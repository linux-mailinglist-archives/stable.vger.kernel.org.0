Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9912E1E02
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgLWPeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgLWPeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B02B23380;
        Wed, 23 Dec 2020 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737588;
        bh=VgYlDfnwE0rAZNUK2ngteYoKwutnUt5lyGNuyiPdz5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQLI0inSW3coezhYRm8UGW38p8RTcZFchLyLJcae/zfj4nijb/fmjDAnqjdp+6fx8
         FdlY+ywpW89eK9QZ6XOsun36Sq6eswkuNkkdNRJzDT996InnRmpDR9LNZpi41PgwJU
         VWa8HcRE8Y0HREgppMFy0rnSFHJK/Mu//9G49hbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 20/40] coresight: etm4x: Fix accesses to TRCVMIDCTLR1
Date:   Wed, 23 Dec 2020 16:33:21 +0100
Message-Id: <20201223150516.520852368@linuxfoundation.org>
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

commit 93dd64404cbe63b0afba371acd8db36e84b286c7 upstream.

TRCVMIDCTRL1 is only implemented only if the TRCIDR4.NUMVMIDC > 4.
We must not touch the register otherwise.

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-4-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -193,7 +193,8 @@ static int etm4_enable_hw(struct etmv4_d
 		writeq_relaxed(config->vmid_val[i],
 			       drvdata->base + TRCVMIDCVRn(i));
 	writel_relaxed(config->vmid_mask0, drvdata->base + TRCVMIDCCTLR0);
-	writel_relaxed(config->vmid_mask1, drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		writel_relaxed(config->vmid_mask1, drvdata->base + TRCVMIDCCTLR1);
 
 	if (!drvdata->skip_power_up) {
 		/*
@@ -1243,7 +1244,8 @@ static int etm4_cpu_save(struct etmv4_dr
 	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
 
 	state->trcvmidcctlr0 = readl(drvdata->base + TRCVMIDCCTLR0);
-	state->trcvmidcctlr1 = readl(drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		state->trcvmidcctlr1 = readl(drvdata->base + TRCVMIDCCTLR1);
 
 	state->trcclaimset = readl(drvdata->base + TRCCLAIMCLR);
 
@@ -1353,7 +1355,8 @@ static void etm4_cpu_restore(struct etmv
 	writel_relaxed(state->trccidcctlr1, drvdata->base + TRCCIDCCTLR1);
 
 	writel_relaxed(state->trcvmidcctlr0, drvdata->base + TRCVMIDCCTLR0);
-	writel_relaxed(state->trcvmidcctlr1, drvdata->base + TRCVMIDCCTLR1);
+	if (drvdata->numvmidc > 4)
+		writel_relaxed(state->trcvmidcctlr1, drvdata->base + TRCVMIDCCTLR1);
 
 	writel_relaxed(state->trcclaimset, drvdata->base + TRCCLAIMSET);
 


