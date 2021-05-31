Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED40396018
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhEaOWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhEaOTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3B96141B;
        Mon, 31 May 2021 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468666;
        bh=iKyYyDpShslT+5GNriDpMu/Gpkxx0at5Xw/695kRCUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDefkMS3ffRpEioOv5I01dlfvQxrkhm8IpuhfatBsRczWIFboACT68xYupFPhi9+v
         cz4hQ+Ha+va6M1itPY2jcGZXRBGjY36tuIEHThGSY/DiWvmIISvV4U13hxcQQJxQnC
         6S/RSCpH8naV7QNLLoU7dr0L/Yrw7mJRVTqJSwqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 078/177] spi: spi-fsl-dspi: Fix a resource leak in an error handling path
Date:   Mon, 31 May 2021 15:13:55 +0200
Message-Id: <20210531130650.595202706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 680ec0549a055eb464dce6ffb4bfb736ef87236e upstream.

'dspi_request_dma()' should be undone by a 'dspi_release_dma()' call in the
error handling path of the probe function, as already done in the remove
function

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/d51caaac747277a1099ba8dea07acd85435b857e.1620587472.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-dspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1142,11 +1142,13 @@ poll_mode:
 	ret = spi_register_controller(ctlr);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
-		goto out_free_irq;
+		goto out_release_dma;
 	}
 
 	return ret;
 
+out_release_dma:
+	dspi_release_dma(dspi);
 out_free_irq:
 	if (dspi->irq)
 		free_irq(dspi->irq, dspi);


