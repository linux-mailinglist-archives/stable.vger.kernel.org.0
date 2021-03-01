Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB132853B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhCAQvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235301AbhCAQnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61B3464F46;
        Mon,  1 Mar 2021 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616201;
        bh=fKDD0BSkgLr84muZmQPowt+pExksggudOcHRFRzsKhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfKKBpmpE/uL0wVuD4T2zbxNKYrsKQ/g3HqT2T8cJqKktr3o58m00gP47AguRghnT
         CCchEnE4BmPVYv/xx9f91KxREIESG1mM6+U0hjdqpNC94vgeFWNqDQoIS0qsWKFQDT
         gzP8ObAT5dvuFDqVUCPcMQNEyZE5kf9Y1DoMEsAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/176] spi: cadence-quadspi: Abort read if dummy cycles required are too many
Date:   Mon,  1 Mar 2021 17:12:23 +0100
Message-Id: <20210301161024.440493720@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit ceeda328edeeeeac7579e9dbf0610785a3b83d39 ]

The controller can only support up to 31 dummy cycles. If the command
requires more it falls back to using 31. This command is likely to fail
because the correct number of cycles are not waited upon. Rather than
silently issuing an incorrect command, fail loudly so the caller can get
a chance to find out the command can't be supported by the controller.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20201222184425.7028-3-p.yadav@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
index ff4edf4bb23c5..e58923d25f4a5 100644
--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -465,7 +465,7 @@ static int cqspi_indirect_read_setup(struct spi_nor *nor,
 	/* Setup dummy clock cycles */
 	dummy_clk = nor->read_dummy;
 	if (dummy_clk > CQSPI_DUMMY_CLKS_MAX)
-		dummy_clk = CQSPI_DUMMY_CLKS_MAX;
+		return -EOPNOTSUPP;
 
 	if (dummy_clk / 8) {
 		reg |= (1 << CQSPI_REG_RD_INSTR_MODE_EN_LSB);
-- 
2.27.0



