Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FE28B7F8
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgJLNsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731904AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D234822265;
        Mon, 12 Oct 2020 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510464;
        bh=kly+CXi+/sAAp999RizaG0l/2YGyBHTzTQGUcV/feH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gij6+6eejWupMBsSi9Zs1/os4+zpRIQt/bsC/3ml3D/vBx6KAN+dcuzFB1J8rG/Kj
         KJGPFqxkQ+t+YgBkFShEM6ktv1N8T4QgDm833bucY5Wto88Plu/jL8mXbFew8D63KU
         2sFXLTTErdEG/UZUhMhNfozIvKhe0SIjtXhnuC0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Vicente Bergas <vicencb@gmail.com>
Subject: [PATCH 5.8 110/124] mmc: core: dont set limits.discard_granularity as 0
Date:   Mon, 12 Oct 2020 15:31:54 +0200
Message-Id: <20201012133152.183915614@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 4243219141b67d7c2fdb2d8073c17c539b9263eb ]

In mmc_queue_setup_discard() the mmc driver queue's discard_granularity
might be set as 0 (when card->pref_erase > max_discard) while the mmc
device still declares to support discard operation. This is buggy and
triggered the following kernel warning message,

WARNING: CPU: 0 PID: 135 at __blkdev_issue_discard+0x200/0x294
CPU: 0 PID: 135 Comm: f2fs_discard-17 Not tainted 5.9.0-rc6 #1
Hardware name: Google Kevin (DT)
pstate: 00000005 (nzcv daif -PAN -UAO BTYPE=--)
pc : __blkdev_issue_discard+0x200/0x294
lr : __blkdev_issue_discard+0x54/0x294
sp : ffff800011dd3b10
x29: ffff800011dd3b10 x28: 0000000000000000 x27: ffff800011dd3cc4 x26: ffff800011dd3e18 x25: 000000000004e69b x24: 0000000000000c40 x23: ffff0000f1deaaf0 x22: ffff0000f2849200 x21: 00000000002734d8 x20: 0000000000000008 x19: 0000000000000000 x18: 0000000000000000 x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000 x14: 0000000000000394 x13: 0000000000000000 x12: 0000000000000000 x11: 0000000000000000 x10: 00000000000008b0 x9 : ffff800011dd3cb0 x8 : 000000000004e69b x7 : 0000000000000000 x6 : ffff0000f1926400 x5 : ffff0000f1940800 x4 : 0000000000000000 x3 : 0000000000000c40 x2 : 0000000000000008 x1 : 00000000002734d8 x0 : 0000000000000000 Call trace:
__blkdev_issue_discard+0x200/0x294
__submit_discard_cmd+0x128/0x374
__issue_discard_cmd_orderly+0x188/0x244
__issue_discard_cmd+0x2e8/0x33c
issue_discard_thread+0xe8/0x2f0
kthread+0x11c/0x120
ret_from_fork+0x10/0x1c
---[ end trace e4c8023d33dfe77a ]---

This patch fixes the issue by setting discard_granularity as SECTOR_SIZE
instead of 0 when (card->pref_erase > max_discard) is true. Now no more
complain from __blkdev_issue_discard() for the improper value of discard
granularity.

This issue is exposed after commit b35fd7422c2f ("block: check queue's
limits.discard_granularity in __blkdev_issue_discard()"), a "Fixes:" tag
is also added for the commit to make sure people won't miss this patch
after applying the change of __blkdev_issue_discard().

Fixes: e056a1b5b67b ("mmc: queue: let host controllers specify maximum discard timeout")
Fixes: b35fd7422c2f ("block: check queue's limits.discard_granularity in __blkdev_issue_discard()").
Reported-and-tested-by: Vicente Bergas <vicencb@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20201002013852.51968-1-colyli@suse.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 4b1eb89b401d9..1ad518821157f 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -190,7 +190,7 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 	q->limits.discard_granularity = card->pref_erase << 9;
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
-		q->limits.discard_granularity = 0;
+		q->limits.discard_granularity = SECTOR_SIZE;
 	if (mmc_can_secure_erase_trim(card))
 		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
 }
-- 
2.25.1



