Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26AB2CDDB3
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgLCSdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:33:00 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:44536 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729533AbgLCSc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:32:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UHQyFLP_1607020326;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHQyFLP_1607020326)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:32:15 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Oleg Nesterov <oleg@tv-sign.ru>,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Paul Menage <menage@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Subject: [PATCH 00/10] Cover letter: fix a race in release_task when flushing the dentry
Date:   Fri,  4 Dec 2020 02:31:54 +0800
Message-Id: <20201203183204.63759-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dentries such as /proc/<pid>/ns/ have the DCACHE_OP_DELETE flag, they 
should be deleted when the process exits. 

Suppose the following race appears： 

release_task                 dput 
-> proc_flush_task 
                             -> dentry->d_op->d_delete(dentry) 
-> __exit_signal 
                             -> dentry->d_lockref.count--  and return. 

In the proc_flush_task(), if another process is using this dentry, it will
not be deleted. At the same time, in dput(), d_op->d_delete() can be executed
before __exit_signal(pid has not been hashed), d_delete returns false, so
this dentry still cannot be deleted.

This dentry will always be cached (although its count is 0 and the
DCACHE_OP_DELETE flag is set), its parent denry will also be cached too, and
these dentries can only be deleted when drop_caches is manually triggered.

This will result in wasted memory. What's more troublesome is that these
dentries reference pid, according to the commit f333c700c610 ("pidns: Add a
limit on the number of pid namespaces"), if the pid cannot be released, it
may result in the inability to create a new pid_ns.

This problem occurred in our cluster environment (Linux 4.9 LTS).
We could reproduce it by manually constructing a test program + adding some
debugging switches in the kernel:
* A test program to open the directory (/proc/<pid>/ns) [1]
* Adding some debugging switches to the kernel, adding a delay between
   proc_flush_task and __exit_signal in release_task() [2]

The test process is as follows:

A, terminal #1

Turn on the debug switch:
echo 1> /proc/sys/vm/dentry_debug_trace

Execute the following unshare command:
sudo unshare --pid --fork --mount-proc bash


B, terminal #2

Find the pid of the unshare process:

# pstree -p | grep unshare
           | `-sshd(716)---bash(718)--sudo(816)---unshare(817)---bash(818)


Find the corresponding dentry:
# dmesg | grep pid=818
[70.424722] XXX proc_pid_instantiate:3119 pid=818 tid=818 entry=818/ffff8802c7b670e8


C, terminal #3

Execute the opendir program, it will always open the /proc/818/ns/ directory:

# ./a.out /proc/818/ns/
pid: 876
.
..
net
uts
ipc
pid
user
mnt
cgroup

D, go back to terminal #2

Turn on the debugging switches to construct the race:
# echo 818> /proc/sys/vm/dentry_debug_pid
# echo 1> /proc/sys/vm/dentry_debug_delay

Kill the unshare process (pid 818). Since the debugging switches have been
turned on, it will get stuck in release_task():
# kill -9 818

Then kill the process that opened the /proc/818/ns/ directory:
# kill -9 876

Then turn off these debugging switches to allow the 818 process to exit:
# echo 0> /proc/sys/vm/dentry_debug_delay
# echo 0> /proc/sys/vm/dentry_debug_pid

Checking the dmesg, we will find that the dentry(/proc/818/ns) ’s count is 0,
and the flag is 2800cc (#define DCACHE_OP_DELETE 0x00000008), but it is still
cached:
# dmesg | grep ffff8802a3999548
…
[565.559156] XXX dput:853 dentry=ns/ffff8802bea7b528, flag=2800cc, cnt=0, inode=ffff8802b38c2010, pdentry=818/ffff8802c7b670e8, pflag=20008c, pcnt=1, pinode=ffff8802c7812010, keywords: be cached


It could also be verified via the crash tool:

crash> dentry.d_flags,d_iname,d_inode,d_lockref -x  ffff8802bea7b528
  d_flags = 0x2800cc
  d_iname = "ns\000kkkkkkkkkkkkkkkkkkkkkkkkkkkk"
  d_inode = 0xffff8802b38c2010
  d_lockref = {
    {
      lock_count = 0x0,
      {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  val = {
                    counter = 0x0
                  },
                  {
                    locked = 0x0,
                    pending = 0x0
                  },
                  {
                    locked_pending = 0x0,
                    tail = 0x0
                  }
                }
              }
            }
          }
        },
        count = 0x0
      }
    }
  }
crash> kmem  ffff8802bea7b528
CACHE             OBJSIZE  ALLOCATED     TOTAL  SLABS  SSIZE  NAME
ffff8802dd5f5900      192      23663     26130    871    16k  dentry
  SLAB              MEMORY            NODE  TOTAL  ALLOCATED  FREE
  ffffea000afa9e00  ffff8802bea78000     0     30         25     5
  FREE / [ALLOCATED]
  [ffff8802bea7b520]

      PAGE        PHYSICAL      MAPPING       INDEX CNT FLAGS
ffffea000afa9ec0 2bea7b000 dead000000000400        0  0 2fffff80000000
crash>

This series of patches is to fix this issue.

Regards,
Wen

Alexey Dobriyan (1):
  proc: use %u for pid printing and slightly less stack

Andreas Gruenbacher (1):
  proc: Pass file mode to proc_pid_make_inode

Christian Brauner (1):
  clone: add CLONE_PIDFD

Eric W. Biederman (6):
  proc: Better ownership of files for non-dumpable tasks in user
    namespaces
  proc: Rename in proc_inode rename sysctl_inodes sibling_inodes
  proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
  proc: Clear the pieces of proc_inode that proc_evict_inode cares about
  proc: Use d_invalidate in proc_prune_siblings_dcache
  proc: Use a list of inodes to flush from proc

Joel Fernandes (Google) (1):
  pidfd: add polling support

 fs/proc/base.c             | 242 ++++++++++++++++++++-------------------------
 fs/proc/fd.c               |  20 +---
 fs/proc/inode.c            |  67 ++++++++++++-
 fs/proc/internal.h         |  22 ++---
 fs/proc/namespaces.c       |   3 +-
 fs/proc/proc_sysctl.c      |  45 ++-------
 fs/proc/self.c             |   6 +-
 fs/proc/thread_self.c      |   5 +-
 include/linux/pid.h        |   5 +
 include/linux/proc_fs.h    |   4 +-
 include/uapi/linux/sched.h |   1 +
 kernel/exit.c              |   5 +-
 kernel/fork.c              | 145 ++++++++++++++++++++++++++-
 kernel/pid.c               |   3 +
 kernel/signal.c            |  11 +++
 security/selinux/hooks.c   |   1 +
 16 files changed, 357 insertions(+), 228 deletions(-)

[1] A test program to open the directory (/proc/<pid>/ns)
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	DIR *dip;
	struct dirent *dit;

	if (argc < 2) {
		printf("Usage :%s <directory>\n", argv[0]);
		return -1;
	}

	if ((dip = opendir(argv[1])) == NULL) {
		perror("opendir");
		return -1;
	}

	printf("pid: %d\n", getpid());
	while((dit = readdir (dip)) != NULL) {
		printf("%s\n", dit->d_name);
	}

	while (1)
		sleep (1);

	return 0;
}

[2] Adding some debugging switches to the kernel, also adding a delay between
    proc_flush_task and __exit_signal in release_task():

diff --git a/fs/dcache.c b/fs/dcache.c
index 05bad55..fafad37 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -84,6 +84,9 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);

+int sysctl_dentry_debug_trace __read_mostly = 0;
+EXPORT_SYMBOL_GPL(sysctl_dentry_debug_trace);
+
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);

 EXPORT_SYMBOL(rename_lock);
@@ -758,6 +761,26 @@ static inline bool fast_dput(struct dentry *dentry)
 	return 0;
 }

+#define DENTRY_DEBUG_TRACE(dentry, keywords)                            \
+do {                                                                    \
+	if (sysctl_dentry_debug_trace)                                   \
+		printk("XXX %s:%d "                                      \
+                	"dentry=%s/%p, flag=%x, cnt=%d, inode=%p, "      \
+                	"pdentry=%s/%p, pflag=%x, pcnt=%d, pinode=%p, "  \
+			"keywords: %s\n",                                \
+			__func__, __LINE__,                              \
+			dentry->d_name.name,                             \
+			dentry,                                          \
+			dentry->d_flags,                                 \
+			dentry->d_lockref.count,                         \
+			dentry->d_inode,                                 \
+			dentry->d_parent->d_name.name,                   \
+			dentry->d_parent,                                \
+			dentry->d_parent->d_flags,                       \
+			dentry->d_parent->d_lockref.count,               \
+			dentry->d_parent->d_inode,                       \
+			keywords);                                       \
+} while (0)

 /*
  * This is dput
@@ -804,6 +827,8 @@ void dput(struct dentry *dentry)

 	WARN_ON(d_in_lookup(dentry));

+	DENTRY_DEBUG_TRACE(dentry, "be checked");
+
 	/* Unreachable? Get rid of it */
 	if (unlikely(d_unhashed(dentry)))
 		goto kill_it;
@@ -812,8 +837,10 @@ void dput(struct dentry *dentry)
 		goto kill_it;

 	if (unlikely(dentry->d_flags & DCACHE_OP_DELETE)) {
-		if (dentry->d_op->d_delete(dentry))
+		if (dentry->d_op->d_delete(dentry)) {
+			DENTRY_DEBUG_TRACE(dentry, "be killed");
 			goto kill_it;
+		}
 	}

 	if (!(dentry->d_flags & DCACHE_REFERENCED))
@@ -822,6 +849,9 @@ void dput(struct dentry *dentry)

 	dentry->d_lockref.count--;
 	spin_unlock(&dentry->d_lock);
+
+	DENTRY_DEBUG_TRACE(dentry, "be cached");
+
 	return;

 kill_it:
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b9e4183..419a409 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3090,6 +3090,8 @@ void proc_flush_task(struct task_struct *task)
 	}
 }

+extern int sysctl_dentry_debug_trace;
+
 static int proc_pid_instantiate(struct inode *dir,
 				   struct dentry * dentry,
 				   struct task_struct *task, const void *ptr)
@@ -3111,6 +3113,12 @@ static int proc_pid_instantiate(struct inode *dir,
 	d_set_d_op(dentry, &pid_dentry_operations);

 	d_add(dentry, inode);
+
+	if (sysctl_dentry_debug_trace)
+		printk("XXX %s:%d pid=%d tid=%d  entry=%s/%p\n",
+			__func__, __LINE__, task->pid, task->tgid,
+			dentry->d_name.name, dentry);
+
 	/* Close the race of the process dying before we return the dentry */
 	if (pid_revalidate(dentry, 0))
 		return 0;
diff --git a/kernel/exit.c b/kernel/exit.c
index 27f4168..2b3e1b6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -55,6 +55,8 @@
 #include <linux/shm.h>
 #include <linux/kcov.h>

+#include <linux/delay.h>
+
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
@@ -164,6 +166,8 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(tsk);
 }

+int sysctl_dentry_debug_delay __read_mostly = 0;
+int sysctl_dentry_debug_pid __read_mostly = 0;

 void release_task(struct task_struct *p)
 {
@@ -178,6 +182,11 @@ void release_task(struct task_struct *p)

 	proc_flush_task(p);

+	if (sysctl_dentry_debug_delay && p->pid == sysctl_dentry_debug_pid) {
+		while (sysctl_dentry_debug_delay)
+			mdelay(1);
+	}
+
 	write_lock_irq(&tasklist_lock);
 	ptrace_release_task(p);
 	__exit_signal(p);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 513e6da..27f1395 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -282,6 +282,10 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 static int max_extfrag_threshold = 1000;
 #endif

+extern int sysctl_dentry_debug_trace;
+extern int sysctl_dentry_debug_delay;
+extern int sysctl_dentry_debug_pid;
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sched_child_runs_first",
@@ -1498,6 +1502,30 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
+	{
+		.procname	= "dentry_debug_trace",
+		.data		= &sysctl_dentry_debug_trace,
+		.maxlen		= sizeof(sysctl_dentry_debug_trace),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+	},
+	{
+		.procname	= "dentry_debug_delay",
+		.data		= &sysctl_dentry_debug_delay,
+		.maxlen		= sizeof(sysctl_dentry_debug_delay),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+	},
+	{
+		.procname	= "dentry_debug_pid",
+		.data		= &sysctl_dentry_debug_pid,
+		.maxlen		= sizeof(sysctl_dentry_debug_pid),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
 		.procname	= "legacy_va_layout",


Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
-- 
1.8.3.1

