Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFC35FE1B4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJMSoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJMSnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:43:24 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153134F1A1
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 11:41:28 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id a24so2277772qto.10
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 11:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BumlHx0TbfQLcFeagrlufzZWok4cptrV+jGQa6OSx7M=;
        b=jBSO50SWb8vc1i7NmBGUyugVxbPggZjjIygLfoGLl9bOi49sv61bD7+5ZXWvgavehS
         tS2iwjZwEvrq4Cu+9JFTgPvWLc4KdS8m0x2udE+zdkYnv+sM2TC48MgW4DJ+vwUZkmfG
         2kz+pK1Ctcla80XguQLCzbdLRIbbdm3wWrQ+wvqDvqAePIUZt6wzJP7Eprb9GlDs/8uc
         tPfg/zbd3J1JAzIFEcZksI+tVdWLgbBUCvjCa8WpMvztsVbrCABfY5R0z+R0D7YXu9Y+
         geVl4DlFebZKd/A+isMioID9EE2B3i9o037iSdMRuAcu3trjI7S/rpMPmXlIfuIY/h7w
         P2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BumlHx0TbfQLcFeagrlufzZWok4cptrV+jGQa6OSx7M=;
        b=Ao0N/lp1VSAcLPnEDT6OdUj6iMtw5mVctZdspW52+XuJ+qzjq/847TGEjiwVmSvyTX
         jPaFQDX8Tz1xQFKbr8CHWleIx6LF+Yt/rrQNSFFOYmI79Jg7zqzYL5PTPAfBzHRw7gNE
         pcbdogAaFRRBJGRiuI2W/TmSgtsIH49uD495zdoM3TgFUbkVzf0LNBEajo2EKyaGBJhI
         d37VB4/bGfjrMpF3YdBtnYEoskZ2+TGg3oBzSLYP8wCn9wENFlWCdN+YBGfEdZp5SyJa
         48F3MNUvadWK9OGNaGDS+Ixbi7AYcsOeA0KXrszP0Gkqtsfo3bRDCCpnj9+KrKp1IprP
         gO5A==
X-Gm-Message-State: ACrzQf0ozUZdQ4xrvyfsNnsJ/SBOP6xuC6sWFwr2YILRpslIbDabdWF9
        8fZDMuue1qXHzztldtdvIffcBTbGUuv0FQ==
X-Google-Smtp-Source: AMsMyM64FzDvDydexxog05qHw0m/l+QJTB1wUf3uzuPzdO7iT4gFXLOjkCUDgL/W0bFzBvg3HxW/Vw==
X-Received: by 2002:ac8:5f8d:0:b0:39c:beab:fc0d with SMTP id j13-20020ac85f8d000000b0039cbeabfc0dmr1042180qta.683.1665686456983;
        Thu, 13 Oct 2022 11:40:56 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id y10-20020a37f60a000000b006e2d087fd63sm336493qkj.63.2022.10.13.11.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:40:56 -0700 (PDT)
Date:   Thu, 13 Oct 2022 11:40:40 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Sasha Levin <sashal@kernel.org>
cc:     Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 64/67] sbitmap: fix lockup while swapping
In-Reply-To: <Y0hQ300MiPc4GBvh@sashalap>
Message-ID: <d3d53e6-dc99-ff84-25cd-1eb72341f1ca@google.com>
References: <20221013001554.1892206-1-sashal@kernel.org> <20221013001554.1892206-64-sashal@kernel.org> <d095e91-046-10e9-225e-de3aecd5e8b3@google.com> <Y0hQ300MiPc4GBvh@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Oct 2022, Sasha Levin wrote:
> On Wed, Oct 12, 2022 at 06:08:50PM -0700, Hugh Dickins wrote:
> >On Wed, 12 Oct 2022, Sasha Levin wrote:
> >
> >> From: Hugh Dickins <hughd@google.com>
> >>
> >> [ Upstream commit 30514bd2dd4e86a3ecfd6a93a3eadf7b9ea164a0 ]
> >>
> >> Commit 4acb83417cad ("sbitmap: fix batched wait_cnt accounting")
> >> is a big improvement: without it, I had to revert to before commit
> >> 040b83fcecfb ("sbitmap: fix possible io hung due to lost wakeup")
> >> to avoid the high system time and freezes which that had introduced.
> >>
> >> Now okay on the NVME laptop, but 4acb83417cad is a disaster for heavy
> >> swapping (kernel builds in low memory) on another: soon locking up in
> >> sbitmap_queue_wake_up() (into which __sbq_wake_up() is inlined), cycling
> >> around with waitqueue_active() but wait_cnt 0 .  Here is a backtrace,
> >> showing the common pattern of outer sbitmap_queue_wake_up() interrupted
> >> before setting wait_cnt 0 back to wake_batch (in some cases other CPUs
> >> are idle, in other cases they're spinning for a lock in dd_bio_merge()):
> >>
> >> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
> >> __blk_mq_free_request < blk_mq_free_request < __blk_mq_end_request <
> >> scsi_end_request < scsi_io_completion < scsi_finish_command <
> >> scsi_complete < blk_complete_reqs < blk_done_softirq < __do_softirq <
> >> __irq_exit_rcu < irq_exit_rcu < common_interrupt < asm_common_interrupt <
> >> _raw_spin_unlock_irqrestore < __wake_up_common_lock < __wake_up <
> >> sbitmap_queue_wake_up < sbitmap_queue_clear < blk_mq_put_tag <
> >> __blk_mq_free_request < blk_mq_free_request < dd_bio_merge <
> >> blk_mq_sched_bio_merge < blk_mq_attempt_bio_merge < blk_mq_submit_bio <
> >> __submit_bio < submit_bio_noacct_nocheck < submit_bio_noacct <
> >> submit_bio < __swap_writepage < swap_writepage < pageout <
> >> shrink_folio_list < evict_folios < lru_gen_shrink_lruvec <
> >> shrink_lruvec < shrink_node < do_try_to_free_pages < try_to_free_pages <
> >> __alloc_pages_slowpath < __alloc_pages < folio_alloc < vma_alloc_folio <
> >> do_anonymous_page < __handle_mm_fault < handle_mm_fault <
> >> do_user_addr_fault < exc_page_fault < asm_exc_page_fault
> >>
> >> See how the process-context sbitmap_queue_wake_up() has been interrupted,
> >> after bringing wait_cnt down to 0 (and in this example, after doing its
> >> wakeups), before advancing wake_index and refilling wake_cnt: an
> >> interrupt-context sbitmap_queue_wake_up() of the same sbq gets stuck.
> >>
> >> I have almost no grasp of all the possible sbitmap races, and their
> >> consequences: but __sbq_wake_up() can do nothing useful while wait_cnt 0,
> >> so it is better if sbq_wake_ptr() skips on to the next ws in that case:
> >> which fixes the lockup and shows no adverse consequence for me.
> >>
> >> The check for wait_cnt being 0 is obviously racy, and ultimately can lead
> >> to lost wakeups: for example, when there is only a single waitqueue with
> >> waiters.  However, lost wakeups are unlikely to matter in these cases,
> >> and a proper fix requires redesign (and benchmarking) of the batched
> >> wakeup code: so let's plug the hole with this bandaid for now.
> >>
> >> Signed-off-by: Hugh Dickins <hughd@google.com>
> >> Reviewed-by: Jan Kara <jack@suse.cz>
> >> Reviewed-by: Keith Busch <kbusch@kernel.org>
> >> Link:
> >> https://lore.kernel.org/r/9c2038a7-cdc5-5ee-854c-fbc6168bf16@google.com
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> >Whoa!  NAK to this 6.0 backport, and to the 5.19, 5.15, 5.10, 5.4
> >AUTOSEL backports of the same commit.  I never experienced such a
> >lockup on those releases.  Or have I missed announcements of stable
> >backports of the whole series of 6.1-rc commits to which this one
> >is a fix?  (I hope not.)
> 
> Happy to drop it.

Thanks.

> 
> >I'm happy for my NAK to be overruled by Jens or Jan or Keith,
> >if they see virtue in this commit, beyond what I'm aware of:
> >but as it stands, it looks like AUTOSEL out of control again -
> >it found the word "fix", and found that the commit applies cleanly,
> >so thinks it must be a good stable addition.  Not necessarily so!
> 
> I'm a bit confused: the subject of the patch is "fix lockup while
> swapping" and the body describes a lockup and that this patch "fixes the
> lockup and shows no adverse consequence". What am I missing?

You are missing that it was a commit to (Jens's branch for) 6.1, and
that the problematic commits called out in the comments above were
to (Jens's branch for) 6.1.  It had no Cc stable tag, and that was
intentional, because it was a fix for 6.1 alone.

Perhaps it would have helped AUTOSEL to exclude it, if it had a Fixes
tag, pointing to one of those 6.1 commits: the initial version did, but
in review we had agreed that it was unclear which commit was being fixed.

(I've been choosing my words a little carefully above, because the sbitmap
wakeup situation was not perfect before or after any of these 6.1 commits,
and Jan hopes to improve it in future.  For all I know, this little commit
might be an improvement in 6.0, or a disaster in 6.0: it has neither been
needed nor tested there.)

Hugh
