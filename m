Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C352B65666
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfGKMMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 08:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbfGKMMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 08:12:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC1220665;
        Thu, 11 Jul 2019 12:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562847127;
        bh=e/K/5AFD7ZJzrczehcbJ6cmCV0hihMHe4GYW1tV1PmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O2zT9mEX1OCHyMkE4Wj//S23gqPeC+O209ffvro8jKhLFqkq21COMNMLo0TJ+y7vS
         tfo04K1nn/iFNAhPzjREayfcnBqPVsjarEtafP7fKdvBIbMyq1ED1HsNnA7STrFCDp
         PGKLAo2G6T6O4tXMNHk9Sc9/pLKkrd1OpmJES6Kw=
Date:   Thu, 11 Jul 2019 08:12:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>,
        Joel Fernandes <joel@joelfernandes.org>, devel@etsukata.com,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 5/7] x86/mm, tracing: Fix CR2 corruption
Message-ID: <20190711121206.GY10104@sasha-vm>
References: <20190704195555.580363209@infradead.org>
 <20190704200050.534802824@infradead.org>
 <CALCETrXvTvFBaQB-kEe4cRTCXUyTbWLbcveWsH-kX4j915c_=w@mail.gmail.com>
 <CALCETrUzP4Wb=WNhGvc7k4oX7QQz1JXZ3-O8PQhs39kmZid0nw@mail.gmail.com>
 <CAHk-=wh+J7ts6OrzzscMj5FONd3TRAwAKPZ=BQmEb2E8_-RXTA@mail.gmail.com>
 <20190710162709.1c306f8a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190710162709.1c306f8a@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 04:27:09PM -0400, Steven Rostedt wrote:
>
>[ added stable folks ]
>
>On Sun, 7 Jul 2019 11:17:09 -0700
>Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Sun, Jul 7, 2019 at 8:11 AM Andy Lutomirski <luto@kernel.org> wrote:
>> >
>> > FWIW, I'm leaning toward suggesting that we apply the trivial tracing
>> > fix and backport *that*.  Then, in -tip, we could revert it and apply
>> > this patch instead.
>>
>> You don't have to have the same fix in stable as in -tip.
>>
>> It's fine to send something to stable that says "Fixed differently by
>> commit XYZ upstream". The main thing is to make sure that stable
>> doesn't have fixes that then get lost upstream (which we used to have
>> long long ago).
>>
>
>But isn't it easier for them to just pull the quick fix in, if it is in
>your tree? That is, it shouldn't be too hard to make the "quick fix"
>that gets backported on your tree (and probably better testing), and
>then add the proper fix on top of it. The stable folks will then just
>use the commit sha to know what to take, and feel more confident about
>taking it.

I'd say that if the "final" fix is significantly different than what
we'll end up with upstream then just do as Linus said and send us a
separate backport.

If we try doing the apply fix/revert etc games it'll just be more
difficult later on to parse what has happened. On the other hand, if we
have a clear explanation in the backported commit as to how it's
different from upstream and the reasons for doing so it'll make future
us happy when we try to apply fixes on top of it.

--
Thanks,
Sasha
