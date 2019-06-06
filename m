Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D8137466
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 14:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfFFMlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 08:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbfFFMlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 08:41:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B79F93086273;
        Thu,  6 Jun 2019 12:41:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id A935E7D65A;
        Thu,  6 Jun 2019 12:41:04 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 14:41:11 +0200 (CEST)
Date:   Thu, 6 Jun 2019 14:41:03 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Message-ID: <20190606124103.GB4691@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
 <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
 <1285a2e60e3748d8825b9b0e3500cd28@AcuMS.aculab.com>
 <20190606110522.GA4691@redhat.com>
 <6e3eeb101a30431eb111ad739ab5d2b0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3eeb101a30431eb111ad739ab5d2b0@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 06 Jun 2019 12:41:32 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/06, David Laight wrote:
>
> Some of this code is hard to grep through :-)

I'd suggest to simply read the kernel code once and memorise it, after
that you will not need to use grep.

> > When signal handler returns it does sys_rt_sigreturn() which restores
> > the original mask saved in uc_sigmask.
>
> Does that mean that if 2 signals interrupt epoll_wait() only
> one of the signal handlers is run?

I'll assume that both signals were blocked before syscall and temporary
unblocked by pselect.

Quite contrary, they both will be delivered exactly because original mask
won't be restored until the 1st handler returns.

Unless, of course, the sigaction->sa_mask of the 1st signal blocks another
one.

Didn't I say you do not read my emails? I have already explained this to
you in this thread ;)

Oleg.

