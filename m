Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E1E20DE58
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgF2UYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732547AbgF2TZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A81025420;
        Mon, 29 Jun 2020 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445371;
        bh=o5iABVfbPasP49152lRGrgPImPS6VdQj30+/1zRG2Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHbrMsdr3orvW5o+irjj8a7hddjIZqSKAzX8liLVYFmmsJogrFwe2SL6p4XFWqCz6
         iAM6CeVkrLPIyho0Mx3e9bqN1/Eqbcwf12ZbcOidDnQvwInL46FcGi5owUbsnRRjh2
         g3S3nWcSRvQN0qsP1bOwL7moZkuIgLhRP9FDnc8c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/191] mtd: rawnand: tmio: Fix the probe error path
Date:   Mon, 29 Jun 2020 11:39:03 -0400
Message-Id: <20200629154007.2495120-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 75e9a330a9bd48f97a55a08000236084fe3dae56 ]

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-57-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/tmio_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 1deb5229db15d..d07c729f5b9b8 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -446,7 +446,7 @@ static int tmio_probe(struct platform_device *dev)
 	if (!retval)
 		return retval;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);
-- 
2.25.1

