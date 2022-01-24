Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD090499784
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387577AbiAXVNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446883AbiAXVJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DBCCB80FA1;
        Mon, 24 Jan 2022 21:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B1EC340E5;
        Mon, 24 Jan 2022 21:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058575;
        bh=zYvhXmgk5raJcaWJoqoTorEjCgspp2OTg+ecp5a6CF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hjEWtHRioKA9xbNHNNnCCd+350ZLeg/N+5D0CjFdxzrL992o7rO4QhO8BNoATinN
         V4CkSbzoex7beFE6imUrrZGzi7r+oziw66G1b5DTggwuypVjHgDTcFvOXjMdoYdvmE
         nqYOvJm4DkSS0dSr+qdOWj8v2mnGrThvzEPAGGuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0332/1039] mmc: meson-mx-sdhc: add IRQ check
Date:   Mon, 24 Jan 2022 19:35:21 +0100
Message-Id: <20220124184136.470730761@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 77bed755e0f06135faccdd3948863703f9a6e640 ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_threaded_irq()
(which takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code. Stop calling devm_request_threaded_irq() with the
invalid IRQ #s.

Fixes: e4bf1b0970ef ("mmc: host: meson-mx-sdhc: new driver for the Amlogic Meson SDHC host")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20211217202717.10041-2-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-mx-sdhc-mmc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/meson-mx-sdhc-mmc.c b/drivers/mmc/host/meson-mx-sdhc-mmc.c
index 8fdd0bbbfa21f..28aa78aa08f3f 100644
--- a/drivers/mmc/host/meson-mx-sdhc-mmc.c
+++ b/drivers/mmc/host/meson-mx-sdhc-mmc.c
@@ -854,6 +854,11 @@ static int meson_mx_sdhc_probe(struct platform_device *pdev)
 		goto err_disable_pclk;
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto err_disable_pclk;
+	}
+
 	ret = devm_request_threaded_irq(dev, irq, meson_mx_sdhc_irq,
 					meson_mx_sdhc_irq_thread, IRQF_ONESHOT,
 					NULL, host);
-- 
2.34.1



