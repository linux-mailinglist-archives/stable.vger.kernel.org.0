Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77638541D5B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379044AbiFGWNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379288AbiFGWMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E0225C1EE;
        Tue,  7 Jun 2022 12:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA0086193C;
        Tue,  7 Jun 2022 19:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6125C385A2;
        Tue,  7 Jun 2022 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629538;
        bh=e5wNp0liSpCAzGIDVPX0YO5ZBqBeAMUgByib04aqO7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pAtNk5Z6TTYOv1DKz5jGccyfcgXfgVdIRafipAVT3bLwwjllxSq5baWtp09eROCh
         NVjrF8P9bjBIQbi8ELM7WVbtoLdnTl/kQaIcXIPxUn3k6te36GnXGriFnzkaGP9YGy
         Wc+/LG4UhE8Xi9N+Z4/fXI5457bMqAxLhPaCqsVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 728/879] bfq: Avoid merging queues with different parents
Date:   Tue,  7 Jun 2022 19:04:06 +0200
Message-Id: <20220607165023.987810049@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -2762,6 +2762,14 @@ bfq_setup_merge(struct bfq_queue *bfqq,
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
 


