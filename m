Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8FC45AAFC
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhKWSPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 13:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhKWSPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 13:15:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2335560F9D;
        Tue, 23 Nov 2021 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637691155;
        bh=ljCu8zLyZq17cxGz/q2cy057a6PRyyROwH6wrp0QAEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbZiZzV2xrffQPzWMDzFd6JpbOOP1ZpCRfm0gY0t0jnQTEkoQNv6U1pJc7hZWCmcT
         k13mZUW9DetFToequZCfwOKCEmX0UqJv4BYCWiFud5TPRLG1zv7KKBwwhETq0YgelK
         XI18cNXx7Ws+09zDlFSZAHTvSRSWTTOl5Q0vWqFw=
Date:   Tue, 23 Nov 2021 19:12:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@iki.fi>
Cc:     ebiederm@xmission.com, keescook@chromium.org, khuey@kylehuey.com,
        me@kylehuey.com, oliver.sang@intel.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
Message-ID: <YZ0vAK6QJJFP3jY5@kroah.com>
References: <163758427225348@kroah.com>
 <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 07:29:43PM +0200, Thomas Backlund wrote:
> Den 2021-11-22 kl. 14:31, skrev gregkh@linuxfoundation.org:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> It will apply if you add this one first:
> 
> From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:43:59 -0500
> Subject: [PATCH] signal: Implement force_fatal_sig
> 
> 
> 
> 
> and if the other patch for signal that has similar description should land
> in 5.15:
> 
> From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Thu, 18 Nov 2021 14:23:21 -0600
> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
> doubt
> 
> 
> 
> then the list is looks something like:
> 
> 
> From 941edc5bf174b67f94db19817cbeab0a93e0c32a Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:44:00 -0500
> Subject: [PATCH] exit/syscall_user_dispatch: Send ordinary signals on
> failure
> 
> From 83a1f27ad773b1d8f0460d3a676114c7651918cc Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:43:53 -0500
> Subject: [PATCH] signal/powerpc: On swapcontext failure force SIGSEGV
> 
> From 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:43:57 -0500
> Subject: [PATCH] signal/s390: Use force_sigsegv in default_trap_handler
> 
> From c317d306d55079525c9610267fdaf3a8a6d2f08b Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:44:01 -0500
> Subject: [PATCH] signal/sparc32: Exit with a fatal signal when
>  try_to_clear_window_buffer fails
> 
> From 086ec444f86660e103de8945d0dcae9b67132ac9 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:44:02 -0500
> Subject: [PATCH] signal/sparc32: In setup_rt_frame and setup_fram use
>  force_fatal_sig
> 
> From 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:43:56 -0500
> Subject: [PATCH] signal/vm86_32: Properly send SIGSEGV when the vm86 state
> cannot be saved.
> 
> From 695dd0d634df8903e5ead8aa08d326f63b23368a Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:44:03 -0500
> Subject: [PATCH] signal/x86: In emulate_vsyscall force a signal instead of
> calling do_exit
> 
> From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 20 Oct 2021 12:43:59 -0500
> Subject: [PATCH] signal: Implement force_fatal_sig
> 
> From e21294a7aaae32c5d7154b187113a04db5852e37 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Mon, 25 Oct 2021 10:50:57 -0500
> Subject: [PATCH] signal: Replace force_sigsegv(SIGSEGV) with
>  force_fatal_sig(SIGSEGV)
> 
> From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Thu, 18 Nov 2021 11:11:13 -0600
> Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals
> 
> From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Thu, 18 Nov 2021 14:23:21 -0600
> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
> doubt
> 
> 
> 
> Applying them in listed order on top of 5.14.4 and builds/runs on i586,
> x86_64, armv7hl, aarch64

That series list is crazy, let me go try it and see what blows up! :)

thanks,

greg k-h
