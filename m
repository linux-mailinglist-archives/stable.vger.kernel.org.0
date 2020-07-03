Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82956213C62
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 17:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgGCPN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 11:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgGCPN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 11:13:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53A6C08C5DF
        for <stable@vger.kernel.org>; Fri,  3 Jul 2020 08:13:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so14133644pjc.4
        for <stable@vger.kernel.org>; Fri, 03 Jul 2020 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f9QVB5RC/+nRHe4+ZctWFco2K4WItpSZAlqb2p+cews=;
        b=Icz9sgNvxcWFuhBYB0YeBdhBi2CejbD8M+/dpJjsCSxzglKvoyeolYtXX6QUKWs23q
         kIzWD0TIv+eChFkgz3ZVB3evXDiVJfoJRMgwEvI53XNGkTJOW0FGlZuPKyjsTDchykVZ
         pQ+cWY05WljFot57kPZ9rjhamkIMTkaeqr2WY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f9QVB5RC/+nRHe4+ZctWFco2K4WItpSZAlqb2p+cews=;
        b=C/R5+dL69rR6fHa5D6sxbE1/Igs2k6IWe48SUrAgiZuYUkL9aZmMOvV1LUF9wh/bag
         xVnRdKYnOBggeIzElgQOXh9tUBXbgaW+Wr99P7R3KW50vpMS96zdDLLB1LfbVwm83P/J
         ZT1R40nNEDHyyfAb83nFoHwKyvH+Dg79PsMpSM7eSkGQVu++8IYj2ctOp5JEtqct/rhG
         zQiLoPhJdow8jC/C8YgtZK5Qn5rKXW9flP1HTCanWgwvX9dUa5ZiBRrpXL7N7tQs2T5P
         ZU2MfWHmQhJz/ngQPiNl7knLpF2aL8LIHq0FbdYBOym6hXbCW4p5i2Lfw+TCno4ftF3g
         YX/w==
X-Gm-Message-State: AOAM5308qb65/96jtmiTQF0zYxDDWr+0oMqK5LhHADhRAIJlJvgzEV+B
        kXUmpkyTshdY9TEJ1GmSSfuZcQ==
X-Google-Smtp-Source: ABdhPJy1mHH6GBElAbdYB6aP9+yvHXEZTRhHh+TpVvCFVz/U4Q5Tvvqgs9q7O2KtkqlNf3AFhPyPzQ==
X-Received: by 2002:a17:90b:213:: with SMTP id fy19mr37426487pjb.41.1593789207248;
        Fri, 03 Jul 2020 08:13:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v15sm11875900pgo.15.2020.07.03.08.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 08:13:25 -0700 (PDT)
Date:   Fri, 3 Jul 2020 08:13:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to
 non-CAP_SYSLOG
Message-ID: <202007021815.97C76C192@keescook>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-5-keescook@chromium.org>
 <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 06:00:17PM -0700, Linus Torvalds wrote:
> On Thu, Jul 2, 2020 at 4:26 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > The kprobe show() functions were using "current"'s creds instead
> > of the file opener's creds for kallsyms visibility. Fix to use
> > seq_file->file->f_cred.
> 
> Side note: I have a distinct - but despite that possibly quite
> incorrect - memory that I've discussed with somebody several years ago
> about making "current_cred()" simply warn in any IO context.
> 
> IOW, we could have read and write just increment/decrement a
> per-thread counter, and have current_cred() do a WARN_ON_ONCE() if
> it's called with that counter incremented.

That does sound familiar. I can't find a thread on it, but my search
abilities are poor. :) So an increment/decrement in all the IO-related
syscalls, or were you thinking of some other location?

> The issue of ioctl's is a bit less obvious - there are reasons to
> argue those should also use open-time credentials, but on the other
> hand I think it's reasonable to pass a file descriptor to a suid app
> in order for that app to do things that the normal user cannot.
>
> But read/write are dangerous because of the "it's so easy to fool suid
> apps to read/write stdin/stdout".
>
> So pread/pwrite/ioctl/splice etc are things that suid applications
> very much do on purpose to affect a file descriptor. But plain
> read/write are things that might be accidental and used by attack
> vectors.

So probably just start with read/write and tighten it over time, if we
find other clear places, leaving ioctl/pread/pwrite/splice alone.

> If somebody is interested in looking into things like that, it might
> be a good idea to have kernel threads with that counter incremented by
> 
> Just throwing this idea out in case somebody wants to try it. It's not
> just "current_cred", of course. It's all the current_cred_xxx() users
> too. But it may be that there are a ton of false positives because
> maybe some code on purpose ends up doing things like just *comparing*
> current_cred with file->f_cred and then that would warn too.

Yeah ... and I think the kthread test should answer that question.

-- 
Kees Cook
