Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6496E422A0E
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhJEOHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235482AbhJEOHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 10:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1273A611C0;
        Tue,  5 Oct 2021 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633442719;
        bh=4dCsX/rNf/kYedDGRShwnxsvQ8FZ+zSZBJSVcIJ/3O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F6TnW11mlYLD0BcyGkp1owBjC5xVwmDX30sE4HvZ+c+VgyTgMpuU7PXktN2cx9B0j
         GqdeTc4CKlj+e0A0XGMBs75l+qyO1ybDMK7Tmjf0GS4AIlaoo9DneE7zg6bR1PvyTe
         jXR1A/tPJA8SByxxjPe4MCLq5IL5JtSR11uyilSs=
Date:   Tue, 5 Oct 2021 16:05:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Todd Kjos <tkjos@google.com>, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
Message-ID: <YVxbnQsquSrG6sxF@kroah.com>
References: <20211001175521.3853257-1-tkjos@google.com>
 <YVxTlBMSWBkLgSi9@kroah.com>
 <CAHC9VhTdyc6qagfFDLFteqTpayC4G=tNy1T7mueMKeZzU8QmwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTdyc6qagfFDLFteqTpayC4G=tNy1T7mueMKeZzU8QmwQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 09:53:31AM -0400, Paul Moore wrote:
> On Tue, Oct 5, 2021 at 9:31 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Oct 01, 2021 at 10:55:21AM -0700, Todd Kjos wrote:
> > > Save the struct cred associated with a binder process
> > > at initial open to avoid potential race conditions
> > > when converting to a security ID.
> > >
> > > Since binder was integrated with selinux, it has passed
> > > 'struct task_struct' associated with the binder_proc
> > > to represent the source and target of transactions.
> > > The conversion of task to SID was then done in the hook
> > > implementations. It turns out that there are race conditions
> > > which can result in an incorrect security context being used.
> > >
> > > Fix by saving the 'struct cred' during binder_open and pass
> > > it to the selinux subsystem.
> > >
> > > Fixes: 79af73079d75 ("Add security hooks to binder and implement the
> > > hooks for SELinux.")
> > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > Cc: stable@vger.kernel.org # 5.14+ (need backport for earlier stables)
> > > ---
> > > v2: updated comments as suggested by Paul Moore
> > >
> > >  drivers/android/binder.c          | 14 +++++----
> > >  drivers/android/binder_internal.h |  4 +++
> > >  include/linux/lsm_hook_defs.h     | 14 ++++-----
> > >  include/linux/lsm_hooks.h         | 14 ++++-----
> > >  include/linux/security.h          | 28 +++++++++---------
> > >  security/security.c               | 14 ++++-----
> > >  security/selinux/hooks.c          | 48 +++++++++----------------------
> > >  7 files changed, 60 insertions(+), 76 deletions(-)
> >
> > Ideally I could get an ack from the security developers before taking
> > this in my tree...
> 
> This should probably go in via one of the security trees, e.g. SELinux
> or LSM, rather than the binder/driver tree.

Fine with me, take it away!

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
