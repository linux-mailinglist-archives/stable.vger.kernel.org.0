Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB385FD246
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiJMBLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJMBKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:10:54 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FF713B8E7
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 18:09:23 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w74so325897oie.0
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 18:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xf3ywIhHM9l2Wv8OGxvga9Ek0khQJDs+xm+RwpRpURg=;
        b=TK1cggRmikScjmtske9BKC2x6fabcmz7k0/W8FBUD86SiPlXFIMh15uDp+I3MFavKJ
         ArPYODfYZXM/5c+Pf3WMMqmtdP0hEltjKBzRwut/Rj35//DWszKKGKaqg4KxAhVh9ys3
         0RLH3pcrja6kxl/80SzxsWoM+x0EqapvcYB1aITC5FsipIgR/8LGeyItHU+oqHYzFrUP
         xqIKYiyb+iIcN0H0XYgN3Es5u8eS+DwJFrzWj5UwGHQ3GIHAPAkoUSTBkpSqWGcRik5Z
         ZQ7Adfmfy28M62OrluHXkhcRlmWoWGu1dZd5TLQ7cOsKlkiSNOFpDhwclXNC9juEETaD
         q+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf3ywIhHM9l2Wv8OGxvga9Ek0khQJDs+xm+RwpRpURg=;
        b=CJbSZX49meFXdIWyUCLn+CA6JUyV8wo2AHMprfbu+z2FWBGXQ8snBeOlqGll2unUEv
         7XNIgpbb18x8eXVjZpOuu5wkvwMWIzHgonZWODoYCHElR4wfPolsuk80qGg6B2kdAUDS
         y2YPdfdNknHAnPrWrptpWWBcs1R51ruZWAz+K9q2hTd5yYyDbIJt39BZMTcFXfaV7hCf
         41bVM0DqWvyNOf9d6nlEhlDnnerdyR8e+SAJbrT94VQmMb6rAT3MeADAv5vLu+UR2oJF
         PofkG7OGZqKu2TQ01nvENZ7JZKXcqRUDutMIhNVKVNMQLU9cBGPrCJZZCJ7bXjUqAxwK
         03aA==
X-Gm-Message-State: ACrzQf20Y+NdZnxZo++0xI6LXwmEKv15KEEVIe2plzcfx1ED3pV8KymN
        FsZ0VFGu6gvqZuZPyGp83dn5QA==
X-Google-Smtp-Source: AMsMyM64LXHHj4T87FkDDEefF5hWXwqWnoZiW7BSBOq1o5gxRsBEkEjb3upYUpoVgHStdb6DwgF0cw==
X-Received: by 2002:a05:6808:603:b0:354:948f:f045 with SMTP id y3-20020a056808060300b00354948ff045mr3288694oih.268.1665623340106;
        Wed, 12 Oct 2022 18:09:00 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id n8-20020a056870240800b001326b043f37sm1885113oap.36.2022.10.12.18.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 18:08:59 -0700 (PDT)
Date:   Wed, 12 Oct 2022 18:08:50 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 64/67] sbitmap: fix lockup while swapping
In-Reply-To: <20221013001554.1892206-64-sashal@kernel.org>
Message-ID: <d095e91-046-10e9-225e-de3aecd5e8b3@google.com>
References: <20221013001554.1892206-1-sashal@kernel.org> <20221013001554.1892206-64-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Oct 2022, Sasha Levin wrote:

> From: Hugh Dickins <hughd@google.com>
> 
> [ Upstream commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0 ]
> 
> Commit 4acb83417cad ("sbitmap: fix batched wait_cnt accounting")
> is a big improvement: without it, I had to revert to before commit
> 040b83fcecfb ("sbitmap: fix possible io hung due to lost wakeup")
> to avoid the high system time and freezes which that had introduced.
> 
> Now okay on the NVME laptop, but 4acb83417cad is a disaster for heavy
> swapping (kernel builds in low memory) on another: soon locking up in
> sbitmap_queue_wake_up() (into which __sbq_wake_up() is inlined), cycling
> around with waitqueue_active() but wait_cnt 0 .  Here is a backtrace,
> showing the common pattern of outer sbitmap_queue_wake_up() interrupted
> before setting wait_cnt 0 back to wake_batch (in some cases other CPUs
> are idle, in other cases they're spinning for a lock in dd_bio_merge()):
> 
> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
> __blk_mq_free_request < blk_mq_free_request < __blk_mq_end_request <
> scsi_end_request < scsi_io_completion < scsi_finish_command <
> scsi_complete < blk_complete_reqs < blk_done_softirq < __do_softirq <
> __irq_exit_rcu < irq_exit_rcu < common_interrupt < asm_common_interrupt <
> _raw_spin_unlock_irqrestore < __wake_up_common_lock < __wake_up <
> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
> __blk_mq_free_request < blk_mq_free_request < dd_bio_merge <
> blk_mq_sched_bio_merge < blk_mq_attempt_bio_merge < blk_mq_submit_bio <
> __submit_bio < submit_bio_noacct_nocheck < submit_bio_noacct <
> submit_bio < __swap_writepage < swap_writepage < pageout <
> shrink_folio_list < evict_folios < lru_gen_shrink_lruvec <
> shrink_lruvec < shrink_node < do_try_to_free_pages < try_to_free_pages <
> __alloc_pages_slowpath < __alloc_pages < folio_alloc < vma_alloc_folio <
> do_anonymous_page < __handle_mm_fault < handle_mm_fault <
> do_user_addr_fault < exc_page_fault < asm_exc_page_fault
> 
> See how the process-context sbitmap_queue_wake_up() has been interrupted,
> after bringing wait_cnt down to 0 (and in this example, after doing its
> wakeups), before advancing wake_index and refilling wake_cnt: an
> interrupt-context sbitmap_queue_wake_up() of the same sbq gets stuck.
> 
> I have almost no grasp of all the possible sbitmap races, and their
> consequences: but __sbq_wake_up() can do nothing useful while wait_cnt 0,
> so it is better if sbq_wake_ptr() skips on to the next ws in that case:
> which fixes the lockup and shows no adverse consequence for me.
> 
> The check for wait_cnt being 0 is obviously racy, and ultimately can lead
> to lost wakeups: for example, when there is only a single waitqueue with
> waiters.  However, lost wakeups are unlikely to matter in these cases,
> and a proper fix requires redesign (and benchmarking) of the batched
> wakeup code: so let's plug the hole with this bandaid for now.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Link: https://lore.kernel.org/r/9c2038a7-cdc5-5ee-854c-fbc6168bf16@google.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Whoa!  NAK to this 6.0 backport, and to the 5.19, 5.15, 5.10, 5.4
AUTOSEL backports of the same commit.  I never experienced such a
lockup on those releases.  Or have I missed announcements of stable
backports of the whole series of 6.1-rc commits to which this one
is a fix?  (I hope not.)

I'm happy for my NAK to be overruled by Jens or Jan or Keith,
if they see virtue in this commit, beyond what I'm aware of:
but as it stands, it looks like AUTOSEL out of control again -
it found the word "fix", and found that the commit applies cleanly,
so thinks it must be a good stable addition.  Not necessarily so!

Hugh

> ---
>  lib/sbitmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index 29eb0484215a..e000aaf6dbde 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -588,7 +588,7 @@ static struct sbq_wait_state *sbq_wake_ptr(struct sbitmap_queue *sbq)
>  	for (i = 0; i < SBQ_WAIT_QUEUES; i++) {
>  		struct sbq_wait_state *ws = &sbq->ws[wake_index];
>  
> -		if (waitqueue_active(&ws->wait)) {
> +		if (waitqueue_active(&ws->wait) && atomic_read(&ws->wait_cnt)) {
>  			if (wake_index != atomic_read(&sbq->wake_index))
>  				atomic_set(&sbq->wake_index, wake_index);
>  			return ws;
> -- 
> 2.35.1
