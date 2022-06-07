Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F6B540F5A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353146AbiFGTGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353270AbiFGTDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03FA157EA0;
        Tue,  7 Jun 2022 11:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1BED617B4;
        Tue,  7 Jun 2022 18:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BC3C385A5;
        Tue,  7 Jun 2022 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625120;
        bh=CWpacpZV+I6h3XbEbMIyLimtNJRi0jOE44ohDqfFBnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9pxmpKOP5O4PgGqFU6sQtEJarx9E6BPKO6pF38q4rn5TqtPYGWkFJfvmg6KO/BG9
         5gu4UE00F+TrDezpV0UOCJNKlYBnB3wgrf79N6l72TGyp6A5eY+UPAeahKWZYRvf0E
         99OpTTgCNfGRmM83ooe/5ysTN2nhPR07IQ6KEJW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 532/667] bfq: Avoid merging queues with different parents
Date:   Tue,  7 Jun 2022 19:03:17 +0200
Message-Id: <20220607164950.657788528@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2636,6 +2636,14 @@ bfq_setup_merge(struct bfq_queue *bfqq,
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
 


