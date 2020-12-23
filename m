Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161912E1E07
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgLWPeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgLWPeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD84E23381;
        Wed, 23 Dec 2020 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737591;
        bh=ZedZKbMJqx55QuPuIzHkL77G2DoZZJhKEZNIs1Nag8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRJtrii21ZsqCvOOFNae6uji8wfvn3gwqNlD2ogoDN/sTBLzYeFomjiOcl9CtTPs7
         sZR+2tgW/tKPV7Jvx2QgkQUuRIuDhIfckv6FZLx6vb66uWdpRAlaNkSYV1/lNImQO4
         OtfOEJb5OWu/pms/xCnQCdhNB6tlflTHvw/mMnDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 21/40] coresight: etm4x: Fix accesses to TRCCIDCTLR1
Date:   Wed, 23 Dec 2020 16:33:22 +0100
Message-Id: <20201223150516.566047670@linuxfoundation.org>
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

commit f2603b22e3d2dcffd8b0736e5c68df497af6bc84 upstream.

The TRCCIDCTLR1 is only implemented if TRCIDR4.NUMCIDC > 4.
Don't touch the register if it is not implemented.

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-5-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -187,7 +187,8 @@ static int etm4_enable_hw(struct etmv4_d
 		writeq_relaxed(config->ctxid_pid[i],
 			       drvdata->base + TRCCIDCVRn(i));
 	writel_relaxed(config->ctxid_mask0, drvdata->base + TRCCIDCCTLR0);
-	writel_relaxed(config->ctxid_mask1, drvdata->base + TRCCIDCCTLR1);
+	if (drvdata->numcidc > 4)
+		writel_relaxed(config->ctxid_mask1, drvdata->base + TRCCIDCCTLR1);
 
 	for (i = 0; i < drvdata->numvmidc; i++)
 		writeq_relaxed(config->vmid_val[i],
@@ -1241,7 +1242,8 @@ static int etm4_cpu_save(struct etmv4_dr
 		state->trcvmidcvr[i] = readq(drvdata->base + TRCVMIDCVRn(i));
 
 	state->trccidcctlr0 = readl(drvdata->base + TRCCIDCCTLR0);
-	state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
+	if (drvdata->numcidc > 4)
+		state->trccidcctlr1 = readl(drvdata->base + TRCCIDCCTLR1);
 
 	state->trcvmidcctlr0 = readl(drvdata->base + TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
@@ -1352,7 +1354,8 @@ static void etm4_cpu_restore(struct etmv
 			       drvdata->base + TRCVMIDCVRn(i));
 
 	writel_relaxed(state->trccidcctlr0, drvdata->base + TRCCIDCCTLR0);
-	writel_relaxed(state->trccidcctlr1, drvdata->base + TRCCIDCCTLR1);
+	if (drvdata->numcidc > 4)
+		writel_relaxed(state->trccidcctlr1, drvdata->base + TRCCIDCCTLR1);
 
 	writel_relaxed(state->trcvmidcctlr0, drvdata->base + TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)


