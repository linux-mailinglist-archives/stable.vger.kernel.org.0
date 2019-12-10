Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF61195F0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfLJVXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:23:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfLJVLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7CA2077B;
        Tue, 10 Dec 2019 21:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012264;
        bh=pWi9qhhj81ENv7TajptmcAzqW4lHgpIn41k71w0kQ/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxGyVDZIWWwD/ZrAA/2bDUsA2aGFbh2JGPpQIxdmOKRJ6OXWiVKApIdTzqVm5wDKE
         3dt7WqmqTt93YNcFAHXGAyMwgUaBpgTmzfkhDfnEPbFJYltzeSioRpBT8Rrq09XYB3
         0vRxib7u4KQg1D7hPyZVIZa1R2jiTyOuKunY13rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 210/350] spi: dw: Fix Designware SPI loopback
Date:   Tue, 10 Dec 2019 16:05:15 -0500
Message-Id: <20191210210735.9077-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thor Thayer <thor.thayer@linux.intel.com>

[ Upstream commit 1403cfa69d310781f9548951c97725c67ffcf613 ]

The SPI_LOOP is set in spi->mode but not propagated to the register.
A previous patch removed the bit during a cleanup.

Fixes: e1bc204894ea ("spi: dw: fix potential variable assignment error")
Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
Link: https://lore.kernel.org/r/1572985330-5525-1-git-send-email-thor.thayer@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 9a49e073e8b73..076652d3d051e 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -308,7 +308,8 @@ static int dw_spi_transfer_one(struct spi_controller *master,
 	cr0 = (transfer->bits_per_word - 1)
 		| (chip->type << SPI_FRF_OFFSET)
 		| ((((spi->mode & SPI_CPOL) ? 1 : 0) << SPI_SCOL_OFFSET) |
-			(((spi->mode & SPI_CPHA) ? 1 : 0) << SPI_SCPH_OFFSET))
+			(((spi->mode & SPI_CPHA) ? 1 : 0) << SPI_SCPH_OFFSET) |
+			(((spi->mode & SPI_LOOP) ? 1 : 0) << SPI_SRL_OFFSET))
 		| (chip->tmode << SPI_TMOD_OFFSET);
 
 	/*
-- 
2.20.1

