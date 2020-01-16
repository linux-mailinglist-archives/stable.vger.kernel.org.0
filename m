Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C783F13FF5F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgAPXmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389546AbgAPX0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 006D32072E;
        Thu, 16 Jan 2020 23:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217202;
        bh=kX37GmXtMftvg79iJNrFFU0voest/XQlIMKKYxjKyew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIe2GhJ0wQhOqlk1P/gR0FQkK4EoATZuf6umEDng9Ur/O2nr3zzlzhXZIkpe+CTvr
         jFGwj3j5ulVC8Jpa5xaK6rAwm6XJ/5ujSds9ryZei8RrVD5r6sI8CGJHV1MC0rhbxo
         PV3TYQD1N1phlmSAbcSFEyPXIgvPoqEK/VprTdr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huanpeng Xin <huanpeng.xin@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 165/203] spi: sprd: Fix the incorrect SPI register
Date:   Fri, 17 Jan 2020 00:18:02 +0100
Message-Id: <20200116231759.082586236@linuxfoundation.org>
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

From: Huanpeng Xin <huanpeng.xin@unisoc.com>

commit 5e9c5236b7b86779b53b762f7e66240c3f18314b upstream.

The original code used an incorrect SPI register to initialize the SPI
controller in sprd_spi_init_hw(), thus fix it.

Fixes: e7d973a31c24 ("spi: sprd: Add SPI driver for Spreadtrum SC9860")
Signed-off-by: Huanpeng Xin <huanpeng.xin@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/b4f7f89ec0fdc595335687bfbd9f962213bc4a1d.1575443510.git.baolin.wang7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sprd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -674,7 +674,7 @@ static void sprd_spi_init_hw(struct sprd
 	u16 word_delay, interval;
 	u32 val;
 
-	val = readl_relaxed(ss->base + SPRD_SPI_CTL7);
+	val = readl_relaxed(ss->base + SPRD_SPI_CTL0);
 	val &= ~(SPRD_SPI_SCK_REV | SPRD_SPI_NG_TX | SPRD_SPI_NG_RX);
 	/* Set default chip selection, clock phase and clock polarity */
 	val |= ss->hw_mode & SPI_CPHA ? SPRD_SPI_NG_RX : SPRD_SPI_NG_TX;


