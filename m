Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86641F001C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 20:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFESxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 14:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgFESxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 14:53:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3434BC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 11:53:10 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so7448884ejn.10
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wXRpz2lO6/EOGfJ7wZsfK0zV1iD673YONFZjRSp4YU=;
        b=iKWRTV0fZquwi8iYFrkllclkIkc7zyKFSFgwvw7q0Imsb4KMrLzP4VVUhGt1LuBa8T
         Vw++I+nmdtz98fAE9YJdNN5t+SVzWVZ8qDJO5jU8NN3ZKmONh8Qx4Iu77rQLTQ5uejMZ
         D0BFVTZYTCtAm3LEA2zTLSO9V57sDTGidb2VhiM2fRaH/37KPY7alcjVDyuS9G8qaPcU
         vlN2VuZl/iwFq+Q+8fq/Q57B9zZLoWbF/pW2slR7RMoxbdOy3DWBdPx/sQrX5DDjPo6Y
         phhV46CTXBvrevlVtRXv/trhbz9NqPDDyN4wspBdd6grTMSBSy4kOx1ngMJYHCFJAjJQ
         66Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wXRpz2lO6/EOGfJ7wZsfK0zV1iD673YONFZjRSp4YU=;
        b=D/ZTl7Sf/XKoojm5mWfpyuHyn5f1RtIuvcbiD+bpAplo0ALiZDaBiwjVsWR4RCf6mc
         6MESBdmTHdDDn1if7GM56ATPI8r5BZRlfVhCWJ8xHII4LSSt8NjV1GzL5WjOaRyEVwVt
         FkgqkUEOMpHKYfvvOJOJmjPeYf4M2iuIOOk826jNZ0Ii237ZqezqimrXOV6RbbnRWsZl
         47F8atTR+IUI7C7MtY6D2VpR8hIvViKkL3VPTbfyWTXC3ZriRu8q6TIaRR5BAKiunk6r
         MAD4HUpSWFjA8iEG6U/dZ/U7lROcR1+A6+9IR/uw50TZ9jEIfDhPKz12SAO6cO5T/pLs
         HL4w==
X-Gm-Message-State: AOAM530zCda05EaprwumbBv+xl8au6slhzHFdxcn6ejeNi+l2LC8kw+l
        rA5PS4Pm1eA/pZK5xlE4uLfSBlKnVNcS4Uddl5sieg==
X-Google-Smtp-Source: ABdhPJxs7csibmk0TeBntMIz0H3+ay+u3BDdAOdGFjfKRP1Y9+NBaeTwCa5nIEk5ZkPdDkGUIIzHH5GRRsX6FrAoLps=
X-Received: by 2002:a17:906:468e:: with SMTP id a14mr2823668ejr.124.1591383188826;
 Fri, 05 Jun 2020 11:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <159062136234.2192412.7285856919306307817.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159062136234.2192412.7285856919306307817.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 5 Jun 2020 11:52:57 -0700
Message-ID: <CAPcyv4j6QNheK-mmgZ9dTAY_yaX5hU8_wJCpmshJgCxbt8eyOg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Tony Luck <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 4:32 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Changes since v4 [1]:
> - Fix up .gitignore for PowerPC test artifacts (Michael)
>
> - Collect Michael's Ack.
>
> [1]: http://lore.kernel.org/r/159010126119.975921.6614194205409771984.stgit@dwillia2-desk3.amr.corp.intel.com
>
> ---
>
> The primary motivation to go touch memcpy_mcsafe() is that the existing
> benefit of doing slow "handle with care" copies is obviated on newer
> CPUs. With that concern lifted it also obviates the need to continue to
> update the MCA-recovery capability detection code currently gated by
> "mcsafe_key". Now the old "mcsafe_key" opt-in to perform the copy with
> concerns for recovery fragility can instead be made an opt-out from the
> default fast copy implementation (enable_copy_mc_fragile()).
>
> The discussion with Linus on the first iteration of this patch
> identified that memcpy_mcsafe() was misnamed relative to its usage. The
> new names copy_mc_to_user() and copy_mc_to_kernel() clearly indicate the
> intended use case and lets the architecture organize the implementation
> accordingly.
>
> For both powerpc and x86 a copy_mc_generic() implementation is added as
> the backend for these interfaces.
>
> Patches are relative to tip/master.

I have not heard any additional feedback, or seen tip-bot traffic. Is
this still under consideration for v5.8? The kernel's behavior on new
platforms regresses without this, recoverable #MC escalates to panic.


>
> ---
>
> Dan Williams (2):
>       x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user,kernel}()
>       x86/copy_mc: Introduce copy_mc_generic()
>
>
>  arch/powerpc/Kconfig                               |    2
>  arch/powerpc/include/asm/string.h                  |    2
>  arch/powerpc/include/asm/uaccess.h                 |   40 +++--
>  arch/powerpc/lib/Makefile                          |    2
>  arch/powerpc/lib/copy_mc_64.S                      |    4
>  arch/x86/Kconfig                                   |    2
>  arch/x86/Kconfig.debug                             |    2
>  arch/x86/include/asm/copy_mc_test.h                |   75 +++++++++
>  arch/x86/include/asm/mcsafe_test.h                 |   75 ---------
>  arch/x86/include/asm/string_64.h                   |   32 ----
>  arch/x86/include/asm/uaccess.h                     |   21 +++
>  arch/x86/include/asm/uaccess_64.h                  |   20 --
>  arch/x86/kernel/cpu/mce/core.c                     |    8 -
>  arch/x86/kernel/quirks.c                           |    9 -
>  arch/x86/lib/Makefile                              |    1
>  arch/x86/lib/copy_mc.c                             |   64 ++++++++
>  arch/x86/lib/copy_mc_64.S                          |  165 ++++++++++++++++++++
>  arch/x86/lib/memcpy_64.S                           |  115 --------------
>  arch/x86/lib/usercopy_64.c                         |   21 ---
>  drivers/md/dm-writecache.c                         |   15 +-
>  drivers/nvdimm/claim.c                             |    2
>  drivers/nvdimm/pmem.c                              |    6 -
>  include/linux/string.h                             |    9 -
>  include/linux/uaccess.h                            |    9 +
>  include/linux/uio.h                                |   10 +
>  lib/Kconfig                                        |    7 +
>  lib/iov_iter.c                                     |   43 +++--
>  tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
>  tools/arch/x86/lib/memcpy_64.S                     |  115 --------------
>  tools/objtool/check.c                              |    5 -
>  tools/perf/bench/Build                             |    1
>  tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ---
>  tools/testing/nvdimm/test/nfit.c                   |   48 +++---
>  .../testing/selftests/powerpc/copyloops/.gitignore |    2
>  tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
>  .../selftests/powerpc/copyloops/copy_mc_64.S       |    1
>  .../selftests/powerpc/copyloops/memcpy_mcsafe_64.S |    1
>  37 files changed, 451 insertions(+), 526 deletions(-)
>  rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_mc_64.S} (98%)
>  create mode 100644 arch/x86/include/asm/copy_mc_test.h
>  delete mode 100644 arch/x86/include/asm/mcsafe_test.h
>  create mode 100644 arch/x86/lib/copy_mc.c
>  create mode 100644 arch/x86/lib/copy_mc_64.S
>  delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
>  delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
>  create mode 120000 tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
>  delete mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
>
> base-commit: 229aaa8c059f2c908e0561453509f996f2b2d5c4
