Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5EA328986
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbhCAR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239024AbhCARwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:52:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D29865351;
        Mon,  1 Mar 2021 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620713;
        bh=ikQNYN+4dubxAdhape2gqPUzbR2MN0V2agvM2qBvcf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf+INi+6fGsJT3NOGT3DuQ4plDjalSDGHat5O221ZHiotjdydsBikiHT//HHcm5DS
         7v+93k9OLmEVuoHVgwh/6cdnLgRJDt9mUWZc+LM3jYni3rlNKgJpVuvml4pRiZe4G1
         mSh8PZg9RkkF4FBUUU5C/gJ9yeYPvLiUt9Wk29o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 252/775] mtd: rawnand: intel: Fix an error handling path in ebu_dma_start()
Date:   Mon,  1 Mar 2021 17:07:00 +0100
Message-Id: <20210301161214.082638063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 073abfa7ea9a5b0537d6f92b42baedaf82a04c53 ]

If 'dmaengine_prep_slave_single()' fails, we must undo a previous
'dma_map_single()' call, as already done in all the other error handling
paths of this function.

Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210124073955.728797-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index a304fda5d1fa5..8b49fd56cf964 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -318,8 +318,10 @@ static int ebu_dma_start(struct ebu_nand_controller *ebu_host, u32 dir,
 	}
 
 	tx = dmaengine_prep_slave_single(chan, buf_dma, len, dir, flags);
-	if (!tx)
-		return -ENXIO;
+	if (!tx) {
+		ret = -ENXIO;
+		goto err_unmap;
+	}
 
 	tx->callback = callback;
 	tx->callback_param = ebu_host;
-- 
2.27.0



