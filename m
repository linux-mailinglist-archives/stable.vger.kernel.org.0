Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41E181001
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 06:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgCKF0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 01:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgCKF0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 01:26:23 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 725E220873;
        Wed, 11 Mar 2020 05:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583904381;
        bh=TWJjYu/HvVnlNeY2VBees63MsYh/Rigq9wwN47Kg4yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rXPmjs7QHPAofkD4abxKlOB1O+aKdBc3TZZ/lqFOfOzj9mp+cX1Av+2tzTcsurkv3
         7IXCjMs1vb24OLfYT4L1vz+Y0eWmS8wTRdTJbbTWOEqprHUIvjoqqb1w0P/vEF9EPn
         kPdg9f5XugJZ9dh+pRf3vAHGmGB4u8BvpWw1xi5o=
Date:   Tue, 10 Mar 2020 22:26:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     NeilBrown <neilb@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311052620.GD46757@gmail.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311043221.GK11244@42.do-not-panic.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 04:32:21AM +0000, Luis Chamberlain wrote:
> On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > It's long been possible to disable kernel module autoloading completely
> > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > preferable
> 
> preferable but ... not documented. Or was this documented or recommended
> somewhere?
> 
> > to setting it to a nonexistent file since it avoids the
> > overhead of an attempted execve(), avoids potential deadlocks, and
> > avoids the call to security_kernel_module_request() and thus on
> > SELinux-based systems eliminates the need to write SELinux rules to
> > dontaudit module_request.

Not that I know of, though I didn't look too hard.  proc(5) mentions
/proc/sys/kernel/modprobe but doesn't mention the empty string case.

In any case, it's been supported for a long time, and it's useful for the
reasons I mentioned.

> > 
> > However, when module autoloading is disabled in this way,
> > request_module() returns 0.  This is broken because callers expect 0 to
> > mean that the module was successfully loaded.
> 
> However this is implicitly not true. For instance, as Neil recently
> chased down -- blacklisting a module today returns 0 as well, and so
> this corner case is implicitly set to return 0.

That sounds like another similar bug, but in the modprobe program instead of in
the kernel.  Do you have a link to the discussion about it?

> 
> > But
> > improperly returning 0 can indeed confuse a few callers, for example
> > get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:
> > 
> > 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
> > 		fs = __get_fs_type(name, len);
> > 		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
> > 	}
> > 
> > This is easily reproduced with:
> > 
> > 	echo > /proc/sys/kernel/modprobe
> > 	mount -t NONEXISTENT none /
> > 
> > It causes:
> > 
> > 	request_module fs-NONEXISTENT succeeded, but still no fs?
> > 	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
> > 	[...]
> 
> Thanks for reporting this.
> 
> > Arguably this warning is broken and should be removed, since the module
> > could have been unloaded already.
> 
> No, the warning is present *because* debuggins issues for when the
> module which did not load is a rootfs is *really* hard to debug. Then,
> if the culprit of the issue is a userspace modprobe bug (it happens)
> this makes debugging *very* difficult as you won't know what failed at
> all, you just get a silent failed boot.

I meant that it's broken to use WARN_ON(), because it's a userspace triggerable
condition.  WARN_ON() is for kernel bugs only.  Of course, if it's a useful
warning, it can still be left in as pr_warn().

> > However, request_module() should also
> > correctly return an error when it fails.  So let's make it return
> > -ENOENT, which matches the error when the modprobe binary doesn't exist.
> 
> This is a user experience change though, and I wouldn't have on my radar
> who would use this, and expects the old behaviour. Josh, would you by
> chance?
> 
> I'd like this to be more an RFC first so we get vetted parties to
> review. I take it this and Neil's case are cases we should revisit now,
> properly document as we didn't before, ensure we don't break anything,
> and also extend the respective kmod selftests to ensure we don't break
> these corner cases in the future.

This patch only affects kernel internals, not the userspace API.  So I don't see
why it would be controversial?  I already went through all callers of
request_module() that check its return value, and they all appear to work better
with -ENOENT, since they assume that 0 means the module was loaded.

Incorrectly returning 0 typically causes unnecessary work (checking again
whether the module's functionality is available) or misleading log messages.  In
fact, I can't think of a situation where kernel code would *want* 0 returned in
this case, as it's ambiguous with the module being successfully loaded.

Sure, I'll check whether it would be possible to add a test for this case in
lib/test_kmod.c and tools/testing/selftests/kmod/.

- Eric
