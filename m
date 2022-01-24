Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CD9498E00
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348805AbiAXTif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352897AbiAXTbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09DC561482;
        Mon, 24 Jan 2022 19:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29BEC340E5;
        Mon, 24 Jan 2022 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052673;
        bh=Yfx4afU5U/SUeFI8vDC9AXyMNEsK7W7v+iXmHZLdwWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtaD40NqMM8WNjQRWTmcJwab5y3NB7/EFJP9vj4GWdxt8RbKKZKUU6fjHzl7K9/Mv
         z7DvYPZLL86ipa6ju552f0YJfePmGzTtJrbMRpcu7dfORgkAqVA5WnpycXoFel8zIt
         JU4hx8tHNNJ987E6NR4npcFelJ50B3UDg0Etj2k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/320] mmc: meson-mx-sdio: add IRQ check
Date:   Mon, 24 Jan 2022 19:41:18 +0100
Message-Id: <20220124183956.933670845@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 8fc9a77bc64e1f23d07953439817d8402ac9706f ]

The driver neglects to check the result of platform_get_irq()'s call and
blithely passes the negative error codes to devm_request_threaded_irq()
(which takes *unsigned* IRQ #), causing it to fail with -EINVAL, overriding
an original error code. Stop calling devm_request_threaded_irq() with the
invalid IRQ #s.

Fixes: ed80a13bb4c4 ("mmc: meson-mx-sdio: Add a driver for the Amlogic Meson8 and Meson8b SoC")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20211217202717.10041-3-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-mx-sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/meson-mx-sdio.c b/drivers/mmc/host/meson-mx-sdio.c
index 360d523132bd5..780552a86ec08 100644
--- a/drivers/mmc/host/meson-mx-sdio.c
+++ b/drivers/mmc/host/meson-mx-sdio.c
@@ -665,6 +665,11 @@ static int meson_mx_mmc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto error_free_mmc;
+	}
+
 	ret = devm_request_threaded_irq(host->controller_dev, irq,
 					meson_mx_mmc_irq,
 					meson_mx_mmc_irq_thread, IRQF_ONESHOT,
-- 
2.34.1



