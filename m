Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E474990F5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354252AbiAXUIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:08:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357770AbiAXTvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:51:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2295601B6;
        Mon, 24 Jan 2022 19:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A27C340E5;
        Mon, 24 Jan 2022 19:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053905;
        bh=zYvhXmgk5raJcaWJoqoTorEjCgspp2OTg+ecp5a6CF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bB4AhEl+8eQuy7HCEyDEQ7mwvUpZAjTw0YTmHsVVOBjr089i5Kk3RZY4TUjRcEmQx
         yk2iN7IvGFcpYr2f4N2wzdehzcqqQj94Bd9z8yEsH+rtFc+0g+KMeDepXTUgnmGj+5
         sRbECibJ0ccO/ilp3Uf5V4UTNBqxvQrFC4FgTN9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/563] mmc: meson-mx-sdhc: add IRQ check
Date:   Mon, 24 Jan 2022 19:39:07 +0100
Message-Id: <20220124184030.714161210@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



