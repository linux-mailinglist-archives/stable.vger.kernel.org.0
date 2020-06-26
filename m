Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E620B642
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgFZQuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 12:50:13 -0400
Received: from cheddar.halon.org.uk ([93.93.131.118]:55168 "EHLO
        cheddar.halon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgFZQuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 12:50:13 -0400
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jorYI-0004HI-3u; Fri, 26 Jun 2020 17:50:10 +0100
Received: from steve by tack.einval.org with local (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jorY8-0002xk-45; Fri, 26 Jun 2020 17:50:00 +0100
Date:   Fri, 26 Jun 2020 17:50:00 +0100
From:   Steve McIntyre <steve@einval.com>
To:     Jann Horn <jannh@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, 963493@bugs.debian.org
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+
 onwards
Message-ID: <20200626165000.GB2950@unset.einval.com>
References: <20200626113558.GA32542@unset.einval.com>
 <20200626134132.GB4024297@kroah.com>
 <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
X-attached: unknown
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jann,

On Fri, Jun 26, 2020 at 04:25:59PM +0200, Jann Horn wrote:
>On Fri, Jun 26, 2020 at 3:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Fri, Jun 26, 2020 at 12:35:58PM +0100, Steve McIntyre wrote:

...

>> > Considering I'm running strace build tests to provoke this bug,
>> > finding the failure in a commit talking about ptrace changes does look
>> > very suspicious...!
>> >
>> > Annoyingly, I can't reproduce this on my disparate other machines
>> > here, suggesting it's maybe(?) timing related.
>
>Does "hard lockup" mean that the HARDLOCKUP_DETECTOR infrastructure
>prints a warning to dmesg? If so, can you share that warning?

I mean the machine locks hard - X stops updating, the mouse/keyboard
stop responding. No pings, etc. When I reboot, there's nothing in the
logs.

>If you don't have any way to see console output, and you don't have a
>working serial console setup or such, you may want to try re-running
>those tests while the kernel is booted with netconsole enabled to log
>to a different machine over UDP (see
>https://www.kernel.org/doc/Documentation/networking/netconsole.txt).

ACK, will try that now for you.

>You may want to try setting the sysctl kernel.sysrq=1 , then when the
>system has locked up, press ALT+PRINT+L (to generate stack traces for
>all active CPUs from NMI context), and maybe also ALT+PRINT+T and
>ALT+PRINT+W (to collect more information about active tasks).

Nod.

>(If you share stack traces from these things with us, it would be
>helpful if you could run them through scripts/decode_stacktrace.pl
>from the kernel tree first, to add line number information.)

ACK.

>Trying to isolate the problem:
>
>__end_current_label_crit_section and end_current_label_crit_section
>are aliases of each other (via #define), so that line change can't
>have done anything.
>
>That leaves two possibilities AFAICS:
> - the might_sleep() call by itself is causing issues for one of the
>remaining users of begin_current_label_crit_section() (because it
>causes preemption to happen more often where it didn't happen on
>PREEMPT_VOLUNTARY before, or because it's trying to print a warning
>message with the runqueue lock held, or something like that)
> - the lack of "if (aa_replace_current_label(label) == 0)
>aa_put_label(label);" in __begin_current_label_crit_section() is
>somehow causing issues
>
>You could try to see whether just adding the might_sleep(), or just
>replacing the begin_current_label_crit_section() call with
>__begin_current_label_crit_section(), triggers the bug.
>
>
>If you could recompile the kernel with CONFIG_DEBUG_ATOMIC_SLEEP - if
>that isn't already set in your kernel config -, that might help track
>down the problem, unless it magically makes the problem stop
>triggering (which I guess would be conceivable if this indeed is a
>race).

OK, will try that second...

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
"I can't ever sleep on planes ... call it irrational if you like, but I'm
 afraid I'll miss my stop" -- Vivek Das Mohapatra

