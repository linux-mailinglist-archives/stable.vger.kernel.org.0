Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDB4979C5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 08:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiAXHrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 02:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiAXHrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 02:47:47 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CB5C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 23:47:46 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id c15so5596731ljf.11
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 23:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/x4cWx0FlqiYyWIO9v+6frfgtjqdloEnhyL562FSKqY=;
        b=a6L/SHKUojh/M3OqLlblvh0ECUcqTu16A2CE+TO7YFkg/cul41WVSfjDgA7syUi0kf
         z5lAGC/iWbHkI6WLbsMORQcbgnLRFyv2HieE0LXPn+diiK41nKPe/XCpOhIDc8rVXW1M
         8TSyeVXZVgCsn097K0LVbHC/WhUiOg93u4g2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/x4cWx0FlqiYyWIO9v+6frfgtjqdloEnhyL562FSKqY=;
        b=ZsX7WgEka/TuUpxGpkBzAWAVBEuRP+ynGiA7pK0lA44GlWaiLZDKbhuyyUOLyOCco4
         QIbhqbwHE8SE1XdWDpWVJ/LeiH7rC2nwrqiZmKFYq45RtMyxf4gfzl+dxXfRNEHma/UA
         TCR4zbqQkFeU8hW41Xyuy96RcVlTrzeIu5+JJfTsRigbawVa0VwjK7BfntzQQqKIfV+A
         TYF0mQF7Suvibo4f2Hlo6Y+DM8eeoTqk20gOVRPy8XSXVS/bIBMIWRhwBhZeRRQXsTW7
         DLpcMoOusoDpoZ5HYHvv8kaVDfKLb5HFx8dRuoFH5fYZu2bq96LQIa5K6KeWPXbcr140
         GhUA==
X-Gm-Message-State: AOAM53052Uka63gtypgiPE6NX2JOskG7D3DDQKAGXDXijZup3WOLWFOj
        UmRYnZhRP6Db5zNZwa7OmPlZ4/rzZ8MP6xfeuRM=
X-Google-Smtp-Source: ABdhPJxJjbMCEzoPldTp9Qu9OMtX+0ncDQIsQ11WGIszw4WJnD/VV2nRCksGhK9+PojtJ7GpXrDPTA==
X-Received: by 2002:a2e:8e74:: with SMTP id t20mr10926329ljk.293.1643010464767;
        Sun, 23 Jan 2022 23:47:44 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id k11sm1086559lfg.33.2022.01.23.23.47.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 23:47:44 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id q22so2619907ljh.7
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 23:47:44 -0800 (PST)
X-Received: by 2002:adf:9dce:: with SMTP id q14mr11932475wre.193.1643010137698;
 Sun, 23 Jan 2022 23:42:17 -0800 (PST)
MIME-Version: 1.0
References: <20220123193154.14565-1-mathieu.desnoyers@efficios.com>
In-Reply-To: <20220123193154.14565-1-mathieu.desnoyers@efficios.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 24 Jan 2022 09:42:01 +0200
X-Gmail-Original-Message-ID: <CAHk-=whhEB-A-ahgeMsozDfdGNmP_MB9JVnV3bavGbeqgfpStQ@mail.gmail.com>
Message-ID: <CAHk-=whhEB-A-ahgeMsozDfdGNmP_MB9JVnV3bavGbeqgfpStQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rseq: Fix broken uapi field layout on 32-bit little endian
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Watson <davejwatson@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Ben Maurer <bmaurer@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Joel Fernandes <joelaf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 23, 2022 at 9:32 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> The rseq rseq_cs.ptr.{ptr32,padding} uapi endianness handling is
> entirely wrong on 32-bit little endian: a preprocessor logic mistake
> wrongly uses the big endian field layout on 32-bit little endian
> architectures.
>
> Fortunately, those ptr32 accessors were never used within the kernel,
> and only meant as a convenience for user-space.

Please don't double down on something that was already broken once.

Just remove the broken 32-bit one entirely that the kernel doesn't
even use, and make everybody use

   __u64 ptr64;

and be done with it.

Adding a new "arch.ptr32" thing to replace the broken ptr.ptr32 is
just not worth it. This "convenience feature" never worked correctly
on any relevant architecture, so it clearly was never a convenience
feature, and deciding to try to re-do it because it was broken and
pointless the first time around isn't sane.

The definition of insanity is literally to do the same broken thing over again.

So just remove the broken ptr.ptr32 thing, don't add anything new to
replace it. Existing binaries will continue to work (or not work) as
well as they ever did. And new people getting new headers will get a
clear and proper compile error for the broken code that they can
trivially fix using 'ptr64' after they have actually thought about it
for a while.

Giving them a "arch.ptr32" doesn't help them at all. Quite the
reverse. You seem to hve the intention that they should just
mindlessly replace "ptr.ptr32" with "arch.ptr32", and now their code
won't actually work the same. Plus it will build with one version but
not the other.

In contrast, if you just tell people "ptr.ptr32 was always broken, use
ptr64 instead", it will actually work THE SAME with both old and new
headers. No odd "changed behavior from syntactic patch". No odd "this
won't work with older headers so now you have to add some
configuration or #ifdef".

The kernel cares about maintaining the ABI. The *binary* interface. If
the API was broken, it needs to be fixed. Not made worse by keeping
the broken fields and adding new ones for no reason.

               Linus
