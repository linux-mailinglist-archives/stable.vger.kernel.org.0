Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641781F5014
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 10:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgFJIMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 04:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFJIMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 04:12:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D5C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 01:12:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x18so1072623ilp.1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 01:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RQkLDm2OyY/FS3M4wUNUpYL3uyFZaGvTTxUYnj5+5u0=;
        b=nI03ANMd7aBQf/IJrmaOWgFbNKk87eTPdr17BZT0Q368D+WxFJkHvpDctCS/hVgbyT
         kVsyxxlLofq2LzBHJQHeL5sgW4BdwA/8TjesGJxuPUVxCVXjgL0xnTX8DntCK/Y5ZijX
         psuGxMlO5RjaN5LuNj5pokTZLwnbyC0KnIpO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RQkLDm2OyY/FS3M4wUNUpYL3uyFZaGvTTxUYnj5+5u0=;
        b=WCFzd5dxmnNYXp74ZjYREuIAoJzHXET6MsoT8qeUBlEvkyXyhVRh74lKCjm26Ev/AJ
         3VXi1+23ujHqjVrEVL2fS+buUgcWYU6kdoUsUWxq63JrfgxBalKevl1YZOZr7hngMdgt
         7JSbWUOPu8WwEQbKnmSeGJPxvZVMeQmG66RRN5mGjt2uSV7tYwquKNul2t9mEREpJnUr
         O8qoJ93SRAInX46Asb/IPnVSTNJFw+5tbVec/qHskgT909zH+8WjyrBsbWKmzYfC8R3i
         aiwraCwLENpKy0G3y9DQDA0PS18AB7Bw9jnLAvtfKFQ8KkLILKFbbEYv1K98bMfw5zm9
         eNQg==
X-Gm-Message-State: AOAM532akfeyTAxFPC5NxlZraNoworg8isIQLfkZuudVlrMJetmbJ6o2
        PlwtYbTrEQEf+C35JIE5yvA3vcKJL31heA==
X-Google-Smtp-Source: ABdhPJxGEPCGwJ8UWjC4fgMF8tdHJLSlj8CP8GaCNRxU8QqPToZFuzNsOKfIXMk7CIP+I0gYPieKXA==
X-Received: by 2002:a92:914a:: with SMTP id t71mr1931962ild.200.1591776761027;
        Wed, 10 Jun 2020 01:12:41 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id q15sm8491624ioh.45.2020.06.10.01.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 01:12:40 -0700 (PDT)
Date:   Wed, 10 Jun 2020 08:12:38 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006092227.D2D0E1F8F@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 10:27:54PM -0700, Kees Cook wrote:
> On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> > On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook@chromium.org> wrote:
> > >LOL. And while we were debating this, hch just went and cleaned stuff up:
> > >
> > >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> > >
> > >So, um, yeah, now my proposal is actually even closer to what we already
> > >have there. We just add the replace_fd() logic to __scm_install_fd() and
> > >we're done with it.
> > 
> > Cool, you have a link? :)
> 
> How about this:
> 
Thank you.
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=devel/seccomp/addfd/v3.1&id=bb94586b9e7cc88e915536c2e9fb991a97b62416
> 
> -- 
> Kees Cook

+		if (ufd) {
+			error = put_user(new_fd, ufd);
+			if (error) {
+				put_unused_fd(new_fd);
+				return error;
+			}
+ 		}
I'm fairly sure this introduces a bug[1] if the user does:

struct msghdr msg = {};
struct cmsghdr *cmsg;
struct iovec io = {
	.iov_base = &c,
	.iov_len = 1,
};

msg.msg_iov = &io;
msg.msg_iovlen = 1;
msg.msg_control = NULL;
msg.msg_controllen = sizeof(buf);

recvmsg(sock, &msg, 0);

They will have the FD installed, no error message, but FD number wont be written 
to memory AFAICT. If two FDs are passed, you will get an efault. They will both
be installed, but memory wont be written to. Maybe instead of 0, make it a
poison pointer, or -1 instead?

-----
As an aside, all of this junk should be dropped:
+	ret = get_user(size, &uaddfd->size);
+	if (ret)
+		return ret;
+
+	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
+	if (ret)
+		return ret;

and the size member of the seccomp_notif_addfd struct. I brought this up 
off-list with Tycho that ioctls have the size of the struct embedded in them. We 
should just use that. The ioctl definition is based on this[2]:
#define _IOC(dir,type,nr,size) \
	(((dir)  << _IOC_DIRSHIFT) | \
	 ((type) << _IOC_TYPESHIFT) | \
	 ((nr)   << _IOC_NRSHIFT) | \
	 ((size) << _IOC_SIZESHIFT))


We should just use copy_from_user for now. In the future, we can either 
introduce new ioctl names for new structs, or extract the size dynamically from 
the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.

----
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
+						struct seccomp_notif_addfd)

Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
reading."


[1]: https://lore.kernel.org/lkml/20200604052040.GA16501@ircssh-2.c.rugged-nimbus-611.internal/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/ioctl.h?id=v5.7#n69
