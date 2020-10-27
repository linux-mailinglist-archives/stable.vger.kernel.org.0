Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB82F29B8C2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801868AbgJ0Pov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799909AbgJ0PeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10BBA2225E;
        Tue, 27 Oct 2020 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812840;
        bh=1K4IyKtTGdCKuLc8OaFFPtQR+H0MRKtuszcqdPsT14I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDfRCGOLs9gF9KfbsRw4Z73PJR9i32nYOFdbZ3d26XPTxQtrdPtBnzCe3yVelynvL
         Vu+iZI8WxZZXJc/yTn1F2O5eI6QDfFMEHvkhxwoGPSoc/dPe7L6eiBvLfINp/e+cpC
         bTpeTiLKESQtYHbt3wH9F7qmvHpj9io/4kXWelvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 341/757] coresight: etm4x: Fix save and restore of TRCVMIDCCTLR1 register
Date:   Tue, 27 Oct 2020 14:49:51 +0100
Message-Id: <20201027135506.568961727@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 3477326277451000bc667dfcc4fd0774c039184c ]

In commit f188b5e76aae ("coresight: etm4x: Save/restore state
across CPU low power states"), mistakenly TRCVMIDCCTLR1 register
value was saved in trcvmidcctlr0 state variable which is used to
store TRCVMIDCCTLR0 register value in etm4x_cpu_save() and then
same value is written back to both TRCVMIDCCTLR0 and TRCVMIDCCTLR1
in etm4x_cpu_restore(). There is already a trcvmidcctlr1 state
variable available for TRCVMIDCCTLR1, so use it.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200928163513.70169-26-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 944c7a7cc1d91..fd678792b755d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1237,7 +1237,7 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
 
 	state->trcvmidcctlr0 = readl(drvdata->base + TRCVMIDCCTLR0);
-	state->trcvmidcctlr0 = readl(drvdata->base + TRCVMIDCCTLR1);
+	state->trcvmidcctlr1 = readl(drvdata->base + TRCVMIDCCTLR1);
 
 	state->trcclaimset = readl(drvdata->base + TRCCLAIMCLR);
 
@@ -1347,7 +1347,7 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	writel_relaxed(state->trccidcctlr1, drvdata->base + TRCCIDCCTLR1);
 
 	writel_relaxed(state->trcvmidcctlr0, drvdata->base + TRCVMIDCCTLR0);
-	writel_relaxed(state->trcvmidcctlr0, drvdata->base + TRCVMIDCCTLR1);
+	writel_relaxed(state->trcvmidcctlr1, drvdata->base + TRCVMIDCCTLR1);
 
 	writel_relaxed(state->trcclaimset, drvdata->base + TRCCLAIMSET);
 
-- 
2.25.1



