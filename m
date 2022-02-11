Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3414B2815
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 15:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350942AbiBKOhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 09:37:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242516AbiBKOhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 09:37:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347CC188;
        Fri, 11 Feb 2022 06:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xDS2cI/G7I7Pz1FO/b0GGCLA/neDA3CUGtTdIi3Kxmw=; b=DiwyC2U1oICQI8XH4WIMg6OoP1
        da2zROQJylJHR/am2VUi7ytvDHVJrPRl4sNIbRymv3jjuN55pqSKvmP3kqaGmCnr/1wOP5Vq2tlmq
        6tRpYF8Xekva5k0MKJRwl6L4nDPgOG3VIzFlIq0ExyRpChMgkKHFVgshddkUjWGNxDByZMsX9xZBn
        V2viILZgRTn1yFTHZPFymlzptBy68x8h0PeGfQcKxODbBo83AYxG5Cr0oxdkYLaMz9QCtVWzsNQ5V
        KU8wCsZHrkHfW3+rCRJ96XL5PuFqPhKNVNjSi8dxC42ECSAVzPXyrXx8lxmupOj/bvr7sRMP4ihEq
        aHCs6y1A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIX2t-00AThU-BS; Fri, 11 Feb 2022 14:37:11 +0000
Date:   Fri, 11 Feb 2022 14:37:11 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgZ0lyr91jw6JaHg@casper.infradead.org>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
 <YgTl2Lm9Vk50WNSj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgTl2Lm9Vk50WNSj@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 10:15:52AM +0000, Lee Jones wrote:
> On Wed, 09 Feb 2022, Darrick J. Wong wrote:
> 
> > On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> > > 
> > > Reverting since this commit opens a potential avenue for abuse.
> > 
> > What kind of abuse?  Did you conclude there's an avenue solely because
> > some combination of userspace rigging produced a BUG warning?  Or is
> > this a real problem that someone found?
> 
> Genuine question: Is the ability for userspace to crash the kernel
> not enough to cause concern?  I would have thought that we'd want to
> prevent this.

The kernel doesn't crash.  It's a BUG().  That means it kills the
task which caused the BUG().  If you've specified that the kernel should
crash on seeing a BUG(), well, you made that decision, and you get to
live with the consequences.

> The link provided doesn't contain any further analysis.  Only the
> reproducer and kernel configuration used, which are both too large to
> enter into a Git commit.

But not too large to put in an email.  Which you should have sent to
begin with, not a stupid reversion commit.

> > OH WAIT, you're running this on the Android 5.10 kernel, aren't you?
> > The BUG report came from page_buffers failing to find any buffer heads
> > attached to the page.
> > https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10-2022-02/fs/ext4/inode.c#2647
> 
> Yes, the H/W I have to prototype these on is a phone and the report
> that came in was specifically built against the aforementioned
> kernel.
> 
> > Yeah, don't care.
> 
> "There is nothing to worry about, as it's intended behaviour"?

No.  You've come in like a fucking meteorite full of arrogance and
ignorance.  Nobody's reacting well to you right now.  Start again,
write a good bug report in a new thread.
