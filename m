Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E9395E72
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhEaN6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhEaN4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:56:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD87613F3;
        Mon, 31 May 2021 13:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468087;
        bh=d5hGgpFXl/WfnpQuNaib7PPQjw6cDvtuUJzj/dDkc3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2jY3V41q6TGQHc/RyUHVshVt1yXjSx+BmLNFr0lpXhe1lSk5Z+8j0ZG8gChzK1Ti
         thATdknMEgAEg7TqlTzLcwPWMJQ7aJVSobeyrEtZOYEb1PQhwVlRzVBrL1cmmmLUkL
         92eLxPjzKQgx3Z4ExAEFtLf8zq3CRGXJFPCtbjbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 110/252] spi: spi-fsl-dspi: Fix a resource leak in an error handling path
Date:   Mon, 31 May 2021 15:12:55 +0200
Message-Id: <20210531130701.717075542@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -1375,11 +1375,13 @@ poll_mode:
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


