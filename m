Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3351D53ED57
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiFFR5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiFFR5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129A23207C9;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F03D221B1F;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4D2/ytiKcx0QKYW8PMSxMJ4IhfT+jX8mKmVp4uJXSM=;
        b=UeryIq1BmW3nDkgoDomooUQS8B14hUSNMkPnYQNd9EMTSai/l7fauS2hu+ScZPWS8u47tK
        ZGBhBq9HeuByUGfbyi5ImBy/nmlKmNZRWPjLegZGeEDu5nZ1TWmTFIli0U4t56yX5S0FqG
        6YjfQNYIQpWV9+ndCXQi3kR+Os5h82w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4D2/ytiKcx0QKYW8PMSxMJ4IhfT+jX8mKmVp4uJXSM=;
        b=ZaZNvvt4FdT760IzOGsUA31Qr072Ijy8KNyAasArznuSATBA5gGogR6rU1GzdNPYjVuXSE
        4wnQdsyWT2M0GOAQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D8D192C142;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0F33DA0634; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] bfq: Avoid merging queues with different parents
Date:   Mon,  6 Jun 2022 19:56:36 +0200
Message-Id: <20220606175655.8993-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3153; h=from:subject; bh=A/I/kHI3BdapLCXKTc2SKGZd0HSXEBlfaC3acAvMRuM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/U2gJtF+YfLeh9VSlGi00oN5882kMh3O9Qv7pu y8SBWsCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/1AAKCRCcnaoHP2RA2Zh4CA DKB+mFult4bNlb0X5f7txABWLb7OuWlMzPbobhCZKTVu8knO0hv3uGkt35uKLFawt1pyeKcKKnIqRx +MW0D191S9M0mz07raSFNXDsCGhN5UhBUfZh04O00UyC2g4rZuUwya1M75iybZ/Q/IIzL2L3WmCjup v307880KKy1R2yncrOtge88vkJJ0EaNuyRGtxWb6WgESIbxK8Ygv5/V1esxnwcpl7FKI+yBkvPKZtb SxIqjjNpGV0QNUdQfEQUvZ157JA17TnIkDLIsDIYW2OcFeVfXHixgFh5stvJbKRTXV+CTAvuEYxZ3/ T48m+JSdTpS0MJdRpYlX9QXN973eKt
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1cee4ab36acef271be9101590756ed0c0c374d9 upstream.

It can happen that the parent of a bfqq changes between the moment we
decide two queues are worth to merge (and set bic->stable_merge_bfqq)
and the moment bfq_setup_merge() is called. This can happen e.g. because
the process submitted IO for a different cgroup and thus bfqq got
reparented. It can even happen that the bfqq we are merging with has
parent cgroup that is already offline and going to be destroyed in which
case the merge can lead to use-after-free issues such as:

BUG: KASAN: use-after-free in __bfq_deactivate_entity+0x9cb/0xa50
Read of size 8 at addr ffff88800693c0c0 by task runc:[2:INIT]/10544

CPU: 0 PID: 10544 Comm: runc:[2:INIT] Tainted: G            E     5.15.2-0.g5fb85fd-default #1 openSUSE Tumbleweed (unreleased) f1f3b891c72369aebecd2e43e4641a6358867c70
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x46/0x5a
 print_address_description.constprop.0+0x1f/0x140
 ? __bfq_deactivate_entity+0x9cb/0xa50
 kasan_report.cold+0x7f/0x11b
 ? __bfq_deactivate_entity+0x9cb/0xa50
 __bfq_deactivate_entity+0x9cb/0xa50
 ? update_curr+0x32f/0x5d0
 bfq_deactivate_entity+0xa0/0x1d0
 bfq_del_bfqq_busy+0x28a/0x420
 ? resched_curr+0x116/0x1d0
 ? bfq_requeue_bfqq+0x70/0x70
 ? check_preempt_wakeup+0x52b/0xbc0
 __bfq_bfqq_expire+0x1a2/0x270
 bfq_bfqq_expire+0xd16/0x2160
 ? try_to_wake_up+0x4ee/0x1260
 ? bfq_end_wr_async_queues+0xe0/0xe0
 ? _raw_write_unlock_bh+0x60/0x60
 ? _raw_spin_lock_irq+0x81/0xe0
 bfq_idle_slice_timer+0x109/0x280
 ? bfq_dispatch_request+0x4870/0x4870
 __hrtimer_run_queues+0x37d/0x700
 ? enqueue_hrtimer+0x1b0/0x1b0
 ? kvm_clock_get_cycles+0xd/0x10
 ? ktime_get_update_offsets_now+0x6f/0x280
 hrtimer_interrupt+0x2c8/0x740

Fix the problem by checking that the parent of the two bfqqs we are
merging in bfq_setup_merge() is the same.

Link: https://lore.kernel.org/linux-block/20211125172809.GC19572@quack2.suse.cz/
CC: stable@vger.kernel.org
Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-2-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bfq-iosched.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index bab5122062f5..e14f421282dd 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2509,6 +2509,14 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	if (process_refs == 0 || new_process_refs == 0)
 		return NULL;
 
+	/*
+	 * Make sure merged queues belong to the same parent. Parents could
+	 * have changed since the time we decided the two queues are suitable
+	 * for merging.
+	 */
+	if (new_bfqq->entity.parent != bfqq->entity.parent)
+		return NULL;
+
 	bfq_log_bfqq(bfqq->bfqd, bfqq, "scheduling merge with queue %d",
 		new_bfqq->pid);
 
-- 
2.35.3

