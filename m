Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A9364372
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbhDSNS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240473AbhDSNQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95CE61285;
        Mon, 19 Apr 2021 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838035;
        bh=/l6XAgg8zgygTRzAIB62RivYZBwC+wbTWD//wep9ppE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spo6k/4s/KVk72Fn1x5+u7A82HxB4hz5mFSWaS8nadQQJiOY4U91XwHiNlqJBiqQ9
         Z6slF2MN4Dcu2UAUv8HFGbgDLPFmo9FbUXHicd3A076VOLjguyLc6lLNCMM4Rw3DnT
         c3Id1MOyUvQF04TmWhOEWQ7cn55ZDYtntDu2koU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/103] mtd: rawnand: mtk: Fix WAITRDY break condition and timeout
Date:   Mon, 19 Apr 2021 15:05:13 +0200
Message-Id: <20210419130527.873007971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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



