Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808863642B1
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhDSNLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239459AbhDSNI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B808961285;
        Mon, 19 Apr 2021 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837707;
        bh=/l6XAgg8zgygTRzAIB62RivYZBwC+wbTWD//wep9ppE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raQCN7FTSsaenaZ3WygxFPKZb9h9pBRebi/XQ2f5fLChCCrWqqBu8ZVzgl6Rk9bzt
         bQLLu8kjlwGNa4P7Q7CEz1YDi3cyrN0TdPZ5stD+ROwdv98p6v34ZK0t1+/2p3o6l7
         6zYoXTOrx04HVMOmjWy86oRC9Kan/8z33RRbbjx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 004/122] mtd: rawnand: mtk: Fix WAITRDY break condition and timeout
Date:   Mon, 19 Apr 2021 15:04:44 +0200
Message-Id: <20210419130530.320083765@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 2fb164f0ce95e504e2688b4f984893c29ebd19ab ]

This fixes NAND_OP_WAITRDY_INSTR operation in the driver. Without this
change the driver waits till the system is busy, but we should wait till
the busy flag is cleared. The readl_poll_timeout() function gets a break
condition, not a wait condition.

In addition fix the timeout. The timeout_ms is given in ms, but the
readl_poll_timeout() function takes the timeout in us. Multiple the
given timeout by 1000 to convert it.

Without this change, the driver does not work at all, it doesn't even
identify the NAND chip.

Fixes: 5197360f9e09 ("mtd: rawnand: mtk: Convert the driver to exec_op()")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210309000107.1368404-1-hauke@hauke-m.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_nand.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index 57f1f1708994..5c5c92132287 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -488,8 +488,8 @@ static int mtk_nfc_exec_instr(struct nand_chip *chip,
 		return 0;
 	case NAND_OP_WAITRDY_INSTR:
 		return readl_poll_timeout(nfc->regs + NFI_STA, status,
-					  status & STA_BUSY, 20,
-					  instr->ctx.waitrdy.timeout_ms);
+					  !(status & STA_BUSY), 20,
+					  instr->ctx.waitrdy.timeout_ms * 1000);
 	default:
 		break;
 	}
-- 
2.30.2



