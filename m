Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285A720B83C
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgFZS1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 14:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZS1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 14:27:50 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2FEC03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 11:27:50 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so5658056lfd.10
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aW6KHpbtTRJJscuFSXZMdCFqV8eNv1XYkHhDBiBGbfE=;
        b=tjES2mfxkQ1y0nbq1Vs43yjDZVPu8njkTXVRAnhkeWzbkoYPRId9PQ5Nes/wNXpPiT
         otd8lynMQ+Lq1GrqRJbRTJ7Q2cqcRf/+KvfzGZ6ZTzKN6RPy57/PPBSvsmyZL8rJRxXu
         GYPe2kIPNF7ofdGf93Y9nSqBpCP1+Ksr3bVrK1pG/cG5+W+0BCJtbXy0Lo99DkX/UPqG
         999J/GVTtf11HyjaMC+sDlwB4kivQFaOqetpMtPwj+l+Y3rKIKnE4WDruaX6yW7If2Jf
         hzdQFXLjIFBHayHuMDllrqsQdYlFUMpU0MlK7x1q7FKzswVUv0fqrGA9WN6F3d9E3v1V
         EYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aW6KHpbtTRJJscuFSXZMdCFqV8eNv1XYkHhDBiBGbfE=;
        b=i3abE1srGVCI4Q3Xv+S+ZrpwpH0+Smk3t9o0BdEbs1zdzKiYY0ifi9UY2ZCRs7GBT8
         XAt8pCkMDMo8j4tn+o3m3xMBmDClnIPKnk4EJ5hBiVqYrhQf0E3sIKpqQa/4/wAhbyq4
         D3omvN5PDa7w/2GMa1k/2QVuFubCV0AzAwrvnKFwQdS+gS2ZoepNbAqP+QMBz7zEA6jO
         SnNOOC6PV93FT2lWwoWW/fk2h17s+aee4aLlcshbiBG0r+kNvE4VvIILKTFdTDyGDXbC
         ABahcl5SHVE+6nWcuf32wRCpThxTCnS8DLyCLUUXWtES+9NBGFzBlfz7VMFG7xiO0Nrk
         apYg==
X-Gm-Message-State: AOAM530MmGZs7m0wb6Axwhnf/I9omOXnMsZwmYWePNk1eoVswP8lE5gi
        5CMh3+XtvXVtLLiXdNfIY5KCWvLknZ0pn2PunIzGfS/r
X-Google-Smtp-Source: ABdhPJz+LIlK17Mz0UHfymuwSXh5M0ZiiXytdF0cyCwXgOe19o+BAJxPFbx/FwgooFmtoX3Sd+rLCOuZRIc1Tq+b+k4=
X-Received: by 2002:a19:8b8a:: with SMTP id n132mr2528578lfd.45.1593196068639;
 Fri, 26 Jun 2020 11:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200626113558.GA32542@unset.einval.com> <20200626134132.GB4024297@kroah.com>
 <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
 <20200626165000.GB2950@unset.einval.com> <20200626175201.GA9110@unset.einval.com>
In-Reply-To: <20200626175201.GA9110@unset.einval.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 26 Jun 2020 20:27:22 +0200
Message-ID: <CAG48ez2HcNJi87H8NrGNVsdmQ5qRXGYEOdm9eb-rDHZ0JXa+jQ@mail.gmail.com>
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+ onwards
To:     Steve McIntyre <steve@einval.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, 963493@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 7:52 PM Steve McIntyre <steve@einval.com> wrote:
> On Fri, Jun 26, 2020 at 05:50:00PM +0100, Steve McIntyre wrote:
> >On Fri, Jun 26, 2020 at 04:25:59PM +0200, Jann Horn wrote:
> >>On Fri, Jun 26, 2020 at 3:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >>> On Fri, Jun 26, 2020 at 12:35:58PM +0100, Steve McIntyre wrote:
> >
> >...
> >
> >>> > Considering I'm running strace build tests to provoke this bug,
> >>> > finding the failure in a commit talking about ptrace changes does look
> >>> > very suspicious...!
> >>> >
> >>> > Annoyingly, I can't reproduce this on my disparate other machines
> >>> > here, suggesting it's maybe(?) timing related.
> >>
> >>Does "hard lockup" mean that the HARDLOCKUP_DETECTOR infrastructure
> >>prints a warning to dmesg? If so, can you share that warning?
> >
> >I mean the machine locks hard - X stops updating, the mouse/keyboard
> >stop responding. No pings, etc. When I reboot, there's nothing in the
> >logs.
> >
> >>If you don't have any way to see console output, and you don't have a
> >>working serial console setup or such, you may want to try re-running
> >>those tests while the kernel is booted with netconsole enabled to log
> >>to a different machine over UDP (see
> >>https://www.kernel.org/doc/Documentation/networking/netconsole.txt).
> >
> >ACK, will try that now for you.
> >
> >>You may want to try setting the sysctl kernel.sysrq=1 , then when the
> >>system has locked up, press ALT+PRINT+L (to generate stack traces for
> >>all active CPUs from NMI context), and maybe also ALT+PRINT+T and
> >>ALT+PRINT+W (to collect more information about active tasks).
> >
> >Nod.
> >
> >>(If you share stack traces from these things with us, it would be
> >>helpful if you could run them through scripts/decode_stacktrace.pl
> >>from the kernel tree first, to add line number information.)
> >
> >ACK.
>
> Output passed through scripts/decode_stacktrace.sh attached.
>
> Just about to try John's suggestion next.

Okay, so this is some sort of deadlock...

Looking at the NMI backtraces, all the CPUs are blocked on spinlocks:
CPU 3 is blocked on current->sighand->siglock, in tty_open_proc_set_tty()
CPU 1 is blocked on... I'm not sure which lock, somewhere in do_wait()
CPU 2 is blocked on something, somewhere in ptrace_stop()
CPU 0 is stuck on a lock in do_exit()

So I think it's probably something like a classic deadlock, or a
sleeping-in-atomic issue, or a lock-balancing issue (or memory
corruption, that can cause all kinds of weird errors)?

If it really is a classic deadlock, CONFIG_PROVE_LOCKING=y should be
able to pinpoint the issue.
If it is a sleeping-in-atomic issue, CONFIG_DEBUG_ATOMIC_SLEEP=y should help.
If it is memory corruption, CONFIG_KASAN=y should discover it... but
that might majorly mess up the timing, so if this really is a race,
that might not work.

Maybe flip all of those on, and if it doesn't reproduce anymore, turn
off CONFIG_KASAN and try again?
