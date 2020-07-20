Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7EB22649F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgGTPqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbgGTPqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A192065E;
        Mon, 20 Jul 2020 15:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259998;
        bh=cnGdhLX3OX47LwPLNQMdxtiWeUvP28zzYPAcYex2Z7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XDmwr61nnp7S76Npx118nkcLovXuKGzGetaqTcwuNXiXJBMQi2BsS5rknQ5pB1gW
         bAP+nfJKVsEtJpIeMqSd5G8zNUB8Nts8R5WTk80tJdHExQ5guAYaREJ/tRmv6L+/Jg
         bGgltJbSgGmfGLwuZHrjJP/nkzYxe2Rk2/Vl1/Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Angelo Dureghello <angelo@sysam.it>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/125] spi: fix initial SPI_SR value in spi-fsl-dspi
Date:   Mon, 20 Jul 2020 17:36:49 +0200
Message-Id: <20200720152806.402266827@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo@sysam.it>

[ Upstream commit aa54c1c9d90e6db75190813907190fadcce1bf45 ]

On ColdFire mcf54418, using DSPI_DMA_MODE mode, spi transfers
at first boot stage are not succeding:

m25p80 spi0.1: unrecognized JEDEC id bytes: 00, 00, 00

The reason is the SPI_SR initial value set by the driver, that
is not clearing (not setting to 1) the RF_DF flag. After a tour
on the dspi hw modules that use this driver(Vybrid, ColdFire and
ls1021a) a better init value for SR register has been set.

Signed-off-by: Angelo Dureghello <angelo@sysam.it>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index cce9e34306787..6da70a62e1964 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -76,7 +76,7 @@
 #define SPI_SR			0x2c
 #define SPI_SR_EOQF		0x10000000
 #define SPI_SR_TCFQF		0x80000000
-#define SPI_SR_CLEAR		0xdaad0000
+#define SPI_SR_CLEAR		0x9aaf0000
 
 #define SPI_RSER_TFFFE		BIT(25)
 #define SPI_RSER_TFFFD		BIT(24)
-- 
2.25.1



