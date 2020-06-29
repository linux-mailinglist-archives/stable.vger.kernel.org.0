Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D47E20DCAE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgF2URg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732642AbgF2TZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A768125413;
        Mon, 29 Jun 2020 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445364;
        bh=nUQP0ziKCATQAvBbnQgRmQROXRvuwEzsoToKNDtoNuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqNNNv1RDXvdKdap6Og6Uj+sZhKz0Ym497awCHQppb4gGclqo4/Y3A6wDr0CKSLZ8
         nrQFPkVfyBlUckYynC0kwkY4jaOb0eTYfnGGEP8hnM3TcUFlFukiUKZthXqZDv/ZnF
         TKMX3/10O0uA/tERCMrwVuyO1teky7q5cww6xy+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 120/191] mtd: rawnand: diskonchip: Fix the probe error path
Date:   Mon, 29 Jun 2020 11:38:56 -0400
Message-Id: <20200629154007.2495120-121-sashal@kernel.org>
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

[ Upstream commit c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 ]

Not sure nand_cleanup() is the right function to call here but in any
case it is not nand_release(). Indeed, even a comment says that
calling nand_release() is a bit of a hack as there is no MTD device to
unregister. So switch to nand_cleanup() for now and drop this
comment.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if it did not intruce
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/diskonchip.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index b42d618553be8..374b7a10ba517 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1605,13 +1605,10 @@ static int __init doc_probe(unsigned long physadr)
 		numchips = doc2001_init(mtd);
 
 	if ((ret = nand_scan(mtd, numchips)) || (ret = doc->late_init(mtd))) {
-		/* DBB note: i believe nand_release is necessary here, as
+		/* DBB note: i believe nand_cleanup is necessary here, as
 		   buffers may have been allocated in nand_base.  Check with
 		   Thomas. FIX ME! */
-		/* nand_release will call mtd_device_unregister, but we
-		   haven't yet added it.  This is handled without incident by
-		   mtd_device_unregister, as far as I can tell. */
-		nand_release(nand);
+		nand_cleanup(nand);
 		kfree(nand);
 		goto fail;
 	}
-- 
2.25.1

