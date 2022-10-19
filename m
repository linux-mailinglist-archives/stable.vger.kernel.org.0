Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3330D604E93
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJSRZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 13:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJSRZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 13:25:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFFA1ABEEB;
        Wed, 19 Oct 2022 10:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0D7BB8224C;
        Wed, 19 Oct 2022 17:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8EC433C1;
        Wed, 19 Oct 2022 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666200333;
        bh=KpXGLm+LpDTu1Ci0etA6NTQ4Elo0IFUKhppE4uYn7F0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DRJtd5yWLZn5yTGSTlJscsLl2D5gw5li+GQEUxw4YfHEabHzdt+s+94q5++O2UP8J
         Uwamw2+bW/jnDGwIIvPC3NnfBa/zhCxQhefriPrA4+3FXuzoa/Tg3OyiNJTNsgQgJw
         ShSpw2H83ZPAY/QStkmABaToh4k61i1YKO/vHUIU=
Date:   Wed, 19 Oct 2022 19:25:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 6.0 479/862] sbitmap: fix possible io hung due to lost
 wakeup
Message-ID: <Y1AzCuwWxEPoYGRr@kroah.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083311.114449669@linuxfoundation.org>
 <174a196-5473-4e93-a52a-5e26eb37949@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174a196-5473-4e93-a52a-5e26eb37949@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 08:06:26AM -0700, Hugh Dickins wrote:
> On Wed, 19 Oct 2022, Greg Kroah-Hartman wrote:
> 
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > [ Upstream commit 040b83fcecfb86f3225d3a5de7fd9b3fbccf83b4 ]
> > 
> > There are two problems can lead to lost wakeup:
> > 
> > 1) invalid wakeup on the wrong waitqueue:
> > 
> > For example, 2 * wake_batch tags are put, while only wake_batch threads
> > are woken:
> > 
> > __sbq_wake_up
> >  atomic_cmpxchg -> reset wait_cnt
> > 			__sbq_wake_up -> decrease wait_cnt
> > 			...
> > 			__sbq_wake_up -> wait_cnt is decreased to 0 again
> > 			 atomic_cmpxchg
> > 			 sbq_index_atomic_inc -> increase wake_index
> > 			 wake_up_nr -> wake up and waitqueue might be empty
> >  sbq_index_atomic_inc -> increase again, one waitqueue is skipped
> >  wake_up_nr -> invalid wake up because old wakequeue might be empty
> > 
> > To fix the problem, increasing 'wake_index' before resetting 'wait_cnt'.
> > 
> > 2) 'wait_cnt' can be decreased while waitqueue is empty
> > 
> > As pointed out by Jan Kara, following race is possible:
> > 
> > CPU1				CPU2
> > __sbq_wake_up			 __sbq_wake_up
> >  sbq_wake_ptr()			 sbq_wake_ptr() -> the same
> >  wait_cnt = atomic_dec_return()
> >  /* decreased to 0 */
> >  sbq_index_atomic_inc()
> >  /* move to next waitqueue */
> >  atomic_set()
> >  /* reset wait_cnt */
> >  wake_up_nr()
> >  /* wake up on the old waitqueue */
> > 				 wait_cnt = atomic_dec_return()
> > 				 /*
> > 				  * decrease wait_cnt in the old
> > 				  * waitqueue, while it can be
> > 				  * empty.
> > 				  */
> > 
> > Fix the problem by waking up before updating 'wake_index' and
> > 'wait_cnt'.
> > 
> > With this patch, noted that 'wait_cnt' is still decreased in the old
> > empty waitqueue, however, the wakeup is redirected to a active waitqueue,
> > and the extra decrement on the old empty waitqueue is not handled.
> > 
> > Fixes: 88459642cba4 ("blk-mq: abstract tag allocation out into sbitmap library")
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Link: https://lore.kernel.org/r/20220803121504.212071-1-yukuai1@huaweicloud.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I have no authority on linux-block, but I'll say NAK to this one
> (and 517/862), and let Jens and Jan overrule me if they disagree.
> 
> This was the first of several 6.1-rc1 commits which had given me lost
> wakeups never suffered before; was not tagged Cc stable; and (unless I've
> missed it on lore) never had AUTOSEL posted to linux-block or linux-kernel.

Ok, thanks for the review.  I'll drop both of the sbitmap.c changes and
if people report issues and want them back, I'll be glad to revisit them
then.

greg k-h
