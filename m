Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE71D275E0F
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 18:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIWQ7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 12:59:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:12857 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgIWQ7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 12:59:48 -0400
IronPort-SDR: txJ/YYDS6ouwuY3uQgkkdYWP26pi7gtg+SeHMPaPpc0y5O/Ax+4X+00i6d15q7bMFGkoTVTUQZ
 0d8YdzXOiluA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158346693"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="158346693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:59:47 -0700
IronPort-SDR: Uk3FpZWtjC6MxaY2DpATud/gCLigyWCbeA2NfdUXbwu2fTZl13//C7v+skd5M53i4aVDYwi05+
 R65xu4Hv6T4Q==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="511067966"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:59:47 -0700
Subject: [PATCH v9 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
From:   Dan Williams <dan.j.williams@intel.com>
To:     mingo@redhat.com
Cc:     Tony Luck <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        0day robot <lkp@intel.com>, tglx@linutronix.de, x86@kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        jack@suse.cz
Date:   Wed, 23 Sep 2020 09:41:26 -0700
Message-ID: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v8 [1]:
- Rebase on v5.9-rc6

- Fix a performance regression in the x86 copy_mc_to_user()
  implementation that was duplicating copies in the "fragile" case.

- Refreshed the cover letter.

[1]: http://lore.kernel.org/r/159630255616.3143511.18110575960499749012.stgit@dwillia2-desk3.amr.corp.intel.com

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
and destination. copy_mc_to_kernel() is introduced as a version that
does not expect write-faults on the destination, but is still prepared
to abort with an error code upon taking #MC.

These patches have received a kbuild-robot build success notification
across 114 configs, the rebase to v5.9-rc6 did not encounter any
conflicts, and the merge with tip/master is conflict-free.

---

Dan Williams (2):
      x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user,kernel}()
      x86/copy_mc: Introduce copy_mc_generic()


 arch/powerpc/Kconfig                               |    2 
 arch/powerpc/include/asm/string.h                  |    2 
 arch/powerpc/include/asm/uaccess.h                 |   40 +++--
 arch/powerpc/lib/Makefile                          |    2 
 arch/powerpc/lib/copy_mc_64.S                      |    4 
 arch/x86/Kconfig                                   |    2 
 arch/x86/Kconfig.debug                             |    2 
 arch/x86/include/asm/copy_mc_test.h                |   75 +++++++++
 arch/x86/include/asm/mcsafe_test.h                 |   75 ---------
 arch/x86/include/asm/string_64.h                   |   32 ----
 arch/x86/include/asm/uaccess.h                     |   21 +++
 arch/x86/include/asm/uaccess_64.h                  |   20 --
 arch/x86/kernel/cpu/mce/core.c                     |    8 -
 arch/x86/kernel/quirks.c                           |    9 -
 arch/x86/lib/Makefile                              |    1 
 arch/x86/lib/copy_mc.c                             |   65 ++++++++
 arch/x86/lib/copy_mc_64.S                          |  165 ++++++++++++++++++++
 arch/x86/lib/memcpy_64.S                           |  115 --------------
 arch/x86/lib/usercopy_64.c                         |   21 ---
 drivers/md/dm-writecache.c                         |   15 +-
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/pmem.c                              |    6 -
 include/linux/string.h                             |    9 -
 include/linux/uaccess.h                            |    9 +
 include/linux/uio.h                                |   10 +
 lib/Kconfig                                        |    7 +
 lib/iov_iter.c                                     |   43 +++--
 tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
 tools/arch/x86/lib/memcpy_64.S                     |  115 --------------
 tools/objtool/check.c                              |    5 -
 tools/perf/bench/Build                             |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ---
 tools/testing/nvdimm/test/nfit.c                   |   48 +++---
 .../testing/selftests/powerpc/copyloops/.gitignore |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
 .../selftests/powerpc/copyloops/copy_mc_64.S       |    1 
 .../selftests/powerpc/copyloops/memcpy_mcsafe_64.S |    1 
 37 files changed, 452 insertions(+), 526 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_mc_64.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_mc_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_mc.c
 create mode 100644 arch/x86/lib/copy_mc_64.S
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 create mode 120000 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
 delete mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S

base-commit: ba4f184e126b751d1bffad5897f263108befc780
