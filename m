Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B28B246A66
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgHQPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgHQPfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0227822C9F;
        Mon, 17 Aug 2020 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678516;
        bh=+bzjetun8RNTzJ2/XSVVLY03Knr3lMknX4t/ao13OAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPdR6fzGEaxLyo+4J7IZS+1boh1lbIjCKRpo3QzuHFQE2yRhVpLhzX67FPJDJV286
         hsnzcznvMk0Wjtxfpk/J5+1Eatxo3/93awv+/lldTPkapa2ZE1rWKj6r3398r4b+1j
         oLopv23ZsgWQ1WzO8ld+kr1sDK/PDX6UDYK4B02s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 362/464] fsl/fman: fix unreachable code
Date:   Mon, 17 Aug 2020 17:15:15 +0200
Message-Id: <20200817143851.113169287@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florinel Iordache <florinel.iordache@nxp.com>

[ Upstream commit cc79fd8f557767de90ff199d3b6fb911df43160a ]

The parameter 'priority' is incorrectly forced to zero which ultimately
induces logically dead code in the subsequent lines.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index a5500ede40703..bb02b37422cc2 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -852,7 +852,6 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~CMD_CFG_PFC_MODE;
-	priority = 0;
 
 	iowrite32be(tmp, &regs->command_config);
 
-- 
2.25.1



