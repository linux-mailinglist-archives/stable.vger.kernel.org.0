Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEC81BF315
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD3IlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 04:41:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:57783 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgD3IlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 04:41:08 -0400
IronPort-SDR: bOFPn5AVG5eBPd6ZA3Js5TiQuiC4yrSYPTE0um6O1lhwR5hRnX54iEM/6RRIBSBfhd6mFg2S4x
 F7LTu9tr+D9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:07 -0700
IronPort-SDR: +SbNMsauFiB5ELoBy32LzdT63RXPMNZtx+Zg3uwJQnCzI6godX+TRUBLmo9Zb6Ea60gLXsF8zn
 QsPVZw6I4O/Q==
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="405330939"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:07 -0700
Subject: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Thu, 30 Apr 2020 01:24:58 -0700
Message-ID: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v1:
- Rename memcpy_mcsafe() to copy_safe() since the x86-machine-check
  specifics have already been de-emphasized in a previous commit and are
  further de-emphasized by these changes. (Linus)

- Move copy_safe() out-of-line since it no longer reverts to plain
  memcpy (Linus)

- Move copy_safe() to its own stand-alone compilation unit where it no
  longer entangles with arch/x86/lib/memcpy_64.S. This also allows perf
  to stop tracking ongoing updates to that file due to copy_safe()
  updates. (Linus)

- Move the PowerPC implementation over to the new name.

[1]: http://lore.kernel.org/r/158654083112.1572482.8944305411228188871.stgit@dwillia2-desk3.amr.corp.intel.com

---

The primary motivation to go touch memcpy_mcsafe() is that the existing
benefit of doing slow and careful copies is obviated on newer CPUs. That
fact solves the problem of needing to detect machine-check recovery
capability. Now the old "mcsafe_key" opt-in to careful copying can be made
an opt-out from the default fast copy implementation.

The discussion with Linus further made clear that this facility had
already lost its x86-machine-check specificity starting with commit
2c89130a56a ("x86/asm/memcpy_mcsafe: Add write-protection-fault
handling"). The new changes to not require a "careful copy" further
de-emphasizes the role that x86-MCA plays in the implementation to just
one more source of recoverable trap during the operation.

With the above realizations the name "mcsafe" is no longer accurate and
copy_safe() is proposed as its replacement. x86 grows a copy_safe_fast()
implementation as a default implementation that is independent of
detecting the presence of x86-MCA.

---

Dan Williams (2):
      copy_safe: Rename memcpy_mcsafe() to copy_safe()
      x86/copy_safe: Introduce copy_safe_fast()


 arch/powerpc/Kconfig                               |    2 
 arch/powerpc/include/asm/string.h                  |    2 
 arch/powerpc/include/asm/uaccess.h                 |    4 
 arch/powerpc/lib/Makefile                          |    2 
 arch/powerpc/lib/copy_safe.S                       |    4 
 arch/x86/Kconfig                                   |    2 
 arch/x86/Kconfig.debug                             |    2 
 arch/x86/include/asm/copy_safe.h                   |   18 ++
 arch/x86/include/asm/copy_safe_test.h              |   75 +++++++++
 arch/x86/include/asm/mcsafe_test.h                 |   75 ---------
 arch/x86/include/asm/string_64.h                   |   32 ----
 arch/x86/include/asm/uaccess_64.h                  |   21 ---
 arch/x86/kernel/cpu/mce/core.c                     |    9 -
 arch/x86/kernel/quirks.c                           |   10 -
 arch/x86/lib/Makefile                              |    1 
 arch/x86/lib/copy_safe.c                           |   66 ++++++++
 arch/x86/lib/copy_safe_64.S                        |  163 ++++++++++++++++++++
 arch/x86/lib/memcpy_64.S                           |  115 --------------
 arch/x86/lib/usercopy_64.c                         |   21 ---
 drivers/md/dm-writecache.c                         |   12 +
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/pmem.c                              |    6 -
 include/linux/string.h                             |   17 +-
 include/linux/uio.h                                |   10 +
 lib/Kconfig                                        |    2 
 lib/iov_iter.c                                     |   36 ++--
 tools/arch/x86/include/asm/copy_safe_test.h        |   13 ++
 tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
 tools/arch/x86/lib/memcpy_64.S                     |  115 --------------
 tools/objtool/check.c                              |    5 -
 tools/perf/bench/Build                             |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ---
 tools/testing/nvdimm/test/nfit.c                   |   49 +++---
 .../testing/selftests/powerpc/copyloops/.gitignore |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
 .../selftests/powerpc/copyloops/copy_safe.S        |    0 
 36 files changed, 429 insertions(+), 508 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_safe.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_safe.h
 create mode 100644 arch/x86/include/asm/copy_safe_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_safe.c
 create mode 100644 arch/x86/lib/copy_safe_64.S
 create mode 100644 tools/arch/x86/include/asm/copy_safe_test.h
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 rename tools/testing/selftests/powerpc/copyloops/{memcpy_mcsafe_64.S => copy_safe.S} (100%)

base-commit: b8dcd632c06b8706d22934f9bf9bf16a42b1ecc7
