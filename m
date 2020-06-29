Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705EA20DC3C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgF2UNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732854AbgF2TaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C58D251E9;
        Mon, 29 Jun 2020 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444908;
        bh=vwUcq+Pr5pEMmHNpdNnBYPcbAgx8A+mHieqn7yHIbVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfcKx7T/tzA1rXZpap3p9EHZUo9jkn/2tZOUXdbZyDgss6Gn4RCP8MXiQy5K7W5wx
         s0/yIW7cOKJQ/+lHmZnk6Lq3wk2zmQFYriLeRDoTRdPzsj/4Oyw9ekMKQAKWVsyARC
         CBa9DPcqBI9OcK5r+JiNzjh+ILnRh4LPcjAVYo08=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/131] mtd: rawnand: marvell: Fix the condition on a return code
Date:   Mon, 29 Jun 2020 11:32:55 -0400
Message-Id: <20200629153502.2494656-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit c27075772d1f1c8aaf276db9943b35adda8a8b65 ]

In a previous fix, I changed the condition on which the timeout of an
IRQ is reached from:

    if (!ret)

into:

    if (ret && !pending)

While having a non-zero return code is usual in the Linux kernel, here
ret comes from a wait_for_completion_timeout() which returns 0 when
the waiting period is too long.

Hence, the revised condition should be:

    if (!ret && !pending)

The faulty patch did not produce any error because of the !pending
condition so this change is finally purely cosmetic and does not
change the actual driver behavior.

Fixes: cafb56dd741e ("mtd: rawnand: marvell: prevent timeouts on a loaded machine")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-mtd/20200424164501.26719-2-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 3e542224dd115..a917bc242c9cc 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -637,7 +637,7 @@ static int marvell_nfc_wait_op(struct nand_chip *chip, unsigned int timeout_ms)
 	 * In case the interrupt was not served in the required time frame,
 	 * check if the ISR was not served or if something went actually wrong.
 	 */
-	if (ret && !pending) {
+	if (!ret && !pending) {
 		dev_err(nfc->dev, "Timeout waiting for RB signal\n");
 		return -ETIMEDOUT;
 	}
-- 
2.25.1

