Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1C381F4D
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbhEPOon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 10:44:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:15608 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230324AbhEPOom (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 10:44:42 -0400
IronPort-SDR: bg2rZuGMzt7CMah2sK2nB9JDf08zUkiCvtPJjDxnxY+2jOObDBktqGcSo/CLJOC7v1GSC4/i/E
 /udtNM2fz49g==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="197251762"
X-IronPort-AV: E=Sophos;i="5.82,304,1613462400"; 
   d="xz'?scan'208";a="197251762"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2021 07:43:27 -0700
IronPort-SDR: QQA16LRZzhMee4kmipi8+t9rDYCCHhosP28p+GyjJKZLhcmyOPFOiaAXsElOLlGBHtHcchulAY
 tAiSxrmFJiwA==
X-IronPort-AV: E=Sophos;i="5.82,304,1613462400"; 
   d="xz'?scan'208";a="629544498"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2021 07:43:24 -0700
Date:   Sun, 16 May 2021 23:00:19 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com
Subject: [video]  dc13cac486: BUG:KASAN:stack-out-of-bounds_in_hgafb_open
Message-ID: <20210516150019.GB25903@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-9):

commit: dc13cac4862cc68ec74348a80b6942532b7735fa ("video: hgafb: fix potential NULL pointer dereference")
https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git char-misc-linus


in testcase: trinity
version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
with following parameters:

	number: 99999
	group: group-02

test-description: Trinity is a linux system call fuzz tester.
test-url: http://codemonkey.org.uk/projects/trinity/


on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


+---------------------------------------------+------------+------------+
|                                             | 58c0cc2d90 | dc13cac486 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 42         | 14         |
| boot_failures                               | 0          | 34         |
| BUG:KASAN:stack-out-of-bounds_in_hgafb_open | 0          | 34         |
+---------------------------------------------+------------+------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


[  419.568887] BUG: KASAN: stack-out-of-bounds in hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 
[  419.569766] Write of size 32768 at addr ffffc90000890000 by task plymouthd/237
[  419.570595]
[  419.570829] CPU: 0 PID: 237 Comm: plymouthd Not tainted 5.13.0-rc1-00044-gdc13cac4862c #1
[  419.571610] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[  419.572304] Call Trace:
[  419.572526] print_address_description.cold+0x5/0x2f8 
[  419.573247] ? hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 
[  419.573728] ? hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 
[  419.574200] kasan_report.cold (kbuild/src/consumer/mm/kasan/report.c:420 kbuild/src/consumer/mm/kasan/report.c:436) 
[  419.574607] ? hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 
[  419.574921] kasan_check_range (kbuild/src/consumer/mm/kasan/generic.c:187) 
[  419.575271] memset (kbuild/src/consumer/mm/kasan/shadow.c:44) 
[  419.575529] hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 
[  419.575827] fb_open (kbuild/src/consumer/include/linux/fb.h:641 kbuild/src/consumer/drivers/video/fbdev/core/fbmem.c:1419) 
[  419.576120] chrdev_open (kbuild/src/consumer/fs/char_dev.c:415) 
[  419.576444] ? exact_lock (kbuild/src/consumer/fs/char_dev.c:374) 
[  419.576745] do_dentry_open (kbuild/src/consumer/fs/open.c:827) 
[  419.577074] ? exact_lock (kbuild/src/consumer/fs/char_dev.c:374) 
[  419.577373] ? may_open (kbuild/src/consumer/fs/namei.c:2983) 
[  419.577669] path_openat (kbuild/src/consumer/fs/namei.c:3362 kbuild/src/consumer/fs/namei.c:3494) 
[  419.578014] ? path_lookupat+0x400/0x400 
[  419.578399] ? lockdep_hardirqs_on_prepare (kbuild/src/consumer/kernel/locking/lockdep.c:4760) 
[  419.578842] ? lock_is_held_type (kbuild/src/consumer/kernel/locking/lockdep.c:5255 kbuild/src/consumer/kernel/locking/lockdep.c:5555) 
[  419.605410] do_filp_open (kbuild/src/consumer/fs/namei.c:3521) 
[  419.605904] ? may_open_dev (kbuild/src/consumer/fs/namei.c:3515) 
[  419.606421] ? _raw_spin_unlock (kbuild/src/consumer/arch/x86/include/asm/preempt.h:95 kbuild/src/consumer/include/linux/spinlock_api_smp.h:152 kbuild/src/consumer/kernel/locking/spinlock.c:183) 
[  419.606962] ? alloc_fd (kbuild/src/consumer/fs/file.c:526 (discriminator 13)) 
[  419.607437] ? getname_flags (kbuild/src/consumer/fs/namei.c:149) 
[  419.607941] do_sys_openat2 (kbuild/src/consumer/fs/open.c:1187) 
[  419.608453] ? lock_release (kbuild/src/consumer/arch/x86/include/asm/bitops.h:214 kbuild/src/consumer/include/asm-generic/bitops/instrumented-non-atomic.h:135 kbuild/src/consumer/kernel/locking/lockdep.c:199 kbuild/src/consumer/kernel/locking/lockdep.c:323 kbuild/src/consumer/kernel/locking/lockdep.c:5196 kbuild/src/consumer/kernel/locking/lockdep.c:5532) 
[  419.608959] ? file_open_root (kbuild/src/consumer/fs/open.c:1173) 
[  419.609487] ? lock_release (kbuild/src/consumer/arch/x86/include/asm/bitops.h:214 kbuild/src/consumer/include/asm-generic/bitops/instrumented-non-atomic.h:135 kbuild/src/consumer/kernel/locking/lockdep.c:199 kbuild/src/consumer/kernel/locking/lockdep.c:323 kbuild/src/consumer/kernel/locking/lockdep.c:5196 kbuild/src/consumer/kernel/locking/lockdep.c:5532) 
[  419.610011] do_sys_open (kbuild/src/consumer/fs/open.c:1201) 
[  419.610470] ? filp_open (kbuild/src/consumer/fs/open.c:1201) 
[  419.610928] ? syscall_enter_from_user_mode (kbuild/src/consumer/arch/x86/include/asm/irqflags.h:45 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:80 kbuild/src/consumer/kernel/entry/common.c:106) 
[  419.611584] ? trace_hardirqs_on (kbuild/src/consumer/kernel/trace/trace_preemptirq.c:50 (discriminator 22)) 
[  419.612155] ? syscall_enter_from_user_mode (kbuild/src/consumer/arch/x86/include/asm/irqflags.h:45 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:80 kbuild/src/consumer/kernel/entry/common.c:106) 
[  419.612852] do_syscall_64 (kbuild/src/consumer/arch/x86/entry/common.c:47) 
[  419.613329] entry_SYSCALL_64_after_hwframe (kbuild/src/consumer/arch/x86/entry/entry_64.S:112) 
[  419.614045] RIP: 0033:0x7fbb1c448eb0
[ 419.614629] Code: 48 8b 15 93 0f 2d 00 f7 d8 64 89 02 48 83 c8 ff c3 90 90 90 90 90 90 90 90 90 83 3d 2d 73 2d 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 2e b3 01 00 48 89 04 24
All code
========
   0:	48 8b 15 93 0f 2d 00 	mov    0x2d0f93(%rip),%rdx        # 0x2d0f9a
   7:	f7 d8                	neg    %eax
   9:	64 89 02             	mov    %eax,%fs:(%rdx)
   c:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  10:	c3                   	retq   
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	83 3d 2d 73 2d 00 00 	cmpl   $0x0,0x2d732d(%rip)        # 0x2d734e
  21:	75 10                	jne    0x33
  23:	b8 02 00 00 00       	mov    $0x2,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 31                	jae    0x63
  32:	c3                   	retq   
  33:	48 83 ec 08          	sub    $0x8,%rsp
  37:	e8 2e b3 01 00       	callq  0x1b36a
  3c:	48 89 04 24          	mov    %rax,(%rsp)

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 31                	jae    0x39
   8:	c3                   	retq   
   9:	48 83 ec 08          	sub    $0x8,%rsp
   d:	e8 2e b3 01 00       	callq  0x1b340
  12:	48 89 04 24          	mov    %rax,(%rsp)
[  419.616969] RSP: 002b:00007fff20a76ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[  419.617971] RAX: ffffffffffffffda RBX: 00000000017c1070 RCX: 00007fbb1c448eb0
[  419.618883] RDX: 00007fbb1a19b1e0 RSI: 0000000000000002 RDI: 00000000017c0a00
[  419.619798] RBP: 00007fbb1cd666a0 R08: 0000000000000008 R09: 0000000001000000
[  419.620709] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbb1c72f778
[  419.621659] R13: 0000000000000002 R14: 00007fbb1cd666a0 R15: 00000000017bc2e0
[  419.622599]
[  419.622819]
[  419.623031] Memory state around the buggy address:
[  419.623661]  ffffc90000897c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  419.624571]  ffffc90000897c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  419.625476] >ffffc90000897d00: 00 00 00 00 00 00 f1 f1 f1 f1 00 00 f3 f3 00 00
[  419.626420]                                      ^
[  419.627043]  ffffc90000897d80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  419.627970]  ffffc90000897e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  419.628897] ==================================================================
[  419.629823] Disabling lock debugging due to kernel taint
[  420.487934] _warn_unseeded_randomness: 282 callbacks suppressed
[  420.487946] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=0 
[  420.487961] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=0 
[  420.488000] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=0 
[  420.498675] random: fast init done
[  421.493166] _warn_unseeded_randomness: 225 callbacks suppressed
[  421.493175] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=1 
[  421.493187] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=1 
[  421.493309] random: get_random_u32 called from arch_setup_additional_pages+0x11f/0x180 with crng_init=1 
[  421.516720] init: failsafe main process (528) killed by TERM signal
[  421.519905] init: networking main process (548) terminated with status 1
[  421.576147] Seeding trinity based on x86_64-randconfig-a015-20210513
[  421.576165]
[  421.664568] random: dd: uninitialized urandom read (4096 bytes read)
[  421.809592] random: trinity: uninitialized urandom read (4 bytes read)
[  422.496319] _warn_unseeded_randomness: 654 callbacks suppressed
[  422.496329] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=1 
[  422.496340] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=1 
[  422.496466] random: get_random_u32 called from arch_setup_additional_pages+0x11f/0x180 with crng_init=1 
[  423.501918] _warn_unseeded_randomness: 553 callbacks suppressed
[  423.501932] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=1 
[  423.501971] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=1 
[  423.508779] random: get_random_u32 called from arch_setup_additional_pages+0x11f/0x180 with crng_init=1 
[  424.505237] _warn_unseeded_randomness: 472 callbacks suppressed
[  424.505278] random: get_random_u64 called from dup_task_struct+0x298/0x8e0 with crng_init=1 
[  424.516542] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=1 
[  424.516597] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=1 
[  425.513898] _warn_unseeded_randomness: 488 callbacks suppressed
[  425.513913] random: get_random_u64 called from dup_task_struct+0x298/0x8e0 with crng_init=1 
[  425.524730] random: get_random_u64 called from arch_rnd+0x48/0x80 with crng_init=1 
[  425.524755] random: get_random_u64 called from randomize_stack_top+0x5c/0x80 with crng_init=1 
[  426.451592] 2021-05-14 20:15:06 chroot --userspec nobody:nogroup / trinity -q -q -l off -s 3463942183 -N 99999
[  426.451639]
[  426.544444] Trinity 2019.06  Dave Jones <davej@codemonkey.org.uk>
[  426.544475]
[  426.552070] shm:0x7f13f7a52000-0x7f140464ed00 (4 pages)
[  426.552099]
[  426.563116] [main] Couldn't chmod tmp/ to 0777.
[  426.563144]
[  426.569843] [main] Using user passed random seed: 3463942183.
[  426.569868]
[  426.579139] _warn_unseeded_randomness: 451 callbacks suppressed
[  426.579152] random: get_random_u32 called from htab_map_alloc+0xa4d/0xda0 with crng_init=1 
[  426.586604] [main] Kernel was tainted on startup. Will ignore flags that are already set.
[  426.586630]
[  426.589859] Marking all syscalls as enabled.
[  426.589880]
[  426.600218] [main] 32-bit syscalls: 429 enabled.  64-bit syscalls: 347 enabled, 89 disabled.
[  426.600251]
[  426.610199] [main] Using pid_max = 4096
[  426.610230]
[  426.612222] [main] futex: 0 owner:0
[  426.612243]
[  426.614161] [main] futex: 0 owner:0
[  426.623585]
[  426.625630] [main] futex: 0 owner:0
[  426.625650]


To reproduce:

        # build kernel
	cd linux
	cp config-5.13.0-rc1-00044-gdc13cac4862c .config
	make HOSTCC=gcc-9 CC=gcc-9 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email



---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation

Thanks,
Oliver Sang


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.13.0-rc1-00044-gdc13cac4862c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.13.0-rc1 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23502
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_WATCH_QUEUE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_BPF is not set
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_NAMESPACES is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
# CONFIG_POSIX_TIMERS is not set
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_IO_URING is not set
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_USERFAULTFD is not set
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
CONFIG_ACRN_GUEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_NR_CPUS_RANGE_BEGIN=1
CONFIG_NR_CPUS_RANGE_END=1
CONFIG_NR_CPUS_DEFAULT=1
CONFIG_NR_CPUS=1
CONFIG_UP_LATE_INIT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
CONFIG_PERF_EVENTS_AMD_POWER=y
# end of Performance monitoring

CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_X86_IOPL_IOPERM is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_X86_CPA_STATISTICS=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_X86_UMIP=y
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
# CONFIG_EFI is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_DPTF is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

# CONFIG_INTEL_IDLE is not set
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ISA_BUS=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
# CONFIG_IA32_EMULATION is not set
# CONFIG_X86_X32 is not set
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_GENERIC_ENTRY=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_STATIC_CALL_SELFTEST=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_ISA_BUS_API=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_CMA_DEBUGFS is not set
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=7
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
CONFIG_KMAP_LOCAL=y
# end of Memory Management options

CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_MPTCP is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PTM=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=y
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
# CONFIG_PCIE_BUS_DEFAULT is not set
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
CONFIG_PCIE_BUS_PEER2PEER=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
CONFIG_PCI_ENDPOINT=y
# CONFIG_PCI_ENDPOINT_CONFIGFS is not set
CONFIG_PCI_EPF_TEST=y
# CONFIG_PCI_EPF_NTB is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
CONFIG_PCI_SW_SWITCHTEC=y
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_PM_QOS_KUNIT_TEST=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
# CONFIG_DRIVER_PE_KUNIT_TEST is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SLIMBUS=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

# CONFIG_CONNECTOR is not set
CONFIG_GNSS=y
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# NVME Support
#
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
CONFIG_PCI_ENDPOINT_TEST=y
CONFIG_XILINX_SDFEC=y
CONFIG_MISC_RTSX=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=y
CONFIG_HABANA_AI=y
CONFIG_UACCE=y
# CONFIG_PVPANIC is not set
# end of Misc devices

CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# end of SCSI device support

# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NTB_NETDEV is not set
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
# CONFIG_MDIO_DEVICE is not set

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_WLAN_VENDOR_ATMEL=y
CONFIG_WLAN_VENDOR_BROADCOM=y
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_WLAN_VENDOR_MICROCHIP=y
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_WLAN_VENDOR_RSI=y
CONFIG_WLAN_VENDOR_ST=y
CONFIG_WLAN_VENDOR_TI=y
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_WAN is not set
# CONFIG_WWAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_IQS62X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_MTK_PMIC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS is not set
# CONFIG_MOUSE_PS2_CYPRESS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_FOCALTECH is not set
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADC=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_PXRC is not set
# CONFIG_JOYSTICK_FSIA6B is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ADC is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_BU21029=y
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
CONFIG_TOUCHSCREEN_CY8CTMA140=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_EGALAX_SERIAL=y
CONFIG_TOUCHSCREEN_EXC3000=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GOODIX is not set
CONFIG_TOUCHSCREEN_HIDEEP=y
# CONFIG_TOUCHSCREEN_HYCON_HY46XX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_ILITEK is not set
CONFIG_TOUCHSCREEN_S6SY761=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_EKTF2127=y
CONFIG_TOUCHSCREEN_ELAN=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MELFAS_MIP4=y
# CONFIG_TOUCHSCREEN_MSG2638 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC200X_CORE=y
CONFIG_TOUCHSCREEN_TSC2004=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_TSC2007_IIO=y
CONFIG_TOUCHSCREEN_RM_TS=y
CONFIG_TOUCHSCREEN_SILEAD=y
CONFIG_TOUCHSCREEN_SIS_I2C=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZET6223 is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
CONFIG_TOUCHSCREEN_ZINITIX=y
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F3A=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_GPIO_PS2=y
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_LDISC_AUTOLOAD is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_LANTIQ=y
CONFIG_SERIAL_LANTIQ_CONSOLE=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_SC16IS7XX_I2C is not set
CONFIG_SERIAL_BCM63XX=y
# CONFIG_SERIAL_BCM63XX_CONSOLE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
CONFIG_NOZOMI=y
CONFIG_NULL_TTY=y
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_TTY_PRINTK=y
CONFIG_TTY_PRINTK_LEVEL=6
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_IPMB_DEVICE_INTERFACE=y
# CONFIG_HW_RANDOM is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_SCR24X=y
# CONFIG_IPWIRELESS is not set
# end of PCMCIA character devices

# CONFIG_MWAVE is not set
# CONFIG_DEVMEM is not set
# CONFIG_NVRAM is not set
# CONFIG_DEVPORT is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TELCLOCK=y
CONFIG_XILLYBUS=y
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_LTC4306 is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_MUX_MLXCPLD=y
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_GPIO_FAULT_INJECTOR=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
# CONFIG_I2C_SLAVE_TESTUNIT is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y
# CONFIG_PPS is not set

#
# PTP clock support
#

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_DA9062=y
CONFIG_PINCTRL_MCP23S08_I2C=y
CONFIG_PINCTRL_MCP23S08=y
# CONFIG_PINCTRL_SX150X is not set
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_CDEV is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_MB86S7X is not set
CONFIG_GPIO_VX855=y
CONFIG_GPIO_AMD_FCH=y
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_WINBOND=y
CONFIG_GPIO_WS16C48=y
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCA9570=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_LP873X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_TPS65086=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TQMX86=y
CONFIG_GPIO_UCB1400=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=y
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_PCI_IDIO_16 is not set
CONFIG_GPIO_PCIE_IDIO_24=y
CONFIG_GPIO_RDC321X=y
# end of PCI GPIO expanders

#
# Virtual GPIO drivers
#
CONFIG_GPIO_AGGREGATOR=y
# CONFIG_GPIO_MOCKUP is not set
# end of Virtual GPIO drivers

CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set
# CONFIG_W1_MASTER_SGI is not set
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2405=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2805=y
# CONFIG_W1_SLAVE_DS2430 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2438=y
CONFIG_W1_SLAVE_DS250X=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_DS28E17=y
# end of 1-wire Slaves

# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_CHARGER_SBS is not set
CONFIG_MANAGER_SBS=y
CONFIG_BATTERY_BQ27XXX=y
# CONFIG_BATTERY_BQ27XXX_I2C is not set
CONFIG_BATTERY_BQ27XXX_HDQ=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_CHARGER_AXP20X=y
CONFIG_BATTERY_AXP20X=y
# CONFIG_AXP20X_POWER is not set
CONFIG_AXP288_FUEL_GAUGE=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_LT3651=y
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24257=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ2515X=y
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_BQ25980=y
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_CHARGER_RT9455=y
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_AHT10 is not set
CONFIG_SENSORS_AS370=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_AXI_FAN_CONTROL=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ASPEED is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_CORSAIR_CPRO=y
CONFIG_SENSORS_CORSAIR_PSU=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_FTSTEUTATES is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2947=y
CONFIG_SENSORS_LTC2947_I2C=y
CONFIG_SENSORS_LTC2990=y
CONFIG_SENSORS_LTC2992=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX127 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX31730=y
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_TC654=y
# CONFIG_SENSORS_TPS23861 is not set
CONFIG_SENSORS_MR75203=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NCT7802=y
# CONFIG_SENSORS_NCT7904 is not set
CONFIG_SENSORS_NPCM7XX=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SBTSI=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_INA3221=y
CONFIG_SENSORS_TC74=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP108=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83773G=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=y
# CONFIG_INTEL_TCC_COOLING is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_DA9063_WATCHDOG=y
CONFIG_DA9062_WATCHDOG=y
# CONFIG_WDAT_WDT is not set
CONFIG_WM831X_WATCHDOG=y
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_CADENCE_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_MAX63XX_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_EBC_C384_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_TQMX86_WDT=y
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_INTEL_MEI_WDT=y
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_SFLASH=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_BD9571MWV is not set
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_MADERA is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
# CONFIG_INTEL_SOC_PMIC_MRFLD is not set
CONFIG_MFD_INTEL_LPSS=y
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
CONFIG_MFD_IQS62X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX77843=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6360=y
CONFIG_MFD_MT6397=y
# CONFIG_MFD_MENF21BMC is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RT5033 is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TQMX86=y
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_CS47L24=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_MFD_WCD934X is not set
# CONFIG_MFD_ATC260X_I2C is not set
# end of Multifunction device drivers

CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PG86X is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ARIZONA_LDO1=y
CONFIG_REGULATOR_ARIZONA_MICSUPP=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9062=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL9305 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_LTC3676=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MAX77826=y
CONFIG_REGULATOR_MP8859=y
CONFIG_REGULATOR_MT6311=y
# CONFIG_REGULATOR_MT6315 is not set
CONFIG_REGULATOR_MT6323=y
CONFIG_REGULATOR_MT6358=y
CONFIG_REGULATOR_MT6360=y
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PCA9450=y
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_QCOM_SPMI is not set
CONFIG_REGULATOR_QCOM_USB_VBUS=y
CONFIG_REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_RT4801=y
CONFIG_REGULATOR_RTMV20=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_SKY81452 is not set
CONFIG_REGULATOR_SLG51000=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65086 is not set
# CONFIG_REGULATOR_TPS65132 is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8994=y
CONFIG_REGULATOR_QCOM_LABIBB=y
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_LIRC is not set
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_SHARP_DECODER=y
# CONFIG_IR_MCE_KBD_DECODER is not set
CONFIG_IR_XMP_DECODER=y
CONFIG_IR_IMON_DECODER=y
CONFIG_IR_RCMM_DECODER=y
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_SERIAL is not set
CONFIG_IR_SIR=y
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y
CONFIG_MEDIA_CEC_RC=y
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_CEC_CH7322=y
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_MM=y
CONFIG_DRM_DEBUG_SELFTEST=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS=y
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_VRAM_HELPER=y
CONFIG_DRM_TTM_HELPER=y
CONFIG_DRM_GEM_SHMEM_HELPER=y
CONFIG_DRM_SCHED=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_I2C_NXP_TDA9950=y
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_USERPTR is not set
CONFIG_DRM_AMDGPU=y
CONFIG_DRM_AMDGPU_SI=y
# CONFIG_DRM_AMDGPU_CIK is not set
# CONFIG_DRM_AMDGPU_USERPTR is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_AMD_ACP is not set
# end of ACP (Audio CoProcessor) Configuration

#
# Display Engine Configuration
#
CONFIG_DRM_AMD_DC=y
CONFIG_DRM_AMD_DC_DCN=y
CONFIG_DRM_AMD_DC_HDCP=y
CONFIG_DRM_AMD_DC_SI=y
# CONFIG_DRM_AMD_SECURE_DISPLAY is not set
# end of Display Engine Configuration

# CONFIG_HSA_AMD is not set
CONFIG_DRM_NOUVEAU=y
# CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT is not set
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_NOUVEAU_DEBUG_MMU=y
# CONFIG_NOUVEAU_DEBUG_PUSH is not set
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=y
CONFIG_DRM_VKMS=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=y
CONFIG_DRM_ANALOGIX_DP=y
# end of Display Interface Bridges

CONFIG_DRM_ETNAVIV=y
CONFIG_DRM_ETNAVIV_THERMAL=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_VBOXVIDEO=y
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SM501=y
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_SIMPLE=y
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_KTD253=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_QCOM_WLED=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_SKY81452 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_BACKLIGHT_ARCXCNN=y
# end of Backlight & LCD device support

CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# end of Graphics support

CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_PCM_ELD=y
CONFIG_SND_PCM_IEC958=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQ_DEVICE=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
# CONFIG_SND_PCM_TIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_PROC_FS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_SEQ_MIDI_EVENT=y
CONFIG_SND_SEQ_MIDI=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
# CONFIG_SND_AC97_POWER_SAVE is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
# end of HD-Audio

CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=y
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=y
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
# CONFIG_SND_DICE is not set
CONFIG_SND_OXFW=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_FIREWORKS=y
CONFIG_SND_BEBOB=y
# CONFIG_SND_FIREWIRE_DIGI00X is not set
CONFIG_SND_FIREWIRE_TASCAM=y
CONFIG_SND_FIREWIRE_MOTU=y
CONFIG_SND_FIREFACE=y
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_AC97_BUS=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_ACPI=y
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_SOC_AMD_RENOIR is not set
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_BCM63XX_I2S_WHISTLER=y
CONFIG_SND_DESIGNWARE_I2S=y
# CONFIG_SND_DESIGNWARE_PCM is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
CONFIG_SND_SOC_FSL_SSI=y
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_FSL_MICFIL=y
CONFIG_SND_SOC_FSL_EASRC=y
CONFIG_SND_SOC_FSL_XCVR=y
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=y
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=y
# CONFIG_SND_SOC_INTEL_SKYLAKE is not set
# CONFIG_SND_SOC_INTEL_SKL is not set
# CONFIG_SND_SOC_INTEL_APL is not set
# CONFIG_SND_SOC_INTEL_KBL is not set
# CONFIG_SND_SOC_INTEL_GLK is not set
# CONFIG_SND_SOC_INTEL_CNL is not set
# CONFIG_SND_SOC_INTEL_CFL is not set
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_ACPI_INTEL_MATCH=y
CONFIG_SND_SOC_INTEL_MACH=y
# CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES is not set
CONFIG_SND_SOC_MTK_BTCVSD=y
CONFIG_SND_SOC_SOF_TOPLEVEL=y
# CONFIG_SND_SOC_SOF_PCI is not set
# CONFIG_SND_SOC_SOF_ACPI is not set
CONFIG_SND_SOC_SOF_DEBUG_PROBES=y
# CONFIG_SND_SOC_SOF_DEVELOPER_SUPPORT is not set
# CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

CONFIG_SND_SOC_XILINX_I2S=y
CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER=y
# CONFIG_SND_SOC_XILINX_SPDIF is not set
CONFIG_SND_SOC_XTFPGA_I2S=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_AC97_CODEC=y
CONFIG_SND_SOC_ADAU_UTILS=y
CONFIG_SND_SOC_ADAU1372=y
CONFIG_SND_SOC_ADAU1372_I2C=y
# CONFIG_SND_SOC_ADAU1701 is not set
CONFIG_SND_SOC_ADAU17X1=y
CONFIG_SND_SOC_ADAU1761=y
CONFIG_SND_SOC_ADAU1761_I2C=y
# CONFIG_SND_SOC_ADAU7002 is not set
CONFIG_SND_SOC_ADAU7118=y
CONFIG_SND_SOC_ADAU7118_HW=y
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4118 is not set
CONFIG_SND_SOC_AK4458=y
# CONFIG_SND_SOC_AK4554 is not set
CONFIG_SND_SOC_AK4613=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_AK5558=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_BD28623=y
CONFIG_SND_SOC_BT_SCO=y
CONFIG_SND_SOC_CS35L32=y
CONFIG_SND_SOC_CS35L33=y
# CONFIG_SND_SOC_CS35L34 is not set
CONFIG_SND_SOC_CS35L35=y
CONFIG_SND_SOC_CS35L36=y
CONFIG_SND_SOC_CS42L42=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L51_I2C=y
CONFIG_SND_SOC_CS42L52=y
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS4271_I2C=y
# CONFIG_SND_SOC_CS42XX8_I2C is not set
CONFIG_SND_SOC_CS43130=y
# CONFIG_SND_SOC_CS4341 is not set
CONFIG_SND_SOC_CS4349=y
CONFIG_SND_SOC_CS53L30=y
CONFIG_SND_SOC_CX2072X=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DMIC=y
CONFIG_SND_SOC_HDMI_CODEC=y
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=y
CONFIG_SND_SOC_ES8328=y
CONFIG_SND_SOC_ES8328_I2C=y
CONFIG_SND_SOC_GTM601=y
# CONFIG_SND_SOC_INNO_RK3036 is not set
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98357A=y
# CONFIG_SND_SOC_MAX98504 is not set
CONFIG_SND_SOC_MAX9867=y
CONFIG_SND_SOC_MAX98927=y
# CONFIG_SND_SOC_MAX98373_I2C is not set
CONFIG_SND_SOC_MAX98390=y
# CONFIG_SND_SOC_MAX9860 is not set
CONFIG_SND_SOC_MSM8916_WCD_ANALOG=y
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1789=y
CONFIG_SND_SOC_PCM1789_I2C=y
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
CONFIG_SND_SOC_PCM3060=y
CONFIG_SND_SOC_PCM3060_I2C=y
# CONFIG_SND_SOC_PCM3168A_I2C is not set
CONFIG_SND_SOC_PCM5102A=y
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_RK3328 is not set
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
# CONFIG_SND_SOC_RT5659 is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_REGMAP=y
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIMPLE_MUX is not set
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2305=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_SSM2602_I2C=y
CONFIG_SND_SOC_SSM4567=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_STI_SAS=y
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
CONFIG_SND_SOC_TAS2764=y
CONFIG_SND_SOC_TAS2770=y
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TAS571X is not set
CONFIG_SND_SOC_TAS5720=y
CONFIG_SND_SOC_TAS6424=y
# CONFIG_SND_SOC_TDA7419 is not set
CONFIG_SND_SOC_TFA9879=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC23_I2C=y
CONFIG_SND_SOC_TLV320AIC31XX=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC32X4_I2C=y
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
CONFIG_SND_SOC_TS3A227E=y
CONFIG_SND_SOC_TSCS42XX=y
# CONFIG_SND_SOC_TSCS454 is not set
CONFIG_SND_SOC_UDA1334=y
CONFIG_SND_SOC_WCD9335=y
# CONFIG_SND_SOC_WM8510 is not set
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8524=y
# CONFIG_SND_SOC_WM8580 is not set
CONFIG_SND_SOC_WM8711=y
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
CONFIG_SND_SOC_WM8737=y
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=y
# CONFIG_SND_SOC_WM8753 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8804_I2C=y
CONFIG_SND_SOC_WM8903=y
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8960 is not set
CONFIG_SND_SOC_WM8962=y
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
CONFIG_SND_SOC_ZX_AUD96P22=y
CONFIG_SND_SOC_MAX9759=y
# CONFIG_SND_SOC_MT6351 is not set
CONFIG_SND_SOC_MT6358=y
CONFIG_SND_SOC_MT6660=y
# CONFIG_SND_SOC_NAU8315 is not set
CONFIG_SND_SOC_NAU8540=y
CONFIG_SND_SOC_NAU8810=y
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=y
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SOC_LPASS_WSA_MACRO is not set
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

CONFIG_SND_SIMPLE_CARD_UTILS=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SND_X86=y
# CONFIG_SND_VIRTIO is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_COUGAR=y
CONFIG_HID_MACALLY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CMEDIA=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_VIVALDI=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_ITE is not set
CONFIG_HID_JABRA=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LED=y
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_HIDPP=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MALTRON=y
CONFIG_HID_MAYFLASH=y
CONFIG_HID_REDRAGON=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTI=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PLANTRONICS=y
# CONFIG_HID_PLAYSTATION is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEAM=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set
CONFIG_HID_ALPS=y
# end of Special HID drivers

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER=y
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
CONFIG_AMD_SFH_HID=y
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_ROLE_SWITCH is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_AS3645A is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3532=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_LM3601X=y
CONFIG_LEDS_MT6323=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP50XX=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA955X_GPIO=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_MLXCPLD=y
# CONFIG_LEDS_MLXREG is not set
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set
CONFIG_LEDS_TI_LMU_COMMON=y
CONFIG_LEDS_TPS6105X=y
CONFIG_LEDS_SGM3140=y

#
# Flash and Torch LED drivers
#
# CONFIG_LEDS_RT8515 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_ACTIVITY=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_LEDS_TRIGGER_PANIC=y
# CONFIG_LEDS_TRIGGER_NETDEV is not set
CONFIG_LEDS_TRIGGER_PATTERN=y
CONFIG_LEDS_TRIGGER_AUDIO=y
# CONFIG_LEDS_TRIGGER_TTY is not set
CONFIG_ACCESSIBILITY=y

#
# Speakup console speech
#
# end of Speakup console speech

# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_IE31200=y
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABEOZ9=y
CONFIG_RTC_DRV_ABX80X=y
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF85063=y
# CONFIG_RTC_DRV_PCF85363 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8010=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3028 is not set
CONFIG_RTC_DRV_RV3032=y
# CONFIG_RTC_DRV_RV8803 is not set
CONFIG_RTC_DRV_S5M=y
CONFIG_RTC_DRV_SD3078=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_RV3029_HWMON=y
CONFIG_RTC_DRV_RX6110=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_DA9063 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_FTRTC010=y
CONFIG_RTC_DRV_MT6397=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
CONFIG_DMABUF_HEAPS_SYSTEM=y
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

CONFIG_AUXDISPLAY=y
CONFIG_CHARLCD=y
CONFIG_HD44780_COMMON=y
CONFIG_HD44780=y
CONFIG_IMG_ASCII_LCD=y
CONFIG_LCD2S=y
CONFIG_PARPORT_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
CONFIG_PANEL=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_PRUSS=y
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_MDEV=y
# CONFIG_VFIO_MDEV_DEVICE is not set
CONFIG_VIRT_DRIVERS=y
# CONFIG_VBOXGUEST is not set
# CONFIG_ACRN_HSM is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=y
# CONFIG_VDPA is not set
# CONFIG_VHOST_MENU is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

CONFIG_GREYBUS=y
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=y
CONFIG_WMI_BMOF=y
# CONFIG_HUAWEI_WMI is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
# CONFIG_INTEL_WMI_THUNDERBOLT is not set
CONFIG_MXM_WMI=y
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ACER_WIRELESS is not set
# CONFIG_ACER_WMI is not set
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ASUS_WMI is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
CONFIG_IBM_RTL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_INTEL_ATOMISP2_LED=y
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_VBTN is not set
# CONFIG_MSI_WMI is not set
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_LG_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_SYSTEM76_ACPI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=y
# CONFIG_TOUCHSCREEN_DMI is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
CONFIG_INTEL_SPEED_SELECT_INTERFACE=y
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_UNCORE_FREQ_CONTROL=y
CONFIG_INTEL_PMC_CORE=y
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU=y
CONFIG_INTEL_SCU_PCI=y
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_INTEL_SCU_IPC_UTIL=y
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_MAX9485=y
CONFIG_COMMON_CLK_SI5341=y
# CONFIG_COMMON_CLK_SI5351 is not set
CONFIG_COMMON_CLK_SI544=y
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CS2000_CP=y
# CONFIG_COMMON_CLK_S2MPS11 is not set
CONFIG_XILINX_VCU=y
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_REMOTEPROC_CDEV=y
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_AXP288 is not set
# CONFIG_EXTCON_FSA9480 is not set
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX3355 is not set
CONFIG_EXTCON_MAX77843=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_PTN5150 is not set
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
CONFIG_EXTCON_USBC_TUSB320=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_BUFFER_DMA=y
CONFIG_IIO_BUFFER_DMAENGINE=y
CONFIG_IIO_BUFFER_HW_CONSUMER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=y
CONFIG_IIO_SW_TRIGGER=y
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
CONFIG_ADXL345=y
CONFIG_ADXL345_I2C=y
CONFIG_ADXL372=y
CONFIG_ADXL372_I2C=y
# CONFIG_BMA180 is not set
# CONFIG_BMA400 is not set
CONFIG_BMC150_ACCEL=y
CONFIG_BMC150_ACCEL_I2C=y
# CONFIG_DA280 is not set
CONFIG_DA311=y
CONFIG_DMARD09=y
# CONFIG_DMARD10 is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
CONFIG_MC3230=y
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
CONFIG_MMA7660=y
CONFIG_MMA8452=y
CONFIG_MMA9551_CORE=y
CONFIG_MMA9551=y
# CONFIG_MMA9553 is not set
CONFIG_MXC4005=y
CONFIG_MXC6255=y
CONFIG_STK8312=y
CONFIG_STK8BA50=y
# end of Accelerometers

#
# Analog to digital converters
#
CONFIG_AD7091R5=y
# CONFIG_AD7291 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD799X is not set
CONFIG_AXP20X_ADC=y
CONFIG_AXP288_ADC=y
CONFIG_CC10001_ADC=y
CONFIG_HX711=y
# CONFIG_LP8788_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
CONFIG_LTC2497=y
CONFIG_MAX1363=y
CONFIG_MAX9611=y
CONFIG_MCP3422=y
CONFIG_MEDIATEK_MT6360_ADC=y
CONFIG_NAU7802=y
CONFIG_QCOM_SPMI_IADC=y
# CONFIG_QCOM_SPMI_VADC is not set
# CONFIG_QCOM_SPMI_ADC5 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_XILINX_XADC=y
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=y
CONFIG_ATLAS_EZO_SENSOR=y
CONFIG_BME680=y
CONFIG_BME680_I2C=y
CONFIG_CCS811=y
CONFIG_IAQCORE=y
CONFIG_SCD30_CORE=y
CONFIG_SCD30_I2C=y
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SPS30 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=y

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
# CONFIG_AD5446 is not set
CONFIG_AD5592R_BASE=y
CONFIG_AD5593R=y
CONFIG_AD5686=y
CONFIG_AD5696_I2C=y
CONFIG_CIO_DAC=y
CONFIG_DS4424=y
CONFIG_M62332=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y
CONFIG_TI_DAC5571=y
# end of Digital to analog converters

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
CONFIG_BMG160=y
CONFIG_BMG160_I2C=y
# CONFIG_FXAS21002C is not set
CONFIG_MPU3050=y
CONFIG_MPU3050_I2C=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4404 is not set
CONFIG_MAX30100=y
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
CONFIG_DHT11=y
# CONFIG_HDC100X is not set
CONFIG_HDC2010=y
CONFIG_HTS221=y
CONFIG_HTS221_I2C=y
CONFIG_HTU21=y
CONFIG_SI7005=y
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
CONFIG_BMI160=y
CONFIG_BMI160_I2C=y
# CONFIG_FXOS8700_I2C is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
CONFIG_IIO_ST_LSM6DSX=y
CONFIG_IIO_ST_LSM6DSX_I2C=y
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=y
CONFIG_ADUX1020=y
CONFIG_AL3010=y
# CONFIG_AL3320A is not set
CONFIG_APDS9300=y
CONFIG_APDS9960=y
CONFIG_AS73211=y
CONFIG_BH1750=y
CONFIG_BH1780=y
# CONFIG_CM32181 is not set
CONFIG_CM3232=y
# CONFIG_CM3323 is not set
CONFIG_CM36651=y
# CONFIG_GP2AP002 is not set
CONFIG_GP2AP020A00F=y
CONFIG_IQS621_ALS=y
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_ISL29125=y
CONFIG_JSA1212=y
# CONFIG_RPR0521 is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_LV0104CS=y
CONFIG_MAX44000=y
# CONFIG_MAX44009 is not set
CONFIG_NOA1305=y
# CONFIG_OPT3001 is not set
CONFIG_PA12203001=y
CONFIG_SI1133=y
CONFIG_SI1145=y
CONFIG_STK3310=y
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
CONFIG_US5182D=y
CONFIG_VCNL4000=y
CONFIG_VCNL4035=y
CONFIG_VEML6030=y
CONFIG_VEML6070=y
CONFIG_VL6180=y
CONFIG_ZOPT2201=y
# end of Light sensors

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_AK09911=y
# CONFIG_BMC150_MAGN_I2C is not set
CONFIG_MAG3110=y
CONFIG_MMC35240=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_YAMAHA_YAS530 is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
# end of Inclinometer sensors

# CONFIG_IIO_TEST_FORMAT is not set

#
# Triggers - standalone
#
# CONFIG_IIO_HRTIMER_TRIGGER is not set
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_TIGHTLOOP_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y
# end of Triggers - standalone

#
# Linear and angular position sensors
#
CONFIG_IQS624_POS=y
# end of Linear and angular position sensors

#
# Digital potentiometers
#
CONFIG_AD5272=y
CONFIG_DS1803=y
# CONFIG_MAX5432 is not set
CONFIG_MCP4018=y
CONFIG_MCP4531=y
CONFIG_TPL0102=y
# end of Digital potentiometers

#
# Digital potentiostats
#
CONFIG_LMP91000=y
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
CONFIG_DLHL60D=y
# CONFIG_DPS310 is not set
CONFIG_HP03=y
CONFIG_ICP10100=y
# CONFIG_MPL115_I2C is not set
CONFIG_MPL3115=y
# CONFIG_MS5611 is not set
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
CONFIG_ISL29501=y
CONFIG_LIDAR_LITE_V2=y
CONFIG_MB1232=y
# CONFIG_PING is not set
CONFIG_RFD77402=y
CONFIG_SRF04=y
# CONFIG_SX9310 is not set
CONFIG_SX9500=y
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
CONFIG_VL53L0X_I2C=y
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
CONFIG_IQS620AT_TEMP=y
# CONFIG_MLX90614 is not set
CONFIG_MLX90632=y
CONFIG_TMP006=y
CONFIG_TMP007=y
CONFIG_TSYS01=y
CONFIG_TSYS02D=y
# end of Temperature sensors

CONFIG_NTB=y
CONFIG_NTB_AMD=y
CONFIG_NTB_IDT=y
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
CONFIG_NTB_SWITCHTEC=y
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=y
CONFIG_NTB_TRANSPORT=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
# end of IRQ chip support

CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_USB_LGM_PHY is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
CONFIG_PHY_INTEL_LGM_EMMC=y
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=y
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
CONFIG_ANDROID_BINDER_IPC_SELFTEST=y
# end of Android

CONFIG_DAX=y
CONFIG_NVMEM=y
# CONFIG_NVMEM_SYSFS is not set
CONFIG_NVMEM_SPMI_SDAM=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
# CONFIG_STM is not set
CONFIG_INTEL_TH=y
# CONFIG_INTEL_TH_PCI is not set
# CONFIG_INTEL_TH_ACPI is not set
CONFIG_INTEL_TH_GTH=y
# CONFIG_INTEL_TH_MSU is not set
# CONFIG_INTEL_TH_PTI is not set
CONFIG_INTEL_TH_DEBUG=y
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y
CONFIG_INTERCONNECT=y
CONFIG_COUNTER=y
# CONFIG_INTERRUPT_CNT is not set
CONFIG_MOST=y
CONFIG_MOST_CDEV=y
# CONFIG_MOST_SND is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_VIRTIO_FS=y
CONFIG_OVERLAY_FS=y
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
CONFIG_OVERLAY_FS_INDEX=y
# CONFIG_OVERLAY_FS_NFS_EXPORT is not set
CONFIG_OVERLAY_FS_XINO_AUTO=y
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# end of Caches

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
# CONFIG_HUGETLBFS is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_CRAMFS=y
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
# CONFIG_PSTORE_DEFLATE_COMPRESS is not set
# CONFIG_PSTORE_LZO_COMPRESS is not set
CONFIG_PSTORE_LZ4_COMPRESS=y
CONFIG_PSTORE_LZ4HC_COMPRESS=y
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_LZ4_COMPRESS_DEFAULT is not set
CONFIG_PSTORE_LZ4HC_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="lz4hc"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set
# CONFIG_UNICODE is not set
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_PAGE_TABLE_ISOLATION is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_SECURITY_SAFESETID=y
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
CONFIG_EVM_ADD_XATTRS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
# CONFIG_CRYPTO_RSA is not set
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECC=y
# CONFIG_CRYPTO_ECDH is not set
# CONFIG_CRYPTO_ECDSA is not set
CONFIG_CRYPTO_ECRDSA=y
CONFIG_CRYPTO_SM2=y
CONFIG_CRYPTO_CURVE25519=y
CONFIG_CRYPTO_CURVE25519_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=y
# CONFIG_CRYPTO_SEQIV is not set
# CONFIG_CRYPTO_ECHAINIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_OFB=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y
CONFIG_CRYPTO_NHPOLY1305=y
CONFIG_CRYPTO_NHPOLY1305_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_AVX2=y
CONFIG_CRYPTO_ADIANTUM=y
CONFIG_CRYPTO_ESSIV=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
# CONFIG_CRYPTO_XXHASH is not set
CONFIG_CRYPTO_BLAKE2B=y
# CONFIG_CRYPTO_BLAKE2S is not set
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
CONFIG_CRYPTO_SM3=y
CONFIG_CRYPTO_STREEBOG=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_SM4=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_842 is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y
CONFIG_CRYPTO_ZSTD=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_JITTERENTROPY is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_LIB_BLAKE2S=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_LINEAR_RANGES=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=y
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_PERCENTAGE=0
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACK_HASH_ORDER=20
CONFIG_STRING_SELFTEST=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DYNAMIC_DEBUG_CORE is not set
# CONFIG_SYMBOLIC_ERRNAME is not set
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B=y
CONFIG_STACK_VALIDATION=y
# CONFIG_VMLINUX_MAP is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_POISONING=y
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_KMAP_LOCAL=y
CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_KUNIT_TEST is not set
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SOFTLOCKUP_DETECTOR is not set
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_TIMEKEEPING=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=y
# CONFIG_SCF_TORTURE_TEST is not set
CONFIG_CSD_LOCK_WAIT_DEBUG=y
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
CONFIG_WARN_ALL_UNSEEDED_RANDOM=y
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Debug kernel data structures

CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_RCU_EQS_DEBUG=y
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BOOTTIME_TRACING=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_HIST_TRIGGERS is not set
CONFIG_TRACE_EVENT_INJECT=y
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_TRACE_EVAL_MAP_FILE=y
CONFIG_FTRACE_RECORD_RECURSION=y
CONFIG_FTRACE_RECORD_RECURSION_SIZE=128
CONFIG_RING_BUFFER_RECORD_RECURSION=y
CONFIG_GCOV_PROFILE_FTRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
CONFIG_SYNTH_EVENT_GEN_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
CONFIG_KUNIT_DEBUGFS=y
CONFIG_KUNIT_TEST=y
CONFIG_KUNIT_EXAMPLE_TEST=y
# CONFIG_KUNIT_ALL_TESTS is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_USERCOPY=y
CONFIG_FAIL_FUTEX=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=y
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
CONFIG_BITFIELD_KUNIT=y
CONFIG_RESOURCE_KUNIT_TEST=y
CONFIG_SYSCTL_KUNIT_TEST=y
CONFIG_LIST_KUNIT_TEST=y
# CONFIG_LINEAR_RANGES_TEST is not set
CONFIG_CMDLINE_KUNIT_TEST=y
# CONFIG_BITS_TEST is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_DEBUG_VIRTUAL is not set
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_STACKINIT=y
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
CONFIG_ARCH_USE_MEMTEST=y
CONFIG_MEMTEST=y
# end of Kernel Testing and Coverage
# end of Kernel hacking

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='trinity'
	export testcase='trinity'
	export category='functional'
	export need_memory='300MB'
	export job_origin='trinity-vm.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='vm-snb-8'
	export tbox_group='vm-snb'
	export branch='char-misc/char-misc-linus'
	export commit='dc13cac4862cc68ec74348a80b6942532b7735fa'
	export kconfig='x86_64-randconfig-a015-20210513'
	export repeat_to=6
	export nr_vm=160
	export submit_id='609ed86b935816fc6b3c01b3'
	export job_file='/lkp/jobs/scheduled/vm-snb-8/trinity-group-02-99999-quantal-x86_64-core-20190426.cgz-dc13cac4862cc68ec74348a80b6942532b7735fa-20210515-64619-1vhzs47-4.yaml'
	export id='3afcface50a499c6da44fc0b692222bf6cd401e9'
	export queuer_version='/lkp-src'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig='CONFIG_KVM_GUEST=y'
	export ssh_base_port=23032
	export kernel_cmdline='vmalloc=512M'
	export rootfs='quantal-x86_64-core-20190426.cgz'
	export compiler='gcc-9'
	export enqueue_time='2021-05-15 04:07:07 +0800'
	export _id='609ed870935816fc6b3c01b4'
	export _rt='/result/trinity/group-02-99999/vm-snb/quantal-x86_64-core-20190426.cgz/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/trinity/group-02-99999/vm-snb/quantal-x86_64-core-20190426.cgz/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa/3'
	export scheduler_version='/lkp/lkp/src'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/quantal/quantal-x86_64-core-20190426.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/vm-snb-8/trinity-group-02-99999-quantal-x86_64-core-20190426.cgz-dc13cac4862cc68ec74348a80b6942532b7735fa-20210515-64619-1vhzs47-4.yaml
ARCH=x86_64
kconfig=x86_64-randconfig-a015-20210513
branch=char-misc/char-misc-linus
commit=dc13cac4862cc68ec74348a80b6942532b7735fa
BOOT_IMAGE=/pkg/linux/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa/vmlinuz-5.13.0-rc1-00044-gdc13cac4862c
vmalloc=512M
max_uptime=2100
RESULT_ROOT=/result/trinity/group-02-99999/vm-snb/quantal-x86_64-core-20190426.cgz/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa/3
LKP_SERVER=internal-lkp-server
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa/modules.cgz'
	export bm_initrd='/osimage/pkg/quantal-x86_64-core.cgz/trinity-static-x86_64-x86_64-f93256fb_2019-08-28.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='8fa5da1c3f3b'
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-randconfig-a015-20210513/gcc-9/dc13cac4862cc68ec74348a80b6942532b7735fa/vmlinuz-5.13.0-rc1-00044-gdc13cac4862c'
	export dequeue_time='2021-05-15 04:07:37 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-snb-8/trinity-group-02-99999-quantal-x86_64-core-20190426.cgz-dc13cac4862cc68ec74348a80b6942532b7735fa-20210515-64619-1vhzs47-4.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo

	run_test number=99999 group='group-02' $LKP_SRC/tests/wrapper trinity
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time trinity.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--xXmbgvnjoT4axfJE
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
z/AAAZuYAa36BPQ6oNWxxGf7AgAAAAAEWVo=

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=trinity

Seeding trinity based on x86_64-randconfig-a015-20210513
2021-05-14 20:15:06 chroot --userspec nobody:nogroup / trinity -q -q -l off -s 3463942183 -N 99999
Trinity 2019.06  Dave Jones <davej@codemonkey.org.uk>
shm:0x7f13f7a52000-0x7f140464ed00 (4 pages)
[main] Couldn't chmod tmp/ to 0777.
[main] Using user passed random seed: 3463942183.
[main] Kernel was tainted on startup. Will ignore flags that are already set.
Marking all syscalls as enabled.
[main] 32-bit syscalls: 429 enabled.  64-bit syscalls: 347 enabled, 89 disabled.
[main] Using pid_max = 4096
[main] futex: 0 owner:0
[main] futex: 0 owner:0
[main] futex: 0 owner:0
[main] futex: 0 owner:0
[main] futex: 0 owner:0
[main] Reserved/initialized 5 futexes.
[main] Added 22 filenames from /dev
[main] Added 15474 filenames from /proc
[main] Added 4938 filenames from /sys
[main] Couldn't open socket (27:3:2). Address family not supported by protocol
[main] Couldn't open socket (11:3:3). Address family not supported by protocol
Can't do protocol LLC
[main] Couldn't open socket (41:2:0). Address family not supported by protocol
[main] Couldn't open socket (36:2:1). Address family not supported by protocol
[main] Couldn't open socket (28:2:2). Address family not supported by protocol
Can't do protocol WANPIPE
[main] Couldn't open socket (6:5:0). Address family not supported by protocol
[main] Couldn't open socket (33:2:2). Address family not supported by protocol
Can't do protocol WANPIPE
[main] Couldn't open socket (41:2:0). Address family not supported by protocol
Can't do protocol ECONET
[main] Couldn't open socket (44:3:0). Address family not supported by protocol
[main] Couldn't open socket (2:5:0). Socket type not supported
[main] Couldn't open socket (3:5:1). Address family not supported by protocol
Can't do protocol SECURITY
[main] Couldn't open socket (11:5:3). Address family not supported by protocol
Can't do protocol BRIDGE
[main] Couldn't open socket (16:2:18). Protocol not supported
[main] Couldn't open socket (34:2:5). Address family not supported by protocol
[main] Couldn't open socket (39:5:0). Address family not supported by protocol
[main] Couldn't open socket (20:2:0). Address family not supported by protocol
[main] Couldn't open socket (9:5:0). Address family not supported by protocol
[main] Couldn't open socket (38:5:0). Address family not supported by protocol
[main] Couldn't open socket (39:3:1). Address family not supported by protocol
[main] Couldn't open socket (35:5:0). Address family not supported by protocol
[main] Couldn't open socket (24:2:0). Address family not supported by protocol
[main] Couldn't open socket (35:2:1). Address family not supported by protocol
[main] Couldn't open socket (5:2:0). Address family not supported by protocol
[main] Couldn't open socket (40:2:5). Address family not supported by protocol
[main] Couldn't open socket (39:2:1). Address family not supported by protocol
[main] Couldn't open socket (39:1:1). Address family not supported by protocol
[main] Couldn't open socket (39:1:1). Address family not supported by protocol
[main] Couldn't open socket (9:5:0). Address family not supported by protocol
Can't do protocol NETBEUI
[main] Couldn't open socket (32:5:10). Address family not supported by protocol
[main] Couldn't open socket (23:5:0). Address family not supported by protocol
[main] Couldn't open socket (9:5:0). Address family not supported by protocol
[main] Couldn't open socket (44:3:0). Address family not supported by protocol
[main] Couldn't open socket (11:3:4). Address family not supported by protocol
[main] Couldn't open socket (6:5:0). Address family not supported by protocol
Can't do protocol BRIDGE
[main] Couldn't open socket (10:5:132). Socket type not supported
[main] Couldn't open socket (38:5:0). Address family not supported by protocol
[main] Couldn't open socket (31:3:7). Address family not supported by protocol
Can't do protocol PACKET
[main] Couldn't open socket (4:2:0). Address family not supported by protocol
Can't do protocol BRIDGE
[main] Couldn't open socket (37:1:2). Address family not supported by protocol
[main] Couldn't open socket (36:1:3). Address family not supported by protocol
Can't do protocol BRIDGE
[main] Couldn't open socket (5:3:0). Address family not supported by protocol
[main] Couldn't open socket (16:2:21). Protocol not supported
[main] Couldn't open socket (30:1:0). Address family not supported by protocol
[main] Couldn't open socket (37:1:5). Address family not supported by protocol
[main] Couldn't open socket (29:2:2). Address family not supported by protocol
Can't do protocol NETBEUI
[main] Couldn't open socket (6:5:0). Address family not supported by protocol
Can't do protocol LLC
Can't do protocol KEY
[main] Couldn't open socket (21:5:0). Address family not supported by protocol
[main] Couldn't open socket (4:2:0). Address family not supported by protocol
[main] Couldn't open socket (28:2:4). Address family not supported by protocol
Can't do protocol SNA
[main] Couldn't open socket (34:2:3). Address family not supported by protocol
Can't do protocol SECURITY
Can't do protocol SECURITY
[main] Couldn't open socket (39:2:1). Address family not supported by protocol
Can't do protocol KEY
[main] Couldn't open socket (31:3:7). Address family not supported by protocol
Can't do protocol KEY
[main] Couldn't open socket (3:3:0). Address family not supported by protocol
Can't do protocol PACKET
[main] Couldn't open socket (38:5:0). Address family not supported by protocol
Can't do protocol KEY
[main] Couldn't open socket (2:6:33). Socket type not supported
[main] Enabled 14/14 fd providers. initialized:14.
[main] Error opening tracing_on : Permission denied
[child0:1592] Tried 8 32-bit syscalls unsuccessfully. Disabling all 32-bit syscalls.
[main] 11287 iterations. [F:7428 S:3853 HI:1522]
[main] 22301 iterations. [F:14641 S:7653 HI:1522]
[main] 32764 iterations. [F:21589 S:11172 HI:2086]
[main] 43582 iterations. [F:28742 S:14838 HI:3282]
[main] 54949 iterations. [F:36220 S:18726 HI:4372]
[main] 65139 iterations. [F:42898 S:22241 HI:4372]
[main] 75685 iterations. [F:49902 S:25788 HI:4372]
[main] 86406 iterations. [F:57002 S:29420 HI:4372]
[main] 96555 iterations. [F:63630 S:32946 HI:4372]
[main] Reached limit 99999. Telling children to exit.
[main] exit_reason=2, but 2 children still running.
[main] Bailing main loop because Completed maximum number of operations..
[main] Ran 99999 syscalls. Successes: 34130  Failures: 65893

--xXmbgvnjoT4axfJE--
