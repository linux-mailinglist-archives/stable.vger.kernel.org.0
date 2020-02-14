Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994C315EBD4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389942AbgBNRXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390940AbgBNQJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5DA82468A;
        Fri, 14 Feb 2020 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696578;
        bh=CrklaBiUioe+mVh4Rp2M/EJyuKZsxC1/zAFqxqUbUMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MTap7yQgC7WQSuo3MfzDWsyQ44KTJYxQ0WvKqHqdQQcYImXkCJJRWqx6BNLgayvJ
         sxYV+KYRsJ1lgk3xnWhyl0FP4LcbQ1HGdFM+FOOLK2mrKpsDFbSPncY/mvTluJpN6P
         JXBe5t/xX7Kk42HIj06hWE2NeN1s22qcoGCSh6Bs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 367/459] spi: spi-fsl-qspi: Ensure width is respected in spi-mem operations
Date:   Fri, 14 Feb 2020 11:00:17 -0500
Message-Id: <20200214160149.11681-367-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

