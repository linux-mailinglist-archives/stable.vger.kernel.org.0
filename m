Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393485FDF9A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJMR4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJMR4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5C8F59F;
        Thu, 13 Oct 2022 10:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB566190D;
        Thu, 13 Oct 2022 17:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DF1C433D7;
        Thu, 13 Oct 2022 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683680;
        bh=cQmTBN0foGWCi59dK1maBcbg3QEnLAPLThKUvVB42lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARt37l/UJHo3F8kSPiD80J6hhXkgCwCWfxV7q4JRx4SWHQ8Yo4nilJBj8pCA+Sc7S
         uDEiaf+P09Ka2C8TIg9PAA93+SLpIbTV5KTO1Cp8XAPWf9vezyhJg286QVCuiec/5/
         +Eg6s8pHIh07KIpeh+oTg1rGn0fMi76qO9MgKug4aKR/Kv4sIFnZgx+3K+MtPx3e8Y
         r02Xyf1NfeBoCcoTs1v/6hCaRIYxtsjAlcc2tTLQvpiumTerceqpiq5Hu9aW4dshIX
         41w0oyAzdMLx0JsqADVHQAbEhJzX1reI0g5Fzy/G6L1VecwqerV5QweAqJ0QWxUFmw
         DL1brXX5wS4ww==
Date:   Thu, 13 Oct 2022 13:54:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 64/67] sbitmap: fix lockup while swapping
Message-ID: <Y0hQ300MiPc4GBvh@sashalap>
References: <20221013001554.1892206-1-sashal@kernel.org>
 <20221013001554.1892206-64-sashal@kernel.org>
 <d095e91-046-10e9-225e-de3aecd5e8b3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d095e91-046-10e9-225e-de3aecd5e8b3@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 06:08:50PM -0700, Hugh Dickins wrote:
>On Wed, 12 Oct 2022, Sasha Levin wrote:
>
>> From: Hugh Dickins <hughd@google.com>
>>
>> [ Upstream commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0 ]
>>
>> Commit 4acb83417cad ("sbitmap: fix batched wait_cnt accounting")
>> is a big improvement: without it, I had to revert to before commit
>> 040b83fcecfb ("sbitmap: fix possible io hung due to lost wakeup")
>> to avoid the high system time and freezes which that had introduced.
>>
>> Now okay on the NVME laptop, but 4acb83417cad is a disaster for heavy
>> swapping (kernel builds in low memory) on another: soon locking up in
>> sbitmap_queue_wake_up() (into which __sbq_wake_up() is inlined), cycling
>> around with waitqueue_active() but wait_cnt 0 .  Here is a backtrace,
>> showing the common pattern of outer sbitmap_queue_wake_up() interrupted
>> before setting wait_cnt 0 back to wake_batch (in some cases other CPUs
>> are idle, in other cases they're spinning for a lock in dd_bio_merge()):
>>
>> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
>> __blk_mq_free_request < blk_mq_free_request < __blk_mq_end_request <
>> scsi_end_request < scsi_io_completion < scsi_finish_command <
>> scsi_complete < blk_complete_reqs < blk_done_softirq < __do_softirq <
>> __irq_exit_rcu < irq_exit_rcu < common_interrupt < asm_common_interrupt <
>> _raw_spin_unlock_irqrestore < __wake_up_common_lock < __wake_up <
>> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
>> __blk_mq_free_request < blk_mq_free_request < dd_bio_merge <
>> blk_mq_sched_bio_merge < blk_mq_attempt_bio_merge < blk_mq_submit_bio <
>> __submit_bio < submit_bio_noacct_nocheck < submit_bio_noacct <
>> submit_bio < __swap_writepage < swap_writepage < pageout <
>> shrink_folio_list < evict_folios < lru_gen_shrink_lruvec <
>> shrink_lruvec < shrink_node < do_try_to_free_pages < try_to_free_pages <
>> __alloc_pages_slowpath < __alloc_pages < folio_alloc < vma_alloc_folio <
>> do_anonymous_page < __handle_mm_fault < handle_mm_fault <
>> do_user_addr_fault < exc_page_fault < asm_exc_page_fault
>>
>> See how the process-context sbitmap_queue_wake_up() has been interrupted,
>> after bringing wait_cnt down to 0 (and in this example, after doing its
>> wakeups), before advancing wake_index and refilling wake_cnt: an
>> interrupt-context sbitmap_queue_wake_up() of the same sbq gets stuck.
>>
>> I have almost no grasp of all the possible sbitmap races, and their
>> consequences: but __sbq_wake_up() can do nothing useful while wait_cnt 0,
>> so it is better if sbq_wake_ptr() skips on to the next ws in that case:
>> which fixes the lockup and shows no adverse consequence for me.
>>
>> The check for wait_cnt being 0 is obviously racy, and ultimately can lead
>> to lost wakeups: for example, when there is only a single waitqueue with
>> waiters.  However, lost wakeups are unlikely to matter in these cases,
>> and a proper fix requires redesign (and benchmarking) of the batched
>> wakeup code: so let's plug the hole with this bandaid for now.
>>
>> Signed-off-by: Hugh Dickins <hughd@google.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Keith Busch <kbusch@kernel.org>
>> Link: https://lore.kernel.org/r/9c2038a7-cdc5-5ee-854c-fbc6168bf16@google.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Whoa!  NAK to this 6.0 backport, and to the 5.19, 5.15, 5.10, 5.4
>AUTOSEL backports of the same commit.  I never experienced such a
>lockup on those releases.  Or have I missed announcements of stable
>backports of the whole series of 6.1-rc commits to which this one
>is a fix?  (I hope not.)

Happy to drop it.

>I'm happy for my NAK to be overruled by Jens or Jan or Keith,
>if they see virtue in this commit, beyond what I'm aware of:
>but as it stands, it looks like AUTOSEL out of control again -
>it found the word "fix", and found that the commit applies cleanly,
>so thinks it must be a good stable addition.  Not necessarily so!

I'm a bit confused: the subject of the patch is "fix lockup while
swapping" and the body describes a lockup and that this patch "fixes the
lockup and shows no adverse consequence". What am I missing?

-- 
Thanks,
Sasha
