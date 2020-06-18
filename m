Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821551FDA90
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 02:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgFRAsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 20:48:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:25710 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbgFRAsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 20:48:22 -0400
IronPort-SDR: K2ltQazXPCRWB1aCIps492brO734W8bHIwlQctbNljMm4NxnPOQhQMRcI6C4dh7e8Ruh1YKpiT
 +yQvCij0FUpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 17:48:12 -0700
IronPort-SDR: gXk4D2WWwT4jqx+vmM9RPAqxO0zYH4gaaNTYWhJpEgsbd2LE9zw6yKYA0V83WZQ/+OANIC/cE5
 C7zL4y7we1QA==
X-IronPort-AV: E=Sophos;i="5.73,524,1583222400"; 
   d="scan'208";a="262752143"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 17:48:12 -0700
Subject: [PATCH v6 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
From:   Dan Williams <dan.j.williams@intel.com>
To:     akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com
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
Date:   Wed, 17 Jun 2020 17:31:58 -0700
Message-ID: <159244031857.1107636.5054974045023236143.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No changes since v5 [1], just rebased to v5.8-rc1. No comments since
that posting back at the end of May either, will continue to re-post
weekly, I am otherwise at a loss for what else to do to move this
forward. Should it go through Andrew since it's across PPC and x86?
Thanks again to Michael for the PPC acks.

[1]: http://lore.kernel.org/r/159062136234.2192412.7285856919306307817.stgit@dwillia2-desk3.amr.corp.intel.com

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

Patches are relative to v5.8-rc1. It has a recent build success
notification from the kbuild robot and is passing local nvdimm tests.

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
 37 files changed, 451 insertions(+), 526 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_mc_64.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_mc_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_mc.c
 create mode 100644 arch/x86/lib/copy_mc_64.S
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 create mode 120000 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
 delete mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S

base-commit: b3a9e3b9622ae10064826dccb4f7a52bd88c7407
