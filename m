Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6028446B
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 05:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgJFD6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 23:58:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:7291 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgJFD6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 23:58:46 -0400
IronPort-SDR: z9qayJkDs50ZYqNHXP7KRTV62KmCtooOZbh5OI890Cwik4kfqBZ/VZtWwFoxVv4VDhblB+J+pP
 FxXSrPoTZ0cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="164478411"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="164478411"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 20:58:42 -0700
IronPort-SDR: cKWN0VRgTwU820TpT6TxhC135MCOp8TbkJe/wvY9/BRBwxNybA41vDUyBD3kI1Z/aZaZ2bD/vf
 +Tl2UqQUlDJA==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="341825674"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 20:58:39 -0700
Subject: [PATCH v10 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user,
 kernel}
From:   Dan Williams <dan.j.williams@intel.com>
To:     bp@alien8.de
Cc:     Tony Luck <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        0day robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, x86@kernel.org
Date:   Mon, 05 Oct 2020 20:40:10 -0700
Message-ID: <160195561059.2163339.8787400120285484198.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v9 [1]:

- (Boris) Compile out the copy_mc_fragile() infrastructure in the
  CONFIG_X86_MCE=n case.

  This had several knock-on effects. The proposed x86: copy_mc_generic()
  was internally checking for X86_FEATURE_ERMS and falling back to
  copy_mc_fragile(), however that fallback is not possible in the
  CONFIG_X86_MCE=n case when copy_mc_fragile() is compiled out. Instead,
  copy_mc_to_user() is rewritten similar to copy_user_generic() that walks
  through several fallback implementations copy_mc_fragile ->
  copy_mc_enhanced_fast_string (new) -> copy_user_generic (no #MC
  recovery).

[1]: http://lore.kernel.org/r/160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com

---

Hi Boris,

I gave this some soak time over the weekend for the robots to chew on
for regressions. No reports, and the updates pass my testing. Please
consider including this in your updates for v5.10, and thanks for
offering to pick this up.

---

The motivations to go rework memcpy_mcsafe() are that the benefit of
doing slow and careful copies is obviated on newer CPUs, and that the
current opt-in list of cpus to instrument recovery is broken relative to
those cpus.  There is no need to keep an opt-in list up to date on an
ongoing basis if pmem/dax operations are instrumented for recovery by
default. With recovery enabled by default the old "mcsafe_key" opt-in to
careful copying can be made a "fragile" opt-out. Where the "fragile"
list takes steps to not consume poison across cachelines.

The discussion with Linus made clear that the current "_mcsafe" suffix
was imprecise to a fault. The operations that are needed by pmem/dax are
to copy from a source address that might throw #MC to a destination that
may write-fault, if it is a user page. So copy_to_user_mcsafe() becomes
copy_mc_to_user() to indicate the separate precautions taken on source
and destination. copy_mc_to_kernel() is introduced as a non-SMAP version
that does not expect write-faults on the destination, but is still
prepared to abort with an error code upon taking #MC.

---

Dan Williams (2):
      x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user,kernel}()
      x86/copy_mc: Introduce copy_mc_enhanced_fast_string()


 arch/powerpc/Kconfig                               |    2 
 arch/powerpc/include/asm/string.h                  |    2 
 arch/powerpc/include/asm/uaccess.h                 |   40 +++--
 arch/powerpc/lib/Makefile                          |    2 
 arch/powerpc/lib/copy_mc_64.S                      |    4 
 arch/x86/Kconfig                                   |    2 
 arch/x86/Kconfig.debug                             |    2 
 arch/x86/include/asm/copy_mc_test.h                |   75 +++++++++
 arch/x86/include/asm/mce.h                         |    9 +
 arch/x86/include/asm/mcsafe_test.h                 |   75 ---------
 arch/x86/include/asm/string_64.h                   |   32 ----
 arch/x86/include/asm/uaccess.h                     |    9 +
 arch/x86/include/asm/uaccess_64.h                  |   20 --
 arch/x86/kernel/cpu/mce/core.c                     |    8 -
 arch/x86/kernel/quirks.c                           |   10 -
 arch/x86/lib/Makefile                              |    1 
 arch/x86/lib/copy_mc.c                             |   96 ++++++++++++
 arch/x86/lib/copy_mc_64.S                          |  163 ++++++++++++++++++++
 arch/x86/lib/memcpy_64.S                           |  115 --------------
 arch/x86/lib/usercopy_64.c                         |   21 ---
 drivers/md/dm-writecache.c                         |   15 +-
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/pmem.c                              |    6 -
 include/linux/string.h                             |    9 -
 include/linux/uaccess.h                            |   13 ++
 include/linux/uio.h                                |   10 +
 lib/Kconfig                                        |    7 +
 lib/iov_iter.c                                     |   48 +++---
 tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
 tools/arch/x86/lib/memcpy_64.S                     |  115 --------------
 tools/objtool/check.c                              |    5 -
 tools/perf/bench/Build                             |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ---
 tools/testing/nvdimm/test/nfit.c                   |   49 +++---
 .../testing/selftests/powerpc/copyloops/.gitignore |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
 .../selftests/powerpc/copyloops/copy_mc_64.S       |    1 
 .../selftests/powerpc/copyloops/memcpy_mcsafe_64.S |    1 
 38 files changed, 484 insertions(+), 531 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_mc_64.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_mc_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_mc.c
 create mode 100644 arch/x86/lib/copy_mc_64.S
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 create mode 120000 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
 delete mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S

base-commit: a1b8638ba1320e6684aa98233c15255eb803fac7
