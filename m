Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85DE241787
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgHKHps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgHKHpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:45:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4999C06174A;
        Tue, 11 Aug 2020 00:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mvBglLhqvGMAFuaPGFgRV204Qh8cN+T3G3Kwu055G6c=; b=sNGFyDNRyAVLLb/esg/uL4KXQI
        oP4g8D+ZTk0n4UzJLPNZOaZ2O+ygnBhcrRF69yS0OZsaKkkjXkj4XpfDU8qF9dHXKPUuCYuWaz7mr
        i6hkUMXL9+U+xpQrPxMsIfeafR5Ppoxxal10bp22yXtjAroBEU7qqyCPEpaoUxTgCN1elEVTIATNL
        rXMhAiXw7csosoMranEKeykZ7mJhT8X6qn1oLKGLhoDnB7MIJkcs7qV3YcpdDetp39xXSCm82lCod
        fR+XMimyZfEE/dsgWSdN6It50NAAtADTtcaOnQGPXt05Eop+0cNGdWjOYQaDRitdbZqidBoXcrM9K
        IygYoxOw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5OyZ-0005qy-RS; Tue, 11 Aug 2020 07:45:40 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D35FF980C9D; Tue, 11 Aug 2020 09:45:38 +0200 (CEST)
Date:   Tue, 11 Aug 2020 09:45:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811074538.GS3982@worktop.programming.kicks-ass.net>
References: <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811071401.GB21797@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 09:14:02AM +0200, Oleg Nesterov wrote:
> On 08/11, Peter Zijlstra wrote:
> >
> > On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
> > >
> > > ->jobctl is always modified with ->siglock held, do we really need
> > > WRITE_ONCE() ?
> >
> > In theory, yes. The compiler doesn't know about locks, it can tear
> > writes whenever it feels like it.
> 
> Yes, but why does this matter? Could you spell please?

Ah, well, that I don't konw. Why do we need the READ_ONCE() ?

It does:

> +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
> +                   lock_task_sighand(task, &flags)) {

and the lock_task_sighand() implies barrier(), so I thought the reason
for the READ_ONCE() was load-tearing, and then we need WRITE_ONCE() to
avoid store-tearing.
