Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652682C092E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgKWNEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387599AbgKWMuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40A0204EF;
        Mon, 23 Nov 2020 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135849;
        bh=RJnnzNFxUZTEiInnUWYcXBbVU3LLpeSmbJbVGTY5LHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/lLzzRz7k2G+e1MRi+wRsD8fSVZflW06mGjLYphpafQeezUGL6qvCI4s0/VFFefD
         57S7wDl/9ZYtDtwiqTRKlb2UIib9qmdNIP+HYv3tjwqIchYnLy0zZnLIUUtY5vDyAo
         JaZO4WMMB2zi5IZJ507jhwrUDiGIY/imFMs0mXtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Han Xu <han.xu@nxp.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 218/252] spi: lpspi: Fix use-after-free on unbind
Date:   Mon, 23 Nov 2020 13:22:48 +0100
Message-Id: <20201123121846.095915656@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 4def49da620c84a682d9361d6bef0a97eed46fe0 upstream.

Normally the last reference on an spi_controller is released by
spi_unregister_controller().  In the case of the i.MX lpspi driver,
the spi_controller is registered with devm_spi_register_controller(),
so spi_unregister_controller() is invoked automatically after the driver
has unbound.

However the driver already releases the last reference in
fsl_lpspi_remove() through a gratuitous call to spi_master_put(),
causing a use-after-free when spi_unregister_controller() is
subsequently invoked by the devres framework.

Fix by dropping the superfluous spi_master_put().

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.2+
Cc: Han Xu <han.xu@nxp.com>
Link: https://lore.kernel.org/r/ab3c0b18bd820501a12c85e440006e09ec0e275f.1604874488.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-lpspi.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -938,9 +938,6 @@ static int fsl_lpspi_remove(struct platf
 				spi_controller_get_devdata(controller);
 
 	pm_runtime_disable(fsl_lpspi->dev);
-
-	spi_master_put(controller);
-
 	return 0;
 }
 


