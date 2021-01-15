Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF25D2F7BC8
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbhAONFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732636AbhAOMb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14580223E0;
        Fri, 15 Jan 2021 12:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713861;
        bh=wm5WeJQYdQf+CoJFWFvHnb1UuRE0qgqrDYPyZ+0mdwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKfGaOsq7bWr8t5NN6IcAkWb3Q3K4r9wWE9ZNpLui8pSPW1qE20WojoQSCHAoEVDH
         gvOoOId/JNOo+rjRtnKd+u4PTLc42UB5JCijWngPftCM5OTOCLZmgVsG5RY1R2wZDj
         rtFfEhYPIdKGzv+AbyglTf0kKwAXkmmfY/TaKxyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 11/28] spi: pxa2xx: Fix use-after-free on unbind
Date:   Fri, 15 Jan 2021 13:27:48 +0100
Message-Id: <20210115121957.310049163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5626308bb94d9f930aa5f7c77327df4c6daa7759 upstream

pxa2xx_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master/slave() helper
which keeps the private data accessible until the driver has unbound.

Fixes: 32e5b57232c0 ("spi: pxa2xx: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v2.6.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v2.6.17+: 32e5b57232c0: spi: pxa2xx: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v2.6.17+
Link: https://lore.kernel.org/r/5764b04d4a6e43069ebb7808f64c2f774ac6f193.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pxa2xx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1660,7 +1660,7 @@ static int pxa2xx_spi_probe(struct platf
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(dev, sizeof(struct driver_data));
+	master = devm_spi_alloc_master(dev, sizeof(*drv_data));
 	if (!master) {
 		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		pxa_ssp_free(ssp);
@@ -1841,7 +1841,6 @@ out_error_clock_enabled:
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
-	spi_master_put(master);
 	pxa_ssp_free(ssp);
 	return status;
 }


