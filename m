Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD6B5C52
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfIRGZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbfIRGZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00FA21920;
        Wed, 18 Sep 2019 06:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787917;
        bh=dYQnHfr6ZvMChLC33ncBlJbHNAlWvdOxIzicHEF1M9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAoLRo73ms7qCguVtRLajFSyQYLlK3/bHPZXG736MtuZMTnRvHY3U6OUjDDlow1V1
         aY2kybJQqClYNFPbEY9khj9W/dahtOW8c4hCY4p8souiuwF2nwSiboRsFLlz8TWneH
         NlAyC+k9D8oWocOxIFC4z8T1ebqPW5zOmAmL+6Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.2 30/85] mmc: tmio: Fixup runtime PM management during probe
Date:   Wed, 18 Sep 2019 08:18:48 +0200
Message-Id: <20190918061235.108832140@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit aa86f1a3887523d78bfadd1c4e4df8f919336511 upstream.

The tmio_mmc_host_probe() calls pm_runtime_set_active() to update the
runtime PM status of the device, as to make it reflect the current status
of the HW. This works fine for most cases, but unfortunate not for all.
Especially, there is a generic problem when the device has a genpd attached
and that genpd have the ->start|stop() callbacks assigned.

More precisely, if the driver calls pm_runtime_set_active() during
->probe(), genpd does not get to invoke the ->start() callback for it,
which means the HW isn't really fully powered on. Furthermore, in the next
phase, when the device becomes runtime suspended, genpd will invoke the
->stop() callback for it, potentially leading to usage count imbalance
problems, depending on what's implemented behind the callbacks of course.

To fix this problem, convert to call pm_runtime_get_sync() from
tmio_mmc_host_probe() rather than pm_runtime_set_active(). Additionally, to
avoid bumping usage counters and unnecessary re-initializing the HW the
first time the tmio driver's ->runtime_resume() callback is called,
introduce a state flag to keeping track of this.

Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/tmio_mmc.h      |    1 +
 drivers/mmc/host/tmio_mmc_core.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -163,6 +163,7 @@ struct tmio_mmc_host {
 	unsigned long		last_req_ts;
 	struct mutex		ios_lock;	/* protect set_ios() context */
 	bool			native_hotplug;
+	bool			runtime_synced;
 	bool			sdio_irq_enabled;
 
 	/* Mandatory callback */
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -1258,20 +1258,22 @@ int tmio_mmc_host_probe(struct tmio_mmc_
 	/* See if we also get DMA */
 	tmio_mmc_request_dma(_host, pdata);
 
-	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
 
 	ret = mmc_add_host(mmc);
 	if (ret)
 		goto remove_host;
 
 	dev_pm_qos_expose_latency_limit(&pdev->dev, 100);
+	pm_runtime_put(&pdev->dev);
 
 	return 0;
 
 remove_host:
+	pm_runtime_put_noidle(&pdev->dev);
 	tmio_mmc_host_remove(_host);
 	return ret;
 }
@@ -1340,6 +1342,11 @@ int tmio_mmc_host_runtime_resume(struct
 {
 	struct tmio_mmc_host *host = dev_get_drvdata(dev);
 
+	if (!host->runtime_synced) {
+		host->runtime_synced = true;
+		return 0;
+	}
+
 	tmio_mmc_clk_enable(host);
 	tmio_mmc_hw_reset(host->mmc);
 


