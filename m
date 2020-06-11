Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE1B1F663D
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgFKLGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgFKLGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 07:06:35 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4BAC08C5C4
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:06:35 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y5so5790881iob.12
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 04:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2R+wiFfzvQNb0IhDifqVeL6cc3fjUJMhYBce6rC6DCk=;
        b=Z+sW2TmSn6OM09sIzUe+GQMvwrm3rd/qAFbZjYr2L+algtLl9Jmw9KCJ03Kqh3WBmH
         TUdyrRddl5XGBkntRXl1Rqrp3Xl8aYytjB4MgxAI8tcXsASWj5iaReXFPsMcxI6pG+l3
         Q+69LhfrlGgdVOJf0uh2V+rCbQOn19wm6MmiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2R+wiFfzvQNb0IhDifqVeL6cc3fjUJMhYBce6rC6DCk=;
        b=UoYSwYUWsFgqdKpJTEkpU8+yFPpzH07dCZuV/X/WgqEv2uce5qbk5ZA8an4tm15SAS
         yPpNMV2NSO4eLw0jE0VBd0jv50PGC/K+CfA1vQIv3xlos24yMshcTjqozZkJHbre6bmH
         fsah0t5Ki++B+QWA508jpvtDuzgyzgReCKMDQPUgY56dXviQQHfR39J9dOJzFIFmBnVu
         Fg00bPO7mu2D7ArDUY+rwBAKsPGmuzEkSHbxbBz18mWykyVCU0b90UPDDTkFgzLsfCjZ
         z9LdD2Q5KaI/Vmp9Hb17RXbxyFC03yKijoHRDW8OdZ2BzJl8VF+I9kIlorJltXADPC70
         7q/g==
X-Gm-Message-State: AOAM533KVY+ITl+IdeAtgzfTLSdcaeMBYmARocvFyIW7jxZjbB1AThgC
        l55Fch3B6qn3RjT3WpZFrlmVLg==
X-Google-Smtp-Source: ABdhPJxAe2FFIVPIGtUH7XUlqRwmMIqQvWfQmGlMX7FGj+oJX7+J03taHo0cG57juW6PAL7xtwxx0g==
X-Received: by 2002:a6b:1487:: with SMTP id 129mr7966323iou.197.1591873594035;
        Thu, 11 Jun 2020 04:06:34 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id p10sm1369817ilm.32.2020.06.11.04.06.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jun 2020 04:06:33 -0700 (PDT)
Date:   Thu, 11 Jun 2020 11:06:31 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 12:01:14PM +0200, Christian Brauner wrote:
> On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > As an aside, all of this junk should be dropped:
> > > +	ret = get_user(size, &uaddfd->size);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > +	if (ret)
> > > +		return ret;
> > > 
> > > and the size member of the seccomp_notif_addfd struct. I brought this up 
> > > off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> > > should just use that. The ioctl definition is based on this[2]:
> > > #define _IOC(dir,type,nr,size) \
> > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > 	 ((size) << _IOC_SIZESHIFT))
> > > 
> > > 
> > > We should just use copy_from_user for now. In the future, we can either 
> > > introduce new ioctl names for new structs, or extract the size dynamically from 
> > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > 
> > Yeah, that seems reasonable. Here's the diff for that part:
> 
> Why does it matter that the ioctl() has the size of the struct embedded
> within? Afaik, the kernel itself doesn't do anything with that size. It
> merely checks that the size is not pathological and it does so at
> compile time.
> 
> #ifdef __CHECKER__
> #define _IOC_TYPECHECK(t) (sizeof(t))
> #else
> /* provoke compile error for invalid uses of size argument */
> extern unsigned int __invalid_size_argument_for_IOC;
> #define _IOC_TYPECHECK(t) \
> 	((sizeof(t) == sizeof(t[1]) && \
> 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> 	  sizeof(t) : __invalid_size_argument_for_IOC)
> #endif
> 
> The size itself is not verified at runtime. copy_struct_from_user()
> still makes sense at least if we're going to allow expanding the struct
> in the future.
Right, but if we simply change our headers and extend the struct, it will break 
all existing programs compiled against those headers. In order to avoid that, if 
we intend on extending this struct by appending to it, we need to have a 
backwards compatibility mechanism. Just having copy_struct_from_user isn't 
enough. The data structure either must be fixed size, or we need a way to handle 
multiple ioctl numbers derived from headers with different sized struct arguments

The two approaches I see are:
1. use more indirection. This has previous art in drm[1]. That's look
something like this:

struct seccomp_notif_addfd_ptr {
	__u64 size;
	__u64 addr;
}

... And then it'd be up to us to dereference the addr and copy struct from user.

2. Expose one ioctl to the user, many internally

e.g., public api:

struct seccomp_notif {
	__u64 id;
	__u64 pid;
	struct seccomp_data;
	__u64 fancy_new_field;
}

#define SECCOMP_IOCTL_NOTIF_RECV	SECCOMP_IOWR(0, struct seccomp_notif)

internally:
struct seccomp_notif_v1 {
	__u64 id;
	__u64 pid;
	struct seccomp_data;
}

struct seccomp_notif_v2 {
	__u64 id;
	__u64 pid;
	struct seccomp_data;
	__u64 fancy_new_field;
}

and we can switch like this:
	switch (cmd) {
	/* for example. We actually have to do this for any struct we intend to 
	 * extend to get proper backwards compatibility
	 */
	case SECCOMP_IOWR(0, struct seccomp_notif_v1)
		return seccomp_notify_recv(filter, buf, sizeof(struct seccomp_notif_v1));
	case SECCOMP_IOWR(0, struct seccomp_notif_v2)
		return seccomp_notify_recv(filter, buf, sizeof(struct seccomp_notif_v3));
...
	case SECCOMP_IOCTL_NOTIF_SEND:
		return seccomp_notify_send(filter, buf);
	case SECCOMP_IOCTL_NOTIF_ID_VALID:
		return seccomp_notify_id_valid(filter, buf);
	default:
		return -EINVAL;
	}

This has the downside that programs compiled against more modern kernel headers 
will break on older kernels.

3. We can take the approach you suggested.

#define UNSIZED(cmd)	(cmd & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT)
static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
				 unsigned long arg)
{
	struct seccomp_filter *filter = file->private_data;
	void __user *buf = (void __user *)arg;
	int size = _IOC_SIZE(cmd);
	cmd = UNSIZED(cmd);

	switch (cmd) {
	/* for example. We actually have to do this for any struct we intend to 
	 * extend to get proper backwards compatibility
	 */
	case UNSIZED(SECCOMP_IOCTL_NOTIF_RECV):
		return seccomp_notify_recv(filter, buf, size);
...
	case SECCOMP_IOCTL_NOTIF_SEND:
		return seccomp_notify_send(filter, buf);
	case SECCOMP_IOCTL_NOTIF_ID_VALID:
		return seccomp_notify_id_valid(filter, buf);
	default:
		return -EINVAL;
	}
}

> 
> Leaving that aside, the proposed direction here seems to mean that any
> change to the struct itself will immediately mean a new ioctl() but
> afaict, that also means a new struct. Since when you simply extend the
> struct for the sake of the new ioctl you also change the size for the
> ioctl.
> 
> Sure, you can simply treat the struct coming through the old ioctl as
> being "capped" by e.g. hiding the size as suggested but then the gain
> by having two separate ioctls is 0 compared to simply versioning the
> struct with an explicit size member since the size encoded in the ioctl
> and the actual size of the struct don't line up anymore which is the
> only plus I can see for relying on _IOC_SIZE(). All this manages to do
> then is to make it more annoying for userspace since they now need to
> maintain multiple ioctls(). And if you have - however unlikely - say
> three different ioctls all to be used with a different struct size of
> the same struct I now need to know which ioctl() goes with which size of
> the struct (I guess you could append the size to the ioctl name?
> *shudder*). If you have the size in the struct itself you don't need to
> care about any of that.
> Maybe I'm not making sense or I misunderstand what's going on though.
> 
> Christian
> 
I don't understand why userspace has to have any knowledge of this. As soon as 
we add the code above, and we use copy_struct_from_user based on _that_ size,
userspace will get free upgrades. If they are compiling against an older header
than the kernel, size will return a smaller number, and thus we will zero
out our trailing bits, and if their number is bigger, we just check their
bits are appropriately zeroed.

This approach would be forwards-and-backwards compatible.

There's a little bit of prior art here as well [2]. The approach is that
we effectively do the thing we had earlier with passing a size with
copy_struct_from_user, but instead of the size being embedded in the struct,
it's embedded in the ioctl command itself.


[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/drm/radeon_drm.h?h=v5.7#n831
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/firewire/core-cdev.c?id=v5.7#n1621
