Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5451F6A39
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 16:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgFKOnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 10:43:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53357 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgFKOnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 10:43:04 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jjOPw-0001ni-3R; Thu, 11 Jun 2020 14:42:56 +0000
Date:   Thu, 11 Jun 2020 16:42:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Robert Sesek <rsesek@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        containers@lists.linux-foundation.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200611144254.4ixxx66qabqlvxe4@wittgenstein>
References: <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 11:06:31AM +0000, Sargun Dhillon wrote:
> On Thu, Jun 11, 2020 at 12:01:14PM +0200, Christian Brauner wrote:
> > On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > > As an aside, all of this junk should be dropped:
> > > > +	ret = get_user(size, &uaddfd->size);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > > +	if (ret)
> > > > +		return ret;
> > > > 
> > > > and the size member of the seccomp_notif_addfd struct. I brought this up 
> > > > off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> > > > should just use that. The ioctl definition is based on this[2]:
> > > > #define _IOC(dir,type,nr,size) \
> > > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > > 	 ((size) << _IOC_SIZESHIFT))
> > > > 
> > > > 
> > > > We should just use copy_from_user for now. In the future, we can either 
> > > > introduce new ioctl names for new structs, or extract the size dynamically from 
> > > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > > 
> > > Yeah, that seems reasonable. Here's the diff for that part:
> > 
> > Why does it matter that the ioctl() has the size of the struct embedded
> > within? Afaik, the kernel itself doesn't do anything with that size. It
> > merely checks that the size is not pathological and it does so at
> > compile time.
> > 
> > #ifdef __CHECKER__
> > #define _IOC_TYPECHECK(t) (sizeof(t))
> > #else
> > /* provoke compile error for invalid uses of size argument */
> > extern unsigned int __invalid_size_argument_for_IOC;
> > #define _IOC_TYPECHECK(t) \
> > 	((sizeof(t) == sizeof(t[1]) && \
> > 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> > 	  sizeof(t) : __invalid_size_argument_for_IOC)
> > #endif
> > 
> > The size itself is not verified at runtime. copy_struct_from_user()
> > still makes sense at least if we're going to allow expanding the struct
> > in the future.
> Right, but if we simply change our headers and extend the struct, it will break 
> all existing programs compiled against those headers. In order to avoid that, if 
> we intend on extending this struct by appending to it, we need to have a 
> backwards compatibility mechanism. Just having copy_struct_from_user isn't 
> enough. The data structure either must be fixed size, or we need a way to handle 
> multiple ioctl numbers derived from headers with different sized struct arguments
> 
> The two approaches I see are:
> 1. use more indirection. This has previous art in drm[1]. That's look
> something like this:
> 
> struct seccomp_notif_addfd_ptr {
> 	__u64 size;
> 	__u64 addr;
> }
> 
> ... And then it'd be up to us to dereference the addr and copy struct from user.

Which isn't great but could do.

> 
> 2. Expose one ioctl to the user, many internally
> 
> e.g., public api:
> 
> struct seccomp_notif {
> 	__u64 id;
> 	__u64 pid;
> 	struct seccomp_data;
> 	__u64 fancy_new_field;
> }
> 
> #define SECCOMP_IOCTL_NOTIF_RECV	SECCOMP_IOWR(0, struct seccomp_notif)
> 
> internally:
> struct seccomp_notif_v1 {
> 	__u64 id;
> 	__u64 pid;
> 	struct seccomp_data;
> }
> 
> struct seccomp_notif_v2 {
> 	__u64 id;
> 	__u64 pid;
> 	struct seccomp_data;
> 	__u64 fancy_new_field;
> }
> 
> and we can switch like this:
> 	switch (cmd) {
> 	/* for example. We actually have to do this for any struct we intend to 
> 	 * extend to get proper backwards compatibility
> 	 */
> 	case SECCOMP_IOWR(0, struct seccomp_notif_v1)
> 		return seccomp_notify_recv(filter, buf, sizeof(struct seccomp_notif_v1));
> 	case SECCOMP_IOWR(0, struct seccomp_notif_v2)
> 		return seccomp_notify_recv(filter, buf, sizeof(struct seccomp_notif_v3));
> ...
> 	case SECCOMP_IOCTL_NOTIF_SEND:
> 		return seccomp_notify_send(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> 		return seccomp_notify_id_valid(filter, buf);
> 	default:
> 		return -EINVAL;
> 	}
> 
> This has the downside that programs compiled against more modern kernel headers 
> will break on older kernels.
> 
> 3. We can take the approach you suggested.
> 
> #define UNSIZED(cmd)	(cmd & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT)
> static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> 				 unsigned long arg)
> {
> 	struct seccomp_filter *filter = file->private_data;
> 	void __user *buf = (void __user *)arg;
> 	int size = _IOC_SIZE(cmd);
> 	cmd = UNSIZED(cmd);
> 
> 	switch (cmd) {
> 	/* for example. We actually have to do this for any struct we intend to 
> 	 * extend to get proper backwards compatibility
> 	 */
> 	case UNSIZED(SECCOMP_IOCTL_NOTIF_RECV):
> 		return seccomp_notify_recv(filter, buf, size);
> ...
> 	case SECCOMP_IOCTL_NOTIF_SEND:
> 		return seccomp_notify_send(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> 		return seccomp_notify_id_valid(filter, buf);
> 	default:
> 		return -EINVAL;
> 	}
> }
> 
> > 
> > Leaving that aside, the proposed direction here seems to mean that any
> > change to the struct itself will immediately mean a new ioctl() but
> > afaict, that also means a new struct. Since when you simply extend the
> > struct for the sake of the new ioctl you also change the size for the
> > ioctl.
> > 
> > Sure, you can simply treat the struct coming through the old ioctl as
> > being "capped" by e.g. hiding the size as suggested but then the gain
> > by having two separate ioctls is 0 compared to simply versioning the
> > struct with an explicit size member since the size encoded in the ioctl
> > and the actual size of the struct don't line up anymore which is the
> > only plus I can see for relying on _IOC_SIZE(). All this manages to do
> > then is to make it more annoying for userspace since they now need to
> > maintain multiple ioctls(). And if you have - however unlikely - say
> > three different ioctls all to be used with a different struct size of
> > the same struct I now need to know which ioctl() goes with which size of
> > the struct (I guess you could append the size to the ioctl name?
> > *shudder*). If you have the size in the struct itself you don't need to
> > care about any of that.
> > Maybe I'm not making sense or I misunderstand what's going on though.
> > 
> > Christian
> > 
> I don't understand why userspace has to have any knowledge of this. As soon as 
> we add the code above, and we use copy_struct_from_user based on _that_ size,

Hm, which code exactly?

In the previous mail the only thing proposed was to switch to a simple
copy_from_user() which effectively bars us from extending the
seccomp_addfd struct which this is about, right? At that point, the only
option then becomes to either introduce a new ioctl() and a new struct
or to go for the hack in e.g. 3. (Afaiu, 2. is not working anymore
because we break userspace as soon as we append "fancy_new_field" to the
struct because it changes the ioctl() unless I'm missing something.)

Let me maybe rephrase: I'd prefer we merge something for addfd that is
extensible with minimal burden on userspace. 
But if we are fine with saying "we don't care, let's just use
copy_from_user() for addfd and if we extend we add a new struct + ioctl"
then ok, sure. But I would prefer to keep dealing with new structs +
ioctls (Look at the end of btrfs.h [1] unlikely to be a problem for us,
but still.) as little as possible because that will be more churn in
userspace code than I'd prefer.

So either [1] or - since none of the generic extensibility seems to be
particularly nice - we bite the bullet and just add a:

__u64 reserved[4]

field and hope that this will carry us for a long time (probably will
for quite a long time) and defer the new ioctl() problem.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/btrfs.h

> userspace will get free upgrades. If they are compiling against an older header
> than the kernel, size will return a smaller number, and thus we will zero
> out our trailing bits, and if their number is bigger, we just check their
> bits are appropriately zeroed.
> 
> This approach would be forwards-and-backwards compatible.
> 
> There's a little bit of prior art here as well [2]. The approach is that
> we effectively do the thing we had earlier with passing a size with
> copy_struct_from_user, but instead of the size being embedded in the struct,
> it's embedded in the ioctl command itself.

That looks super sketchy. :D

Christian
