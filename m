Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380F84866EA
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbiAFPpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:45:50 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47270 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbiAFPps (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:48 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B576F1F3A8;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeshiqmmWZD73GkSK4+N+GqKNPAYETIzxJpuE6/zef0=;
        b=1h9Gr/LPNxTD+nbAWYuY1xHYKDzUweSd9jyJXhTx6so4YECU59JdfAOX9xw2D8Na18Fy+N
        f623BXGHM9n6rI5gBrJ/LhA9ivaMTMh17IP2FGUWGXESyXbFhUsdjUxHaaRz1ifIxWlkgU
        I6rf71JyB6jyXrtXwV0iGvWk7TpUA8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeshiqmmWZD73GkSK4+N+GqKNPAYETIzxJpuE6/zef0=;
        b=/qSqzb2g3P3HU8QwdfzOf826zXr9IM9LXUpLnSrbBtUhHfdpmnzGH0F7TWHpywIVAPg+DI
        lvbQd6iwtBBf6ECQ==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9C81EA3B8A;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id CBFA9A083A; Wed,  5 Jan 2022 15:36:39 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] bfq: Avoid merging queues with different parents
Date:   Wed,  5 Jan 2022 15:36:33 +0100
Message-Id: <20220105143639.31266-2-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220105143037.20542-1-jack@suse.cz>
References: <20220105143037.20542-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2888; h=from:subject; bh=Wo1FkmvrgLnsLoxUN8FFedXWnRxiaMVst9kwBuKTVTg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh1azxCr2kJ3pthS1i4guH+kNkcoxQDTHDYlhq+Qn6 JBmDeFCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdWs8QAKCRCcnaoHP2RA2UmGCA CUjIq/XvhxPKEvNHEmv77TbZdLW/4H+NWEz3Ul4Mi7OKUBmSPfDAqXnG2Ga4wD5aSR2LByk5n81ZSO ps9IHFU71GPaV98e2Z1uEKEUe41s3oHUwm/moq2UqWtUseNet57GFFx8gEBVlNrt6RccaAONRSe4HH uW0gjtuZ9Qbew3edY3/zoL274OD10Pm+XyG81JDL8SZqsIVWNfsGOCi40dIWp2ebFoKBdruT1t9ASv LT+wGMn1ELIAqd0jqvm8dV45UaE5mW2ekX9L18jHAQfm5WO9ksPJaPPzgwePgjG4iw/MOTcDfUAc9b Az/RmgNatgvvYCIlG7YZ3whYoZnI8k
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 056399185c2f..0da47f2ca781 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2638,6 +2638,14 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
2.31.1

