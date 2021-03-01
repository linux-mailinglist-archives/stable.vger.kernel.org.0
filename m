Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540BB328CAB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhCAS4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240631AbhCASsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:48:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF5365279;
        Mon,  1 Mar 2021 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619825;
        bh=Q1lX0AQ/A87HqSnarxMVKysYgGUzDGZv3tDnwIiRUvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g71PDteB/EY8hH01xM7job7uwF0mWMUUYs8XUchF23XVMs1l8kT94bfsYbaoFRNWX
         6wjxv520n8B9vEqMCp+rSgdFQkNcl+rxdQ6Z51O4zE4u0/S69p45knmYI7X85T/jOg
         2Uf49Hyn+2n/hfN3wmBw1Z076sHLYHkglnbI1+ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 587/663] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Date:   Mon,  1 Mar 2021 17:13:55 +0100
Message-Id: <20210301161210.904597069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit f72896063396b0cb205cbf0fd76ec6ab3ca11c8a upstream.

TRCSTALLCTLR register is only implemented if

   TRCIDR3.STALLCTL == 0b1

Make sure the driver touches the register only it is implemented.

Link: https://lore.kernel.org/r/20210127184617.3684379-1-suzuki.poulose@arm.com
Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210201181351.1475223-32-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  |    9 ++++++---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -131,7 +131,8 @@ static int etm4_enable_hw(struct etmv4_d
 	writel_relaxed(0x0, drvdata->base + TRCAUXCTLR);
 	writel_relaxed(config->eventctrl0, drvdata->base + TRCEVENTCTL0R);
 	writel_relaxed(config->eventctrl1, drvdata->base + TRCEVENTCTL1R);
-	writel_relaxed(config->stall_ctrl, drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		writel_relaxed(config->stall_ctrl, drvdata->base + TRCSTALLCTLR);
 	writel_relaxed(config->ts_ctrl, drvdata->base + TRCTSCTLR);
 	writel_relaxed(config->syncfreq, drvdata->base + TRCSYNCPR);
 	writel_relaxed(config->ccctlr, drvdata->base + TRCCCCTLR);
@@ -1187,7 +1188,8 @@ static int etm4_cpu_save(struct etmv4_dr
 	state->trcauxctlr = readl(drvdata->base + TRCAUXCTLR);
 	state->trceventctl0r = readl(drvdata->base + TRCEVENTCTL0R);
 	state->trceventctl1r = readl(drvdata->base + TRCEVENTCTL1R);
-	state->trcstallctlr = readl(drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		state->trcstallctlr = readl(drvdata->base + TRCSTALLCTLR);
 	state->trctsctlr = readl(drvdata->base + TRCTSCTLR);
 	state->trcsyncpr = readl(drvdata->base + TRCSYNCPR);
 	state->trcccctlr = readl(drvdata->base + TRCCCCTLR);
@@ -1297,7 +1299,8 @@ static void etm4_cpu_restore(struct etmv
 	writel_relaxed(state->trcauxctlr, drvdata->base + TRCAUXCTLR);
 	writel_relaxed(state->trceventctl0r, drvdata->base + TRCEVENTCTL0R);
 	writel_relaxed(state->trceventctl1r, drvdata->base + TRCEVENTCTL1R);
-	writel_relaxed(state->trcstallctlr, drvdata->base + TRCSTALLCTLR);
+	if (drvdata->stallctl)
+		writel_relaxed(state->trcstallctlr, drvdata->base + TRCSTALLCTLR);
 	writel_relaxed(state->trctsctlr, drvdata->base + TRCTSCTLR);
 	writel_relaxed(state->trcsyncpr, drvdata->base + TRCSYNCPR);
 	writel_relaxed(state->trcccctlr, drvdata->base + TRCCCCTLR);
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -389,7 +389,7 @@ static ssize_t mode_store(struct device
 		config->eventctrl1 &= ~BIT(12);
 
 	/* bit[8], Instruction stall bit */
-	if (config->mode & ETM_MODE_ISTALL_EN)
+	if ((config->mode & ETM_MODE_ISTALL_EN) && (drvdata->stallctl == true))
 		config->stall_ctrl |= BIT(8);
 	else
 		config->stall_ctrl &= ~BIT(8);


