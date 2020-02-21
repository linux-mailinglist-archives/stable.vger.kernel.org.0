Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66F1675F4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732779AbgBUIcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732925AbgBUIM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:12:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCAF20722;
        Fri, 21 Feb 2020 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272778;
        bh=CrklaBiUioe+mVh4Rp2M/EJyuKZsxC1/zAFqxqUbUMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDgjTHOqBuxyoM/BAKPPsXMqNE4azlY6uI1MHQVY/U6KjIZrjW4eDaAYgrCUQnznP
         Ey0pgFu/R5HiRnzmBoEp3PspQbdGVHm/ONSu0wWX4CVx19kuJEpuJeoU7/07vID4G/
         AE6/DehUaqmKTUbV4RYw6O4xRDK8penJJf8fWNiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 272/344] spi: spi-fsl-qspi: Ensure width is respected in spi-mem operations
Date:   Fri, 21 Feb 2020 08:41:11 +0100
Message-Id: <20200221072414.420079212@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit b0177aca7aea7e8917d4e463334b51facb293d02 ]

Make use of a core helper to ensure the desired width is respected
when calling spi-mem operators.

Otherwise only the SPI controller will be matched with the flash chip,
which might lead to wrong widths. Also consider the width specified by
the user in the device tree.

Fixes: 84d043185dbe ("spi: Add a driver for the Freescale/NXP QuadSPI controller")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20200114154613.8195-1-michael@walle.cc
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 63c9f7edaf6cb..43078ba3def5d 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -398,7 +398,7 @@ static bool fsl_qspi_supports_op(struct spi_mem *mem,
 	    op->data.nbytes > q->devtype_data->txfifo)
 		return false;
 
-	return true;
+	return spi_mem_default_supports_op(mem, op);
 }
 
 static void fsl_qspi_prepare_lut(struct fsl_qspi *q,
-- 
2.20.1



