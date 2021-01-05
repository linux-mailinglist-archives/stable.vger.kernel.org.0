Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B9C2EA877
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbhAEKTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728948AbhAEKTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:19:06 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AF1C061798
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 02:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EnanDhlmBx645gdyY5r/UT+o6K2Boi3a0wwgVEyzY2s=; b=iwQ/2rkCJDtLHCj7ngFiFo38u3
        pymhjWc/jhMW9J0XnujzhpIAfNAZ63AfEWjn6B9mIit7iFR8E71Gb6qOrronRYChBCpbWacfKLV1y
        xSzelSYuIqL2A2Vjlbis+LH3dRidjNB18ROe1lQmW+iaGdLgvyFPi8xPlJph3YIjNvBA=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kwjPz-0002rs-Kh; Tue, 05 Jan 2021 11:18:23 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH] Revert "mtd: spinand: Fix OOB read"
Date:   Tue,  5 Jan 2021 11:18:21 +0100
Message-Id: <20210105101821.47138-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.

This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
backport was touching spinand_read_from_cache_op.
It causes a crash on writing OOB data by attempting to write to read-only
kernel memory.

Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/mtd/nand/spi/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 7900571fc85b..c35221794645 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -318,10 +318,6 @@ static int spinand_write_to_cache_op(struct spinand_device *spinand,
 		buf += ret;
 	}
 
-	if (req->ooblen)
-		memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
-		       req->ooblen);
-
 	return 0;
 }
 
-- 
2.28.0

