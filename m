Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B353844EB2A
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 17:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhKLQRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 11:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhKLQRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 11:17:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D17E60FBF;
        Fri, 12 Nov 2021 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636733665;
        bh=RIhgLGlbVI/EfLApHCgYj3d81dxiL3rZzeCX2oxIf/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dvo6f03ZNLw//eKjAx5yBs1egP7X2+gTihASGhw+uL+cytvxlur79wluED84elvF1
         MKMja8fpMwF0k3pIbcYIrOncDbTtkbdisnCXhGG15sLiQ8fMUInTQR+9MUoCOaN0l2
         UWZsZDNGXCJwg95EBBsMUIsRpev2FGM88Wrsu2EY=
Date:   Fri, 12 Nov 2021 17:14:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     stable@vger.kernel.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        joel@joelfernandes.org, kernel-team@android.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 4.4 2/2] binder: use cred instead of task for selinux
 checks
Message-ID: <YY6S3uN478Mk6+Y1@kroah.com>
References: <20211110225910.3268106-1-tkjos@google.com>
 <20211110225910.3268106-2-tkjos@google.com>
 <YY6SOlQicRp1/BZF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY6SOlQicRp1/BZF@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 12, 2021 at 05:11:38PM +0100, Greg KH wrote:
> On Wed, Nov 10, 2021 at 02:59:10PM -0800, Todd Kjos wrote:
> > commit 52f88693378a58094c538662ba652aff0253c4fe upstream.
> > 
> > Since binder was integrated with selinux, it has passed
> > 'struct task_struct' associated with the binder_proc
> > to represent the source and target of transactions.
> > The conversion of task to SID was then done in the hook
> > implementations. It turns out that there are race conditions
> > which can result in an incorrect security context being used.
> > 
> > Fix by using the 'struct cred' saved during binder_open and pass
> > it to the selinux subsystem.
> > 
> > Cc: stable@vger.kernel.org # 5.14 (need backport for earlier stables)
> > Fixes: 79af73079d75 ("Add security hooks to binder and implement the hooks for SELinux.")
> > Suggested-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > Change-Id: Id7157515d2b08f11683aeb8ad9b8f1da075d34e7
> > ---
> >  drivers/android/binder.c  | 18 +++++++++---------
> >  include/linux/lsm_hooks.h | 32 ++++++++++++++++----------------
> >  include/linux/security.h  | 28 ++++++++++++++--------------
> >  security/security.c       | 14 +++++++-------
> >  security/selinux/hooks.c  | 31 +++++++++++++------------------
> >  5 files changed, 59 insertions(+), 64 deletions(-)
> 
> This doesn't apply at all.  I've applied patch 1/2 here, but can you
> redo this one and submit it again?

Ugh, nope, my fault, sorry, this worked just fine.

It's been a long day...

greg k-h
