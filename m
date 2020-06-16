Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD011FB6DC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgFPPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbgFPPlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D887C208E4;
        Tue, 16 Jun 2020 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322074;
        bh=5um46MZsFbpHaxkZUw61HJPn4afteMOpE3jDZSIxDbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bc0zQqCXadtMqxy2wfdOQTLsQToUbTZaV4PIV/5h5pB1uSjwzPxG3FR+Lhpb3C9/u
         ZUFzt2nmVawcyFjyqyJda7HE9ohlFxsDhfAjCA/JjqJJ4n66xh9Vgb0oeAUuIbH/gf
         22ZE18dHHGN16OZYrMtBWxxDWf33tc/Uic5jqvhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 126/134] mmc: tmio: Further fixup runtime PM management at remove
Date:   Tue, 16 Jun 2020 17:35:10 +0200
Message-Id: <20200616153106.821340873@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 4bd784411aca022622e484eb262f5a0540ae732c upstream.

Before calling tmio_mmc_host_probe(), the caller is required to enable
clocks for its device, as to make it accessible when reading/writing
registers during probe.

Therefore, the responsibility to disable these clocks, in the error path of
->probe() and during ->remove(), is better managed outside
tmio_mmc_host_remove(). As a matter of fact, callers of
tmio_mmc_host_remove() already expects this to be the behaviour.

However, there's a problem with tmio_mmc_host_remove() when the Kconfig
option, CONFIG_PM, is set. More precisely, tmio_mmc_host_remove() may then
disable the clock via runtime PM, which leads to clock enable/disable
imbalance problems, when the caller of tmio_mmc_host_remove() also tries to
disable the same clocks.

To solve the problem, let's make sure tmio_mmc_host_remove() leaves the
device with clocks enabled, but also make sure to disable the IRQs, as we
normally do at ->runtime_suspend().

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200519152434.6867-1-ulf.hansson@linaro.org
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/tmio_mmc_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -1285,12 +1285,14 @@ void tmio_mmc_host_remove(struct tmio_mm
 	cancel_work_sync(&host->done);
 	cancel_delayed_work_sync(&host->delayed_reset_work);
 	tmio_mmc_release_dma(host);
+	tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
 
-	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	if (host->native_hotplug)
 		pm_runtime_put_noidle(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
+
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(tmio_mmc_host_remove);
 


