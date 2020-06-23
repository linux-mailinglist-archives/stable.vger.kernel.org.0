Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10B2204931
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 07:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgFWFWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 01:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgFWFWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 01:22:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E8DE20716;
        Tue, 23 Jun 2020 05:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592889749;
        bh=bRSmFiLcHDdUZV1lLofJRbU6hkCpvLtaGBck/D3vn9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kGwhuJ3POJsHPXPg+IwKqyBkudr/5DcI6PTwz3rxY6d36unPPXRADtNrMfTZAr1VP
         XmTJyDNr/dkfyLp2k6fe3mD2SVpLy/b25B/GtWXTJe/oiHlAPMMLkpfiavZs5Gf6zn
         VK2Lk2BRO3X9FWi+uLxTx1hkP30cmh92jHXvvzPc=
Date:   Tue, 23 Jun 2020 07:22:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Brauner <christian@brauner.io>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] binder: fix null deref of proc->context
Message-ID: <20200623052224.GC2252466@kroah.com>
References: <20200622200715.114382-1-tkjos@google.com>
 <20200622200955.unq7elx2ry2vrnfe@wittgenstein>
 <CAHRSSExVfUhkXzhuEUvUP-CTwSE7ExWwYCL8K_N+YABW9C1BzQ@mail.gmail.com>
 <CAHRSSEzms6-4zvTXDG6PTcgHx1vev343DRWXxV2kZDqpop1=GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSEzms6-4zvTXDG6PTcgHx1vev343DRWXxV2kZDqpop1=GQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 01:59:04PM -0700, Todd Kjos wrote:
> On Mon, Jun 22, 2020 at 1:18 PM Todd Kjos <tkjos@google.com> wrote:
> >
> > On Mon, Jun 22, 2020 at 1:09 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > On Mon, Jun 22, 2020 at 01:07:15PM -0700, Todd Kjos wrote:
> > > > The binder driver makes the assumption proc->context pointer is invariant after
> > > > initialization (as documented in the kerneldoc header for struct proc).
> > > > However, in commit f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
> > > > proc->context is set to NULL during binder_deferred_release().
> > > >
> > > > Another proc was in the middle of setting up a transaction to the dying
> > > > process and crashed on a NULL pointer deref on "context" which is a local
> > > > set to &proc->context:
> > > >
> > > >     new_ref->data.desc = (node == context->binder_context_mgr_node) ? 0 : 1;
> > > >
> > > > Here's the stack:
> > > >
> > > > [ 5237.855435] Call trace:
> > > > [ 5237.855441] binder_get_ref_for_node_olocked+0x100/0x2ec
> > > > [ 5237.855446] binder_inc_ref_for_node+0x140/0x280
> > > > [ 5237.855451] binder_translate_binder+0x1d0/0x388
> > > > [ 5237.855456] binder_transaction+0x2228/0x3730
> > > > [ 5237.855461] binder_thread_write+0x640/0x25bc
> > > > [ 5237.855466] binder_ioctl_write_read+0xb0/0x464
> > > > [ 5237.855471] binder_ioctl+0x30c/0x96c
> > > > [ 5237.855477] do_vfs_ioctl+0x3e0/0x700
> > > > [ 5237.855482] __arm64_sys_ioctl+0x78/0xa4
> > > > [ 5237.855488] el0_svc_common+0xb4/0x194
> > > > [ 5237.855493] el0_svc_handler+0x74/0x98
> > > > [ 5237.855497] el0_svc+0x8/0xc
> > > >
> > > > The fix is to move the kfree of the binder_device to binder_free_proc()
> > > > so the binder_device is freed when we know there are no references
> > > > remaining on the binder_proc.
> > > >
> > > > Fixes: f0fe2c0f050d ("binder: prevent UAF for binderfs devices II")
> > > > Signed-off-by: Todd Kjos <tkjos@google.com>
> >
> > Forgot to include stable. The issue was introduced in 5.6, so fix needed in 5.7.
> > Cc: stable@vger.kernel.org # 5.7
> 
> Turns out the patch with the issue was also backported to 5.4.y, so
> the fix is needed there too.

With the fixes tag in there and cc: stable, it will get to the proper
trees no matter how far back it was backported :)

thanks,

greg k-h
