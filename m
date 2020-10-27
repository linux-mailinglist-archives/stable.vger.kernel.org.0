Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBF29B8D9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802042AbgJ0Pp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799555AbgJ0PcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624AA2225E;
        Tue, 27 Oct 2020 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812727;
        bh=lPLX86Ro39x7+XZhUq2XZLtFZl4XdcG0kDoiZVJXl2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMO7CzjJnEJ01b5Ep+rbfioV5WoW5YaGls8BS8DqeZ+MLsN9QGXKjHrl7qAVNfSrT
         tEkA6BC4ezligci+5GNprGDcQZ1fSqNmuEJM53uEf0AOGJPoLyI9ia38AkBFuh4v2b
         C1oDMdcxcIxAtN8/rnjMhmp5X5sWYiP7dz7d0THk=
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
Subject: [PATCH 5.9 279/757] coresight: etm4x: Fix issues on trcseqevr access
Date:   Tue, 27 Oct 2020 14:48:49 +0100
Message-Id: <20201027135503.670029580@linuxfoundation.org>
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
index 2bcc8d4a82c8e..944c7a7cc1d91 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1193,7 +1193,7 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcvdsacctlr = readl(drvdata->base + TRCVDSACCTLR);
 	state->trcvdarcctlr = readl(drvdata->base + TRCVDARCCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate; i++)
+	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		state->trcseqevr[i] = readl(drvdata->base + TRCSEQEVRn(i));
 
 	state->trcseqrstevr = readl(drvdata->base + TRCSEQRSTEVR);
@@ -1298,7 +1298,7 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	writel_relaxed(state->trcvdsacctlr, drvdata->base + TRCVDSACCTLR);
 	writel_relaxed(state->trcvdarcctlr, drvdata->base + TRCVDARCCTLR);
 
-	for (i = 0; i < drvdata->nrseqstate; i++)
+	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		writel_relaxed(state->trcseqevr[i],
 			       drvdata->base + TRCSEQEVRn(i));
 
-- 
2.25.1



