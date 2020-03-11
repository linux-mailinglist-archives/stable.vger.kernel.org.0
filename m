Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919AC1810BE
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCKGbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 02:31:34 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38405 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKGbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 02:31:34 -0400
Received: by mail-pj1-f67.google.com with SMTP id a16so486046pju.3;
        Tue, 10 Mar 2020 23:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1UAkvLpj5HFn3T7HvjbOrhBTr3mGSentKtT4t87H9Mc=;
        b=BJQH1jBOoIQ0Fawd2AquivgSRwofkRnhsCHypkNX37kMkOevu/NQ3E3Lvv7iUlN3iG
         s6tzoAiWBbi21zmedKKfMHFjiZ5LnDKnr5l7Zrnp+1rj+Ambnpg7dnf2xMspBCcKmC/F
         y0TudrJsdlUlRQoQzcU5+YTiAe628KiE5MMXcpfYKM46Rh2X0WKmMHk+dKt7+rfSq2fY
         yoOLLApzpxPAJ8DUcQqsZUZBkLGwAXe1x98dnUKVXB6cxmFzEvvbwibc7aym1dCFQwaQ
         KLAqKNRMVghRK1LFCuHqzAvmdqTqD7vDmPCy2wlkadHUjrAEGBdVife9w6biru6XfBgB
         8kSQ==
X-Gm-Message-State: ANhLgQ2rIVIJtl25hj7fhAseYboaiW3oG7l4rujyJTZvGk3/vaqj6ETh
        RRIbfVzeotErEPdBMT1w6/U=
X-Google-Smtp-Source: ADFU+vu8VpdJ963e5F6gYZICpswD7PiJ1BYsUQay5tv81lLrfja+u47vUVWbA+qERoD4Ynb9vnPAsQ==
X-Received: by 2002:a17:90a:5218:: with SMTP id v24mr1786004pjh.90.1583908292874;
        Tue, 10 Mar 2020 23:31:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y18sm48419972pfe.19.2020.03.10.23.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 23:31:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 94A704028E; Wed, 11 Mar 2020 06:31:30 +0000 (UTC)
Date:   Wed, 11 Mar 2020 06:31:30 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     NeilBrown <neilb@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311063130.GL11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
 <20200311052620.GD46757@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311052620.GD46757@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 10:26:20PM -0700, Eric Biggers wrote:
> On Wed, Mar 11, 2020 at 04:32:21AM +0000, Luis Chamberlain wrote:
> > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > It's long been possible to disable kernel module autoloading completely
> > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > > preferable
> > 
> > preferable but ... not documented. Or was this documented or recommended
> > somewhere?
> > 
> > > to setting it to a nonexistent file since it avoids the
> > > overhead of an attempted execve(), avoids potential deadlocks, and
> > > avoids the call to security_kernel_module_request() and thus on
> > > SELinux-based systems eliminates the need to write SELinux rules to
> > > dontaudit module_request.
> 
> Not that I know of, though I didn't look too hard.  proc(5) mentions
> /proc/sys/kernel/modprobe but doesn't mention the empty string case.
> 
> In any case, it's been supported for a long time, and it's useful for the
> reasons I mentioned.

Sure. I think then its important to document it as such then, or perhaps
make a kconfig option which sets this to empty and document it on the
kconfig entry.

> > > However, when module autoloading is disabled in this way,
> > > request_module() returns 0.  This is broken because callers expect 0 to
> > > mean that the module was successfully loaded.
> > 
> > However this is implicitly not true. For instance, as Neil recently
> > chased down -- blacklisting a module today returns 0 as well, and so
> > this corner case is implicitly set to return 0.
> 
> That sounds like another similar bug, but in the modprobe program instead of in
> the kernel.  Do you have a link to the discussion about it?

Nothing public yet AFAICT.

> > > But
> > > improperly returning 0 can indeed confuse a few callers, for example
> > > get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:
> > > 
> > > 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
> > > 		fs = __get_fs_type(name, len);
> > > 		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
> > > 	}
> > > 
> > > This is easily reproduced with:
> > > 
> > > 	echo > /proc/sys/kernel/modprobe
> > > 	mount -t NONEXISTENT none /
> > > 
> > > It causes:
> > > 
> > > 	request_module fs-NONEXISTENT succeeded, but still no fs?
> > > 	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
> > > 	[...]
> > 
> > Thanks for reporting this.
> > 
> > > Arguably this warning is broken and should be removed, since the module
> > > could have been unloaded already.
> > 
> > No, the warning is present *because* debuggins issues for when the
> > module which did not load is a rootfs is *really* hard to debug. Then,
> > if the culprit of the issue is a userspace modprobe bug (it happens)
> > this makes debugging *very* difficult as you won't know what failed at
> > all, you just get a silent failed boot.
> 
> I meant that it's broken to use WARN_ON(), because it's a userspace triggerable
> condition.

This and the blacklist case are now two known cases, so yes I'a agree
now. It was not widely known before.

> WARN_ON() is for kernel bugs only.  Of course, if it's a useful
> warning, it can still be left in as pr_warn().

I'll send a patch.

> > > However, request_module() should also
> > > correctly return an error when it fails.  So let's make it return
> > > -ENOENT, which matches the error when the modprobe binary doesn't exist.
> > 
> > This is a user experience change though, and I wouldn't have on my radar
> > who would use this, and expects the old behaviour. Josh, would you by
> > chance?
> > 
> > I'd like this to be more an RFC first so we get vetted parties to
> > review. I take it this and Neil's case are cases we should revisit now,
> > properly document as we didn't before, ensure we don't break anything,
> > and also extend the respective kmod selftests to ensure we don't break
> > these corner cases in the future.
> 
> This patch only affects kernel internals, not the userspace API.

Ah yes, in that case this seems fine with me.

> So I don't see
> why it would be controversial?  I already went through all callers of
> request_module() that check its return value, and they all appear to work better
> with -ENOENT, since they assume that 0 means the module was loaded.

Thanks for doing that, but I note that getting 0 is not assurance
either. The de-facto best practive for the request_module() call is to
do your own in place verifier.

> Incorrectly returning 0 typically causes unnecessary work (checking again
> whether the module's functionality is available) or misleading log messages.

Yes but returning 0 cannot be relied upon today for assuming the module
is loaded. *If* we revisit that decision and want the kernel to do a
generic verifier, then yes, we can get rid of all the caller specific
verfifiers, but not today.

> In
> fact, I can't think of a situation where kernel code would *want* 0 returned in
> this case, as it's ambiguous with the module being successfully loaded.

Unfortunately that's just how the API (to my mind silly) grew out to.

> Sure, I'll check whether it would be possible to add a test for this case in
> lib/test_kmod.c and tools/testing/selftests/kmod/.

Thanks!

  Luis
