Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8798328B2B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhCAS37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239762AbhCASWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E5A64DE0;
        Mon,  1 Mar 2021 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618929;
        bh=Z0u2ZE80aTAxZJFJUHS/kTl5bAwFKVZycqe2LEnItuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCEywrno7VH6to0vsAO9CrEELhkz2TaWDfm3OZLG5pUWe+sTaPRuVNAsIKcTVaaS0
         6PjK+Dk3elR4ypZBR9+Xpl9YBkpPJxzx8B3TNfpN/KBROivBtMs1bxTWlNvvaY+cd2
         iYYqVS2X7BI37cwpU1f8xL5FxXQMTYe09/j/W5zQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/663] spi: cadence-quadspi: Abort read if dummy cycles required are too many
Date:   Mon,  1 Mar 2021 17:08:38 +0100
Message-Id: <20210301161155.177133646@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
 drivers/spi/spi-cadence-quadspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index ba7d40c2922f7..826b01f346246 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -461,7 +461,7 @@ static int cqspi_read_setup(struct cqspi_flash_pdata *f_pdata,
 	/* Setup dummy clock cycles */
 	dummy_clk = op->dummy.nbytes * 8;
 	if (dummy_clk > CQSPI_DUMMY_CLKS_MAX)
-		dummy_clk = CQSPI_DUMMY_CLKS_MAX;
+		return -EOPNOTSUPP;
 
 	if (dummy_clk)
 		reg |= (dummy_clk & CQSPI_REG_RD_INSTR_DUMMY_MASK)
-- 
2.27.0



