Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639221DA489
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 00:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgESW2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 18:28:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:14393 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgESW2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 18:28:44 -0400
IronPort-SDR: tM64yaY0VVmOTrgLbsyZPHkwBBfokNq25XixByctoKhCrmsrRN9cYFmxrWySPt5NGS8sKZn5IB
 Y7yA+o2ocXMA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:28:43 -0700
IronPort-SDR: K4gouk3kgt6TlmETPZvcuoH4GKDKD8iWteFL3OMV34DttzTKYx2Vm86O3xgzK00SdxVPRNm6aX
 xlKyDYPFpfmg==
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="253395613"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:28:43 -0700
Subject: [PATCH v3 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     Tony Luck <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Date:   Tue, 19 May 2020 15:12:31 -0700
Message-ID: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v2 [1]:
- Replace the non-descriptive copy_safe() with copy_mc_to_user() and
  copy_mc_to_kernel() several code organization cleanups resulted from
  this rename, which further proves the point that the name deeply
  matters for maintainability in this case. (Linus)

- Do not use copy_user_generic() as the generic x86 backend for
  copy_mc_to_user() since the #MC handler explicitly wants the exception
  to be trapped by a _ASM_EXTABLE_FAULT handler. (Vivek).

- Rename copy_safe_slow() to copy_mc_fragile() to better indicate what
  the implementation is handling. copy_safe_fast() is replaced with
  copy_mc_generic().

---

The primary motivation to go touch memcpy_mcsafe() is that the existing
benefit of doing slow "handle with care" copies is obviated on newer
CPUs. With that concern lifted it also obviates the need to continue to
update the MCA-recovery capability detection code currently gated by
"mcsafe_key". Now the old "mcsafe_key" opt-in to perform the copy with
concerns for recovery fragility can instead be made an opt-out from the
default fast copy implementation (enable_copy_mc_fragile()).

The discussion with Linus on the first iteration of this patch
identified that memcpy_mcsafe() was misnamed relative to its usage. The
new names copy_mc_to_user() and copy_mc_to_kernel() clearly indicate the
intended use case and lets the architecture organize the implementation
accordingly.

For both powerpc and x86 a copy_mc_generic() implementation is added as
the backend for these interfaces.

Patches are relative to tip/master.

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
 arch/x86/include/asm/uaccess_64.h                  |   35 ++--
 arch/x86/kernel/cpu/mce/core.c                     |    8 -
 arch/x86/kernel/quirks.c                           |    9 -
 arch/x86/lib/Makefile                              |    1 
 arch/x86/lib/copy_mc.c                             |   64 ++++++++
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
 tools/arch/x86/include/asm/copy_safe_test.h        |   13 ++
 tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
 tools/arch/x86/lib/memcpy_64.S                     |  115 --------------
 tools/objtool/check.c                              |    5 -
 tools/perf/bench/Build                             |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ---
 tools/testing/nvdimm/test/nfit.c                   |   48 +++---
 .../testing/selftests/powerpc/copyloops/.gitignore |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
 .../testing/selftests/powerpc/copyloops/copy_mc.S  |    0 
 36 files changed, 460 insertions(+), 522 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_mc_64.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_mc_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_mc.c
 create mode 100644 arch/x86/lib/copy_mc_64.S
 create mode 100644 tools/arch/x86/include/asm/copy_safe_test.h
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 rename tools/testing/selftests/powerpc/copyloops/{memcpy_mcsafe_64.S => copy_mc.S} (100%)

base-commit: bba413deb1065f1291cb1f366247513f11215520
