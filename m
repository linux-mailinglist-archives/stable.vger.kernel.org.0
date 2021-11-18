Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984AE4556DB
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbhKRIWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbhKRIWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:22:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A002C06120C;
        Thu, 18 Nov 2021 00:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KdhmxrMWnIvVZExztWMRsMmtiCRt7Nw3QRrmvsJdAv4=; b=qtNJVbk+IPRPR4o1b/4Df6Q+VA
        CorBt1kp/POGXuqKN41aDoF1npzaDf+DhUsiaCZ0Ef76tr35afDU5f2eNCNk9Fw1LjXL3DXjXCRn8
        Ym/nuk+vcrCubmdTh+FbCAKv2/fhI8nfE1j53Y0V0oTkl/vwgJENRcxVJlfU1Trg0Q4RALigBrpgv
        y7nnt1wjsusINTEJul6t2AMIJfdqqKtpDAbEAohvTO0nI6AjXPvVyYJ7qPq6Fl7ZjpZqkz1AwCkbw
        cMsDVZbxhcMrUeGI4Kfka6VgRexrfPcnHc6ZIsdU/ReSpYDM8fNzxbPEApcXKkO52gY83z8Io4Nn6
        e96b8kZA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mncdA-008Hyh-Eb; Thu, 18 Nov 2021 08:18:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D0B5B9863CD; Thu, 18 Nov 2021 09:18:52 +0100 (CET)
Date:   Thu, 18 Nov 2021 09:18:52 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <20211118081852.GM174730@worktop.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118080627.GH174703@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:06:27AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> 
> > I really don't think the WCHAN code should use unwinders at all. It's
> > too damn fragile, and it's too easily triggered from user space.
> 
> On x86, esp. with ORC, it pretty much has to. The thing is, the ORC
> unwinder has been very stable so far. I'm guessing there's some really
> stupid thing going on, like for example trying to unwind a freed stack.
> 
> I *just* managed to reproduce, so let me go have a poke.

Confirmed, with the below it no longer reproduces. Now, let me go undo
that and fix the unwinder to not explode while trying to unwind nothing.


---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 862af1db22ab..f810c5192cb9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1978,7 +1978,7 @@ unsigned long get_wchan(struct task_struct *p)
 	raw_spin_lock_irq(&p->pi_lock);
 	state = READ_ONCE(p->__state);
 	smp_rmb(); /* see try_to_wake_up() */
-	if (state != TASK_RUNNING && state != TASK_WAKING && !p->on_rq)
+	if (state != TASK_RUNNING && state != TASK_WAKING && !p->on_rq && !(p->flags & PF_EXITING))
 		ip = __get_wchan(p);
 	raw_spin_unlock_irq(&p->pi_lock);
 
