Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A84106E5D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbfKVLEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbfKVLEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED601207FC;
        Fri, 22 Nov 2019 11:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420685;
        bh=dONCx61Ia/sj7WTQHEcMz5HEIkjAqNopjr/Sy89EPhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzLz4t7QUyJnv/zTH+6ub8E4AHft6+pd1ergaUOhp/FRpEUrK8/eMT2Wm7tSjqJVG
         MMB5kS3VzxKj/Si7pxkENzKw/09hOgWDwoVLrWpmAfGbTJYAow67azaYYsQmFsAsJ+
         Pli5sozteL5u8wZhdK08gV/YPPM0z2h8rUf48PR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hieu Tran Dang <dangtranhieu2012@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/220] spi: fsl-lpspi: Prevent FIFO under/overrun by default
Date:   Fri, 22 Nov 2019 11:29:16 +0100
Message-Id: <20191122100927.844347489@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hieu Tran Dang <dangtranhieu2012@gmail.com>

[ Upstream commit de8978c388c66b8fca192213ec9f0727e964c652 ]

Certain devices don't work well when a transmit FIFO underrun or
receive FIFO overrun occurs. Example is the SAF400x radio chip when
running at high speed which leads to garbage being sent to/received from
the chip. In which case, it should stall waiting for further data to be
available before proceeding. This patch unset the NOSTALL bit in CFGR1
by default to prevent this issue.

Signed-off-by: Hieu Tran Dang <dangtranhieu2012@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index e6d5cc6ab108b..51670976faa35 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -276,7 +276,7 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
 
 	fsl_lpspi_set_watermark(fsl_lpspi);
 
-	temp = CFGR1_PCSCFG | CFGR1_MASTER | CFGR1_NOSTALL;
+	temp = CFGR1_PCSCFG | CFGR1_MASTER;
 	if (fsl_lpspi->config.mode & SPI_CS_HIGH)
 		temp |= CFGR1_PCSPOL;
 	writel(temp, fsl_lpspi->base + IMX7ULP_CFGR1);
-- 
2.20.1



