Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9240F141786
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgARMq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 07:46:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43618 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbgARMq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 07:46:58 -0500
Received: from ip5f5bf7da.dynamic.kabel-deutschland.de ([95.91.247.218] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isnV9-0000mc-9p; Sat, 18 Jan 2020 12:46:55 +0000
Date:   Sat, 18 Jan 2020 13:46:54 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <shallyn@cisco.com>, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>, stable@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Adrian Reber <adrian@lisas.de>
Subject: Re: [PATCH] ptrace: reintroduce usage of subjective credentials in
 ptrace_has_cap()
Message-ID: <20200118124653.k7exqcu4fyojd63e@wittgenstein>
References: <20200115171736.16994-1-christian.brauner@ubuntu.com>
 <CANaxB-wOJCc_Z3YXiokMeTLi2=rPf0-=7-bwAJnEjX-bDvTPEg@mail.gmail.com>
 <20200118011701.ciqiuutgyyvtk5a4@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200118011701.ciqiuutgyyvtk5a4@wittgenstein>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 02:17:01AM +0100, Christian Brauner wrote:
> On Fri, Jan 17, 2020 at 05:08:14PM -0800, Andrei Vagin wrote:
> > On Wed, Jan 15, 2020 at 9:18 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> > > introduced the ability to opt out of audit messages for accesses to
> > > various proc files since they are not violations of policy.
> > > While doing so it somehow switched the check from ns_capable() to
> > > has_ns_capability{_noaudit}(). That means it switched from checking the
> > > subjective credentials of the task to using the objective credentials. I
> > > couldn't find the original lkml thread and so I don't know why this switch
> > > was done. But it seems wrong since ptrace_has_cap() is currently only used
> > > in ptrace_may_access(). And it's used to check whether the calling task
> > > (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> > > to operate on the target task (object). According to the cred.h comments
> > > this would mean the subjective credentials of the calling task need to be
> > > used.
> > > This switches it to use security_capable() because we only call
> > > ptrace_has_cap() in ptrace_may_access() and in there we already have a
> > > stable reference to the calling tasks creds under cred_guard_mutex so
> > > there's no need to go through another series of dereferences and rcu
> > > locking done in ns_capable{_noaudit}().
> > 
> > 
> > The criu process is started with all capabilities in the root user namespace.
> > 
> > I don't have time to investigate this issue right now, will provide
> > more details next Tuesday.
> 
> Yeah, we've detected the issue. security_capable() indicates success by
> returning 0 for whatever reason whereas has_ns_capability() returns 1.
> So the logic was inverted. This is fixed in the new version. Sorry for
> the noise!

So, I just finished compiling criu and running the test suite on the
criu-dev branch. The test-suite passes fine after the security_capable()
braino in my original patch was corrected to security_capable() == 0:

################## ALL TEST(S) PASSED (TOTAL 178/SKIPPED 16) ###################

Thanks!
Christian
