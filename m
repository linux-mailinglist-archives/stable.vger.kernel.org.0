Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D99621131
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiKHMqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbiKHMqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:46:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62FB51C31
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4232D61542
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8CFC433D6;
        Tue,  8 Nov 2022 12:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667911559;
        bh=y+VqKYcGkampCb4ygyfheZSZxYDjetOwk+9Mg6vQiNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWmfra7n3zqt7VW+C+BEWhILBIQIooxphrgI/k7RcoybBTz8sMnRIRCKnCHFkenvl
         7EjoThzfHo3k35Pud5GeOvcKMNA2Fj7GkSdLvDVaJ/l3kQPdJQ9wKo7oC+ipFyXaCb
         dohoooZOH2mMbcYWe+aikZ1+PvGxTOuNy5GpF7+k=
Date:   Tue, 8 Nov 2022 13:45:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     stable@vger.kernel.org, lcapitulino@gmail.com,
        Vasily Averin <vvs@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Roman Gushchin <guro@fb.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yutian Yang <nglaive@gmail.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10, 5.4] memcg: enable accounting of ipc resources
Message-ID: <Y2pPhBL2g8fmqdql@kroah.com>
References: <20221104184131.17797-1-luizcap@amazon.com>
 <Y2jMXfbLTHwDBInx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jMXfbLTHwDBInx@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 10:14:05AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Nov 04, 2022 at 06:41:31PM +0000, Luiz Capitulino wrote:
> > From: Vasily Averin <vvs@virtuozzo.com>
> > 
> > Commit 18319498fdd4cdf8c1c2c48cd432863b1f915d6f upstream.
> > 
> > [ This backport fixes CVE-2021-3759 for 5.10 and 5.4. Please, note that
> >   it caused conflicts in all files being changed because upstream
> >   changed ipc object allocation to and from kvmalloc() & friends (eg.
> >   commits bc8136a543aa and fc37a3b8b4388e). However, I decided to keep
> >   this backport about the memcg accounting fix only. ]
> 
> Looks good, now queued up, thanks.

Ah, but you missed a fix-up patch for this one {sigh}

I've now queued up 18319498fdd4 ("memcg: enable accounting of ipc
resources") as well.  Please be more careful in the future when
backporting changes that you also include the fixes for those changes.

thanks,

greg k-h
