Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F52E3ED2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504145AbgL1Oc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504268AbgL1ObQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B37C9224D2;
        Mon, 28 Dec 2020 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165835;
        bh=LZbsRTNfyipWlt62IAHs/xUjkfhbs4vXw0w9V/XxFWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjp9BNFHER5Qph+xBDcMGW0SuS8XdqvnUIcS/73Nq7O756ExxU4cIvSsZ7Zmkdt4d
         xh7n921DUyBzOs/+JVqwXpe+T+91SiV/Tls23Y1LnKqggJqEX+c0j9GBz46VdKBPBv
         PFjTOnmDrjJ69Kd5E2o62llJXQZdT2gzzFaZAapo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Ikjoon Jang <ikjn@chromium.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 644/717] spi: spi-mtk-nor: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:42 +0100
Message-Id: <20201228125051.792207212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 0f4ad8d59f33b24dd86739f3be23e6af1a86f5a9 upstream.

If the call to devm_spi_register_controller() fails on probe of the
MediaTek SPI NOR driver, the spi_controller struct is erroneously not
freed.

Since commit a1daaa991ed1 ("spi: spi-mtk-nor: use dma_alloc_coherent()
for bounce buffer"), the same happens if the call to
dmam_alloc_coherent() fails.

Since commit 3bfd9103c7af ("spi: spi-mtk-nor: Add power management
support"), the same happens if the call to mtk_nor_enable_clk() fails.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: 881d1ee9fe81 ("spi: add support for mediatek spi-nor controller")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ikjoon Jang <ikjn@chromium.org>
Cc: <stable@vger.kernel.org> # v5.7+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.7+
Cc: Chuanhong Guo <gch981213@gmail.com>
Link: https://lore.kernel.org/r/d5b9f0289465394e73dedb8ec51e180a8f1dffc9.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mtk-nor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -768,7 +768,7 @@ static int mtk_nor_probe(struct platform
 		return -EINVAL;
 	}
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*sp));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*sp));
 	if (!ctlr) {
 		dev_err(&pdev->dev, "failed to allocate spi controller\n");
 		return -ENOMEM;


