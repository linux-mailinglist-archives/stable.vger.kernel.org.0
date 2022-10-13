Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EA85FD031
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiJMAZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJMAXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21533AC48B;
        Wed, 12 Oct 2022 17:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D45616C2;
        Thu, 13 Oct 2022 00:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7953C43141;
        Thu, 13 Oct 2022 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620304;
        bh=uRmHCUX63YBGiTRGsBpssZqpTdFnfepauf0+F2d4CTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMX0g8AUfDuETLU+qMKG7eYkPUDlsSz3HcKPBSeOb8SCnWHDesb9zUx9hhICP/LNz
         JJNm+F/BXkGoPsWxyBzyObv+sOaeiT49wM8PAn7fym/V3doQpDVyHsUNLWRLPLUb01
         WmDxfymd/GYRx+tc6T5alasnYCsRXxtWpgumdwWGCZTbQHE4it8ZvJBmLN4MkBAnae
         IUxQr+nyPPJb5r1cYP9DL4z4u9MY1L4haANzlqNi+4VMm92LukUekg7Q11WMbrCGln
         dh4KNn3siDmefVOIDmFCTLiAXp49hcS6RQ5QqnA1ULTsnFPH2o6ss4eBv05H6p6Gfp
         moUgjku7zgORA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 64/67] sbitmap: fix lockup while swapping
Date:   Wed, 12 Oct 2022 20:15:45 -0400
Message-Id: <20221013001554.1892206-64-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0 ]

Commit 4acb83417cad ("sbitmap: fix batched wait_cnt accounting")
is a big improvement: without it, I had to revert to before commit
040b83fcecfb ("sbitmap: fix possible io hung due to lost wakeup")
to avoid the high system time and freezes which that had introduced.

Now okay on the NVME laptop, but 4acb83417cad is a disaster for heavy
swapping (kernel builds in low memory) on another: soon locking up in
sbitmap_queue_wake_up() (into which __sbq_wake_up() is inlined), cycling
around with waitqueue_active() but wait_cnt 0 .  Here is a backtrace,
showing the common pattern of outer sbitmap_queue_wake_up() interrupted
before setting wait_cnt 0 back to wake_batch (in some cases other CPUs
are idle, in other cases they're spinning for a lock in dd_bio_merge()):

sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
__blk_mq_free_request < blk_mq_free_request < __blk_mq_end_request <
scsi_end_request < scsi_io_completion < scsi_finish_command <
scsi_complete < blk_complete_reqs < blk_done_softirq < __do_softirq <
__irq_exit_rcu < irq_exit_rcu < common_interrupt < asm_common_interrupt <
_raw_spin_unlock_irqrestore < __wake_up_common_lock < __wake_up <
sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
__blk_mq_free_request < blk_mq_free_request < dd_bio_merge <
blk_mq_sched_bio_merge < blk_mq_attempt_bio_merge < blk_mq_submit_bio <
__submit_bio < submit_bio_noacct_nocheck < submit_bio_noacct <
submit_bio < __swap_writepage < swap_writepage < pageout <
shrink_folio_list < evict_folios < lru_gen_shrink_lruvec <
shrink_lruvec < shrink_node < do_try_to_free_pages < try_to_free_pages <
__alloc_pages_slowpath < __alloc_pages < folio_alloc < vma_alloc_folio <
do_anonymous_page < __handle_mm_fault < handle_mm_fault <
do_user_addr_fault < exc_page_fault < asm_exc_page_fault

See how the process-context sbitmap_queue_wake_up() has been interrupted,
after bringing wait_cnt down to 0 (and in this example, after doing its
wakeups), before advancing wake_index and refilling wake_cnt: an
interrupt-context sbitmap_queue_wake_up() of the same sbq gets stuck.

I have almost no grasp of all the possible sbitmap races, and their
consequences: but __sbq_wake_up() can do nothing useful while wait_cnt 0,
so it is better if sbq_wake_ptr() skips on to the next ws in that case:
which fixes the lockup and shows no adverse consequence for me.

The check for wait_cnt being 0 is obviously racy, and ultimately can lead
to lost wakeups: for example, when there is only a single waitqueue with
waiters.  However, lost wakeups are unlikely to matter in these cases,
and a proper fix requires redesign (and benchmarking) of the batched
wakeup code: so let's plug the hole with this bandaid for now.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/9c2038a7-cdc5-5ee-854c-fbc6168bf16@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 29eb0484215a..e000aaf6dbde 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -588,7 +588,7 @@ static struct sbq_wait_state *sbq_wake_ptr(struct sbitmap_queue *sbq)
 	for (i = 0; i < SBQ_WAIT_QUEUES; i++) {
 		struct sbq_wait_state *ws = &sbq->ws[wake_index];
 
-		if (waitqueue_active(&ws->wait)) {
+		if (waitqueue_active(&ws->wait) && atomic_read(&ws->wait_cnt)) {
 			if (wake_index != atomic_read(&sbq->wake_index))
 				atomic_set(&sbq->wake_index, wake_index);
 			return ws;
-- 
2.35.1

