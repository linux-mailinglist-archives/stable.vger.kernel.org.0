Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D729B424
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783629AbgJ0O6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783610AbgJ0O6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F19223FB;
        Tue, 27 Oct 2020 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810711;
        bh=70cIyWmGeRFSy4VJs/77CDY3anM54CAtlGO4o3NQJxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guNYtDzMQPw92IQsGpAvlzW8895Ory/afnYmn+2cH+hqlDCUXFTV9eKgfGTCmy607
         VW6EKbDgGJiet9zjwB2+RczRZMEcWeAgRUFdQEVouvFye02f0auR9A/xyi+wneo8Db
         GLg2Prgj1wwjkD6SKKXGl9C/KIuQNh5vJ9gFwzkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Jonathan Zhou <jonathan.zhouwen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 236/633] coresight: etm4x: Fix issues on trcseqevr access
Date:   Tue, 27 Oct 2020 14:49:39 +0100
Message-Id: <20201027135533.754830688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Zhou <jonathan.zhouwen@huawei.com>

[ Upstream commit 4cd83037cd957ad97756055355ab4ee63f259380 ]

The TRCSEQEVR(3) is reserved, using '@nrseqstate - 1' instead to avoid
accessing the reserved register.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Jonathan Zhou <jonathan.zhouwen@huawei.com>
[Fixed capital letter in title]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-12-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 7a247273b7e0a..d6395aeffd99d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1189,7 +1189,7 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcvdsacctlr = readl(drvdata->base + TRCVDSACCTLR);
 	state->trcvdarcctlr = readl(drvdata->base + TRCVDARCCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate; i++)
+	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		state->trcseqevr[i] = readl(drvdata->base + TRCSEQEVRn(i));
 
 	state->trcseqrstevr = readl(drvdata->base + TRCSEQRSTEVR);
@@ -1294,7 +1294,7 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	writel_relaxed(state->trcvdsacctlr, drvdata->base + TRCVDSACCTLR);
 	writel_relaxed(state->trcvdarcctlr, drvdata->base + TRCVDARCCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate; i++)
+	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		writel_relaxed(state->trcseqevr[i],
 			       drvdata->base + TRCSEQEVRn(i));
 
-- 
2.25.1



