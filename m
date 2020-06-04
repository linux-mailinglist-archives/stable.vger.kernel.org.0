Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393601EDBC6
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 05:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFDDjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 23:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgFDDjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 23:39:12 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE9FC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 20:39:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r2so4705921ila.4
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 20:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JL8KAHI97qtguZ9Tb2fscmILbngbHV5HZl94fH1QWiU=;
        b=BkAIZS5UfiiyWUPoA8i0jqjgQC/WADaVCEyErmWLwK8t3GHDHFMmZ0cWMKoqVrqQqf
         GO+t+UGX7bnWxdI5DqxuR9Q92NU7fHo24UZMJGMnMMJRKYKo4x/F7pwAsbhyN7Gn60ju
         n7q3PRtkSlmouoqf/iL9VnER2wtgOLpNaqOco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JL8KAHI97qtguZ9Tb2fscmILbngbHV5HZl94fH1QWiU=;
        b=i6V9Ov4+Z+VE82781qETh9bc7eGCprdG9RLAA81vZp3cWXcEvl6Zg8jzKhat6aHzpy
         4Em/Ybd3KzahgiZatKqYlhgvDaDzRUjkFtjvWjGXiBqDIsucyh4uRbOPIR4gNfBNwCY3
         0FvszhruzIqog/j0u8WeYku3yflxOjaNBHL2/y2nBAoXHkek6yQ5FD08MKlezKywm1lC
         NnB+XaSYAiXo5tSneeB3zqT8RbcaMfdLn5V4KGJR119iCsicrEBok85W06zQ3lUsQhcj
         R22pw1zMUgKS3RpXmaxG6mwld891XLiurbCjOnMtFsWqUBng63Ofr7xN3zd5207i6fdj
         2H2g==
X-Gm-Message-State: AOAM532Hq2l3iVuXOZ9CYi3IYNDEhn9y4Ep+UXzXwv0PgP/IL3X7lJqh
        FW0sNKAsX+RrqJkZuKvZGXhsWg==
X-Google-Smtp-Source: ABdhPJzpJ/gMzj+cF7tx0wsNnght7qYo/ErxsBP4IEom49PMUnSj0R69oQgNuqTUaWsGxM0Rfd7pDA==
X-Received: by 2002:a92:c812:: with SMTP id v18mr2474993iln.178.1591241949645;
        Wed, 03 Jun 2020 20:39:09 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id v20sm828328ilc.1.2020.06.03.20.39.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jun 2020 20:39:09 -0700 (PDT)
Date:   Thu, 4 Jun 2020 03:39:07 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200604033907.GA16025@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604012452.vh33nufblowuxfed@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 03:24:52AM +0200, Christian Brauner wrote:
> On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> > Previously there were two chunks of code where the logic to receive file
> > descriptors was duplicated in net. The compat version of copying
> > file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> > Logic to change the cgroup data was added in:
> > commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > 
> > This was not copied to the compat path. This commit fixes that, and thus
> > should be cherry-picked into stable.
> > 
> > This introduces a helper (file_receive) which encapsulates the logic for
> > handling calling security hooks as well as manipulating cgroup information.
> > This helper can then be used other places in the kernel where file
> > descriptors are copied between processes
> > 
> > I tested cgroup classid setting on both the compat (x32) path, and the
> > native path to ensure that when moving the file descriptor the classid
> > is set.
> > 
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Jann Horn <jannh@google.com>,
> > Cc: John Fastabend <john.r.fastabend@intel.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Tycho Andersen <tycho@tycho.ws>
> > Cc: stable@vger.kernel.org
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
> >  include/linux/file.h |  1 +
> >  net/compat.c         | 10 +++++-----
> >  net/core/scm.c       | 14 ++++----------
> >  4 files changed, 45 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index abb8b7081d7a..5afd76fca8c2 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -18,6 +18,9 @@
> >  #include <linux/bitops.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/rcupdate.h>
> > +#include <net/sock.h>
> > +#include <net/netprio_cgroup.h>
> > +#include <net/cls_cgroup.h>
> >  
> >  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
> >  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> > @@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
> >  	return err;
> >  }
> >  
> > +/*
> > + * File Receive - Receive a file from another process
> > + *
> > + * This function is designed to receive files from other tasks. It encapsulates
> > + * logic around security and cgroups. The file descriptor provided must be a
> > + * freshly allocated (unused) file descriptor.
> > + *
> > + * This helper does not consume a reference to the file, so the caller must put
> > + * their reference.
> > + *
> > + * Returns 0 upon success.
> > + */
> > +int file_receive(int fd, struct file *file)
> 
> This is all just a remote version of fd_install(), yet it deviates from
> fd_install()'s semantics and naming. That's not great imho. What about
> naming this something like:
> 
> fd_install_received()
> 
> and move the get_file() out of there so it has the same semantics as
> fd_install(). It seems rather dangerous to have a function like
> fd_install() that consumes a reference once it returned and another
> version of this that is basically the same thing but doesn't consume a
> reference because it takes its own. Seems an invitation for confusion.
> Does that make sense?
> 
You're right. The reason for the difference in my mind is that fd_install
always succeeds, whereas file_receive can fail. It's easier to do something
like:
fd_install(fd, get_file(f))
vs.
if (file_receive(fd, get_file(f))
	fput(f);

Alternatively, if the reference was always consumed, it is somewhat
easier.

I'm fine either way, but just explaining my reasoning for the difference
in behaviour.
