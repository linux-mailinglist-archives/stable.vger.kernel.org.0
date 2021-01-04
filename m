Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40D02E95A9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhADNOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 08:14:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46889 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbhADNOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 08:14:34 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kwPgA-0002YP-Sd; Mon, 04 Jan 2021 13:13:47 +0000
Date:   Mon, 4 Jan 2021 14:13:42 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Lutomirsky <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] clone: add CLONE_PIDFD
Message-ID: <20210104131342.avhphyfxthtrj6vj@wittgenstein>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
 <20201203183204.63759-2-wenyang@linux.alibaba.com>
 <X/MSEjmCeWHR65gL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/MSEjmCeWHR65gL@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 02:03:14PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Dec 04, 2020 at 02:31:55AM +0800, Wen Yang wrote:
> > From: Christian Brauner <christian@brauner.io>
> > 
> > [ Upstream commit b3e5838252665ee4cfa76b82bdf1198dca81e5be ]
> > 
> > This patchset makes it possible to retrieve pid file descriptors at
> > process creation time by introducing the new flag CLONE_PIDFD to the
> > clone() system call.  Linus originally suggested to implement this as a
> > new flag to clone() instead of making it a separate system call.  As
> > spotted by Linus, there is exactly one bit for clone() left.
> > 
> > CLONE_PIDFD creates file descriptors based on the anonymous inode
> > implementation in the kernel that will also be used to implement the new
> > mount api.  They serve as a simple opaque handle on pids.  Logically,
> > this makes it possible to interpret a pidfd differently, narrowing or
> > widening the scope of various operations (e.g. signal sending).  Thus, a
> > pidfd cannot just refer to a tgid, but also a tid, or in theory - given
> > appropriate flag arguments in relevant syscalls - a process group or
> > session. A pidfd does not represent a privilege.  This does not imply it
> > cannot ever be that way but for now this is not the case.
> > 
> > A pidfd comes with additional information in fdinfo if the kernel supports
> > procfs.  The fdinfo file contains the pid of the process in the callers
> > pid namespace in the same format as the procfs status file, i.e. "Pid:\t%d".
> > 
> > As suggested by Oleg, with CLONE_PIDFD the pidfd is returned in the
> > parent_tidptr argument of clone.  This has the advantage that we can
> > give back the associated pid and the pidfd at the same time.
> > 
> > To remove worries about missing metadata access this patchset comes with
> > a sample program that illustrates how a combination of CLONE_PIDFD, and
> > pidfd_send_signal() can be used to gain race-free access to process
> > metadata through /proc/<pid>.  The sample program can easily be
> > translated into a helper that would be suitable for inclusion in libc so
> > that users don't have to worry about writing it themselves.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Christian Brauner <christian@brauner.io>
> > Co-developed-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Jann Horn <jannh@google.com>
> > Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> > Cc: Andy Lutomirsky <luto@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: <stable@vger.kernel.org> # 4.9.x
> > (clone: fix up cherry-pick conflicts for b3e583825266)
> > Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> > ---
> >  include/linux/pid.h        |   1 +
> >  include/uapi/linux/sched.h |   1 +
> >  kernel/fork.c              | 119 +++++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 117 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/pid.h b/include/linux/pid.h
> > index 97b745d..7599a78 100644
> > --- a/include/linux/pid.h
> > +++ b/include/linux/pid.h
> > @@ -73,6 +73,7 @@ struct pid_link
> >  	struct hlist_node node;
> >  	struct pid *pid;
> >  };
> > +extern const struct file_operations pidfd_fops;
> >  
> >  static inline struct pid *get_pid(struct pid *pid)
> >  {
> > diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> > index 5f0fe01..ed6e31d 100644
> > --- a/include/uapi/linux/sched.h
> > +++ b/include/uapi/linux/sched.h
> > @@ -9,6 +9,7 @@
> >  #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
> >  #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
> >  #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
> > +#define CLONE_PIDFD	0x00001000	/* set if a pidfd should be placed in parent */
> >  #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
> >  #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
> >  #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index b64efec..076297a 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -11,7 +11,22 @@
> >   * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
> >   */
> >  
> > +#include <linux/anon_inodes.h>
> >  #include <linux/slab.h>
> > +#if 0
> > +#include <linux/sched/autogroup.h>
> > +#include <linux/sched/mm.h>
> > +#include <linux/sched/coredump.h>
> > +#include <linux/sched/user.h>
> > +#include <linux/sched/numa_balancing.h>
> > +#include <linux/sched/stat.h>
> > +#include <linux/sched/task.h>
> > +#include <linux/sched/task_stack.h>
> > +#include <linux/sched/cputime.h>
> > +#include <linux/seq_file.h>
> > +#include <linux/rtmutex.h>
> > +>>>>>>> b3e58382... clone: add CLONE_PIDFD
> > +#endif
> 
> That looks odd :(
> 
> Can you please refresh this patch series, and make sure it is correct
> and resend it?

Uhm, this patch series has been merged at least a year ago so this looks
like an accidental send.
This probably isn't meant for upstream but for some alibaba specific
kernel I'd reckon.

Thanks!
Christian
