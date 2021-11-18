Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA62455642
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbhKRIJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244204AbhKRIJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:09:45 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CD7C061570;
        Thu, 18 Nov 2021 00:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ckHY0iLxkS0nyMqn7Xh63Q+KFrtxcPag+6rnMyk90uQ=; b=bZCofJRV78zAaqfl0VUxL40wKB
        k9+zkUUxSjeOZH8Tadx7Qf2buZvJ8QBMX0fXoGHqBvVj/9pcRR8VEvt0bOAHIhk/VdRnO0bi60oBQ
        yjBBCJoJlM84vfdwwKNLmYQfgMEWWWe5C4SJAfiErKfbefeG2uxrCIfUU56kFUQd2Jb19Z/Njv9JW
        xm13HL3p8yPM2CVFa0vALQIE8bD1Mcv6FopJpvi0RIcHdhd7o7Qi0jMAG1S5paQTOeXcFqBtC7S2R
        vjvngjPDqYcBa1nfbae3Yj3lPnJ+NGbU532Bcc1YobzC4ych8N/EZkOnWEaR3tZAwlZiriTGb9TmA
        O8TgqS9g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mncR9-00GejB-Ji; Thu, 18 Nov 2021 08:06:27 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BBC259863CD; Thu, 18 Nov 2021 09:06:27 +0100 (CET)
Date:   Thu, 18 Nov 2021 09:06:27 +0100
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
Message-ID: <20211118080627.GH174703@worktop.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:

> I really don't think the WCHAN code should use unwinders at all. It's
> too damn fragile, and it's too easily triggered from user space.

On x86, esp. with ORC, it pretty much has to. The thing is, the ORC
unwinder has been very stable so far. I'm guessing there's some really
stupid thing going on, like for example trying to unwind a freed stack.

I *just* managed to reproduce, so let me go have a poke.

> So I think we need to revert all the wchan changes. Not just in
> stable, but in mainline too.

Sure, we can do that. Want a pull request for that or will you just kill
them outright?
