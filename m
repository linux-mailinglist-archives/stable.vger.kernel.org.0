Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A424227DA
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhJENcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235045AbhJENcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:32:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1BBA61401;
        Tue,  5 Oct 2021 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633440663;
        bh=fGNf6lFeNsKzE8dzg3ltef34M0dC0Pd10/yR6RlZFFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C4p+2jhEnb9QTBRus6fMLknmLkI38NEKt2yByvrsNiCUNH08YlVW5pstXr8CFLe/v
         qMAE/705Qs9RDN0P5G5BxbUt+dYHQF+FsSixW1Da/0AFM0ndmFjVF0+zf/tuMa3OMz
         JcE6MJgWVJma8Orz7xXBkgzJLuzmxs84Ps8xyWuc=
Date:   Tue, 5 Oct 2021 15:31:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jannh@google.com,
        jeffv@google.com, zohar@linux.ibm.com,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] binder: use cred instead of task for selinux checks
Message-ID: <YVxTlBMSWBkLgSi9@kroah.com>
References: <20211001175521.3853257-1-tkjos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001175521.3853257-1-tkjos@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 10:55:21AM -0700, Todd Kjos wrote:
> Save the struct cred associated with a binder process
> at initial open to avoid potential race conditions
> when converting to a security ID.
> 
> Since binder was integrated with selinux, it has passed
> 'struct task_struct' associated with the binder_proc
> to represent the source and target of transactions.
> The conversion of task to SID was then done in the hook
> implementations. It turns out that there are race conditions
> which can result in an incorrect security context being used.
> 
> Fix by saving the 'struct cred' during binder_open and pass
> it to the selinux subsystem.
> 
> Fixes: 79af73079d75 ("Add security hooks to binder and implement the
> hooks for SELinux.")
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Cc: stable@vger.kernel.org # 5.14+ (need backport for earlier stables)
> ---
> v2: updated comments as suggested by Paul Moore
> 
>  drivers/android/binder.c          | 14 +++++----
>  drivers/android/binder_internal.h |  4 +++
>  include/linux/lsm_hook_defs.h     | 14 ++++-----
>  include/linux/lsm_hooks.h         | 14 ++++-----
>  include/linux/security.h          | 28 +++++++++---------
>  security/security.c               | 14 ++++-----
>  security/selinux/hooks.c          | 48 +++++++++----------------------
>  7 files changed, 60 insertions(+), 76 deletions(-)

Ideally I could get an ack from the security developers before taking
this in my tree...

thanks,

greg k-h
