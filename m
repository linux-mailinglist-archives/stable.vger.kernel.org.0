Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F0113FF6E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388734AbgAPXZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388332AbgAPXZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C66F2072B;
        Thu, 16 Jan 2020 23:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217156;
        bh=mAeyCEBh9vgKs3MQPtBIK04WIfJU/5gVTaleQ8b0eJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq2r6s6Xi3iDWdw6wSK2v/P09JDys78ppLpGGOQVRe7G29gEs9X5nTVQRBWX23u/A
         XRgojo614iXpW8scGU08j5mghrvPpbZ5j4Hgq8fAJRJAcOG+ov4I6nuVHs/2SQpLbM
         EDhgIehzZPuN1Fg9ZuESJDHTgT62NfmfuNwXrreg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 171/203] spi: lpspi: fix memory leak in fsl_lpspi_probe
Date:   Fri, 17 Jan 2020 00:18:08 +0100
Message-Id: <20200116231759.502270087@linuxfoundation.org>
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

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 057b8945f78f76d0b04eeb5c27cd9225e5e7ad86 upstream.

In fsl_lpspi_probe an SPI controller is allocated either via
spi_alloc_slave or spi_alloc_master. In all but one error cases this
controller is put by going to error handling code. This commit fixes the
case when pm_runtime_get_sync fails and it should go to the error
handling path.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190930034602.1467-1-navid.emamdoost@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-lpspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -938,7 +938,7 @@ static int fsl_lpspi_probe(struct platfo
 	ret = pm_runtime_get_sync(fsl_lpspi->dev);
 	if (ret < 0) {
 		dev_err(fsl_lpspi->dev, "failed to enable clock\n");
-		return ret;
+		goto out_controller_put;
 	}
 
 	temp = readl(fsl_lpspi->base + IMX7ULP_PARAM);


