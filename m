Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E01FBAF7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgFPQPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730630AbgFPPlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BEC5207C4;
        Tue, 16 Jun 2020 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322079;
        bh=WhB8wqDXsccYzqQ2R4iFnNEDS50yOon3Np6rrhti2b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMV/XrxdJ+A2K4w9F+8qC2kV6gMnhSQ5bDBvly+RFiHiY47Kd9qBmuMx63FHIHsU3
         /QD5mqQ4OO8DqH2jaJ/OOMNuxarPSXIIpabd+ZZpe2fmjLEMPvg+h2TpWD27eeAoi0
         KDviqZ9AlytdBRaDsoC+ASkge+/Z8MpP56AfjkD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 127/134] mmc: uniphier-sd: call devm_request_irq() after tmio_mmc_host_probe()
Date:   Tue, 16 Jun 2020 17:35:11 +0200
Message-Id: <20200616153106.869210030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 5d1f42e14b135773c0cc1d82e904c5b223783a9d upstream.

Currently, tmio_mmc_irq() handler is registered before the host is
fully initialized by tmio_mmc_host_probe(). I did not previously notice
this problem.

The boot ROM of a new Socionext SoC unmasks interrupts (CTL_IRQ_MASK)
somehow. The handler is invoked before tmio_mmc_host_probe(), then
emits noisy call trace.

Move devm_request_irq() below tmio_mmc_host_probe().

Fixes: 3fd784f745dd ("mmc: uniphier-sd: add UniPhier SD/eMMC controller driver")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200511062158.1790924-1-yamada.masahiro@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/uniphier-sd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/uniphier-sd.c
+++ b/drivers/mmc/host/uniphier-sd.c
@@ -614,11 +614,6 @@ static int uniphier_sd_probe(struct plat
 		}
 	}
 
-	ret = devm_request_irq(dev, irq, tmio_mmc_irq, IRQF_SHARED,
-			       dev_name(dev), host);
-	if (ret)
-		goto free_host;
-
 	if (priv->caps & UNIPHIER_SD_CAP_EXTENDED_IP)
 		host->dma_ops = &uniphier_sd_internal_dma_ops;
 	else
@@ -646,8 +641,15 @@ static int uniphier_sd_probe(struct plat
 	if (ret)
 		goto free_host;
 
+	ret = devm_request_irq(dev, irq, tmio_mmc_irq, IRQF_SHARED,
+			       dev_name(dev), host);
+	if (ret)
+		goto remove_host;
+
 	return 0;
 
+remove_host:
+	tmio_mmc_host_remove(host);
 free_host:
 	tmio_mmc_host_free(host);
 


