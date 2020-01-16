Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BAA13FF6F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgAPXZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389304AbgAPXZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0BE520684;
        Thu, 16 Jan 2020 23:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217154;
        bh=fZxjk5Zp4r7tP8Qq17q36uBSyNNs0X5uJLSyVzCpkRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SYTbYuXEKov8/xQzabayMgZj4gpoONKzXHyvHZ5kqCiTucBtTAEztyEWT7PgpL2x
         ozYX4G885eTRjBPeVGyGV/2s1HbQj338MsM26lgW6KGGobxkqLIITzqNEOddW+ghwS
         HTRLK85m/TAOwJ5gRsJH5x4g62tTjyFgJq3c0hJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 170/203] spi: rspi: Use platform_get_irq_byname_optional() for optional irqs
Date:   Fri, 17 Jan 2020 00:18:07 +0100
Message-Id: <20200116231759.433140321@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 2de860b4a7a0bd5a4b5bd3bff0e6a615495df4ba upstream.

As platform_get_irq_byname() now prints an error when the interrupt
does not exist, scary warnings may be printed for optional interrupts:

    renesas_spi e6b10000.spi: IRQ rx not found
    renesas_spi e6b10000.spi: IRQ mux not found

Fix this by calling platform_get_irq_byname_optional() instead.
Remove the no longer needed printing of platform_get_irq errors, as the
remaining calls to platform_get_irq() and platform_get_irq_byname() take
care of that.

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20191016143101.28738-1-geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-rspi.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1257,9 +1257,9 @@ static int rspi_probe(struct platform_de
 	ctlr->flags = ops->flags;
 	ctlr->dev.of_node = pdev->dev.of_node;
 
-	ret = platform_get_irq_byname(pdev, "rx");
+	ret = platform_get_irq_byname_optional(pdev, "rx");
 	if (ret < 0) {
-		ret = platform_get_irq_byname(pdev, "mux");
+		ret = platform_get_irq_byname_optional(pdev, "mux");
 		if (ret < 0)
 			ret = platform_get_irq(pdev, 0);
 		if (ret >= 0)
@@ -1270,10 +1270,6 @@ static int rspi_probe(struct platform_de
 		if (ret >= 0)
 			rspi->tx_irq = ret;
 	}
-	if (ret < 0) {
-		dev_err(&pdev->dev, "platform_get_irq error\n");
-		goto error2;
-	}
 
 	if (rspi->rx_irq == rspi->tx_irq) {
 		/* Single multiplexed interrupt */


