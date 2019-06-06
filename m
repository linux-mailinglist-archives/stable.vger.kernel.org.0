Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811C037264
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFFLFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6381 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFFLFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:05:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5D5B30872C3;
        Thu,  6 Jun 2019 11:05:32 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 459EC2A333;
        Thu,  6 Jun 2019 11:05:23 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 13:05:32 +0200 (CEST)
Date:   Thu, 6 Jun 2019 13:05:22 +0200
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
Message-ID: <20190606110522.GA4691@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
 <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
 <1285a2e60e3748d8825b9b0e3500cd28@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285a2e60e3748d8825b9b0e3500cd28@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 06 Jun 2019 11:05:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/06, David Laight wrote:
>
> If a signal handler is called, I presume that the trampoline
> calls back into the kernel to get further handlers called
> and to finally restore the original signal mask?

See sigmask_to_save(), this is what the kernel records in uc.uc_sigmask
before the signal handler runs, after that current->saved_sigmask has no
meaning.

When signal handler returns it does sys_rt_sigreturn() which restores
the original mask saved in uc_sigmask.

> What happens if a signal handler calls something that
> would normally write to current->saved_sigmask?

See above.

Oleg.

