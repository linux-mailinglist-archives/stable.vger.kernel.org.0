Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1627DC19
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgI2WcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgI2WcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 18:32:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77C1C0613D0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 15:32:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z23so17746948ejr.13
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPj2R3F4bxqgWuYiH34pQvZpv0RaH6NFTUkbHCW2p24=;
        b=dlbxcu6TRRkiu15Lu8VAqKieaUpIrOtrMwMHoWuctx5bXT47yPVoIb2AYEVj6he4/p
         Vhi6jdQ09t8NtO7qV+ACUkt6R5KVg0ZLeemzdtWl8RPPfGqROOrFjR8f7XzWBqY3QYwZ
         VGcpngSn4fNVmQRiYp875EXhhC36oTIbb4BP4vBJFwrFFHZMKkcg0oW+hh42925gA1It
         /yusSQS+FDrByoROPjy4Tf4Y6ir+dOqZlTeMJG0f8zvZ+4W0ybAJ3t7+VAig/qZ27p0H
         NHTmwgcOomfZfulx1lWf74NiIjVVXUuGHZv0vLy8YXEdPZ+0QedQSMQO3PNJAhvdmo2w
         mvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPj2R3F4bxqgWuYiH34pQvZpv0RaH6NFTUkbHCW2p24=;
        b=NpKJKyQejyYd+bzg4QWCSync9XHW0GjymR+rCf9C5rqr3QUwFHcMpd+8m/sfWUd432
         VOPXPObCozFpFbahhqTlmfImQodOiHrpn5d+xTGZOfmjYGtHzjOxRAX15S2RUXN+edCF
         DG3hS10sPeEBrJu7XoJl/u4M056il2FPy1jeP2b7OUcjMbzx7yJ1kPFkWYWWdrokpHQm
         bNpXpxBT3jBseImeAalaZhVRGtujVAGDa+Wq2DJO3shbH1dNUv3yuRBq5/nGHYA+yQ5d
         RMH0Idl6aZKWpA+JRG59gkvBr87e05I1tIzsjXBdAwW61cnztKJ8gz4p8Un31zXsTomD
         L20A==
X-Gm-Message-State: AOAM532F8rost8aBDk5xwQp9h6JxErjGZPORYtrIpyk+fUHVFU+H9eQM
        PZ5jvLiTZWmEem1k4+5KMQuozdLDm/RIoQ8uVEdwzg==
X-Google-Smtp-Source: ABdhPJxIoGzCMAKA2A6ialSkF44G3KGdVwp0RfJwgDGxsk23JfoVaerVrZqmnTrvnRDKWsGE4HI1SSEgws/MJmeF6Y4=
X-Received: by 2002:a17:906:8143:: with SMTP id z3mr5966464ejw.323.1601418738476;
 Tue, 29 Sep 2020 15:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 29 Sep 2020 15:32:07 -0700
Message-ID: <CAPcyv4iPuRWSv_do_h8stU0-SiWxtKkQWvzBEU+78fDE6VffmA@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] Renovate memcpy_mcsafe with copy_mc_to_{user, kernel}
To:     Ingo Molnar <mingo@redhat.com>
Cc:     Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        0day robot <lkp@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 10:00 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Changes since v8 [1]:
> - Rebase on v5.9-rc6
>
> - Fix a performance regression in the x86 copy_mc_to_user()
>   implementation that was duplicating copies in the "fragile" case.
>
> - Refreshed the cover letter.
>
> [1]: http://lore.kernel.org/r/159630255616.3143511.18110575960499749012.stgit@dwillia2-desk3.amr.corp.intel.com
>

Given that Linus was the primary source of review feedback on these
patches and a version of them have been soaking in -next with only a
minor conflict report with vfs.git for the entirety of the v5.9-rc
cycle (left there inadvertently while I was on leave), any concerns
with me sending this to Linus directly during the merge window?

>
> The motivations to go rework memcpy_mcsafe() are that the benefit of
> doing slow and careful copies is obviated on newer CPUs, and that the
> current opt-in list of cpus to instrument recovery is broken relative to
> those cpus.  There is no need to keep an opt-in list up to date on an
> ongoing basis if pmem/dax operations are instrumented for recovery by
> default. With recovery enabled by default the old "mcsafe_key" opt-in to
> careful copying can be made a "fragile" opt-out. Where the "fragile"
> list takes steps to not consume poison across cachelines.
>
> The discussion with Linus made clear that the current "_mcsafe" suffix
> was imprecise to a fault. The operations that are needed by pmem/dax are
> to copy from a source address that might throw #MC to a destination that
> may write-fault, if it is a user page. So copy_to_user_mcsafe() becomes
> copy_mc_to_user() to indicate the separate precautions taken on source
> and destination. copy_mc_to_kernel() is introduced as a version that
> does not expect write-faults on the destination, but is still prepared
> to abort with an error code upon taking #MC.
>
> These patches have received a kbuild-robot build success notification
> across 114 configs, the rebase to v5.9-rc6 did not encounter any
> conflicts, and the merge with tip/master is conflict-free.
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
>  arch/x86/lib/copy_mc.c                             |   65 ++++++++
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
>  37 files changed, 452 insertions(+), 526 deletions(-)
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
> base-commit: ba4f184e126b751d1bffad5897f263108befc780
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
