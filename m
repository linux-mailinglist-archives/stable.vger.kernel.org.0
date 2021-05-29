Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C8B394A6D
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 06:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE2EkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 00:40:22 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:40735 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhE2EkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 00:40:22 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 51208100D9407;
        Sat, 29 May 2021 06:38:45 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 0E6664E69A; Sat, 29 May 2021 06:38:45 +0200 (CEST)
Date:   Sat, 29 May 2021 06:38:45 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, girishm@codeaurora.org, rnayak@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: spi-geni-qcom: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <20210529043845.GA11302@wunner.de>
References: <16091533040136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16091533040136@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 12:01:44PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Sorry for the delay, here's the backport of 8f96c434dfbc to v5.4-stable:

-- >8 --
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:02 +0100
Subject: [PATCH] spi: spi-geni-qcom: Fix use-after-free on unbind

commit 8f96c434dfbc85ffa755d6634c8c1cb2233fcf24 upstream.

spi_geni_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.20+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Cc: Girish Mahadevan <girishm@codeaurora.org>
Link: https://lore.kernel.org/r/dfa1d8c41b8acdfad87ec8654cd124e6e3cb3f31.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to v5.4.123]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi-geni-qcom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 6f3d64a1a2b3..01b53d816497 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -552,7 +552,7 @@ static int spi_geni_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	spi = spi_alloc_master(&pdev->dev, sizeof(*mas));
+	spi = devm_spi_alloc_master(&pdev->dev, sizeof(*mas));
 	if (!spi)
 		return -ENOMEM;
 
@@ -599,7 +599,6 @@ static int spi_geni_probe(struct platform_device *pdev)
 	free_irq(mas->irq, spi);
 spi_geni_probe_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
-	spi_master_put(spi);
 	return ret;
 }
 
-- 
2.31.1

