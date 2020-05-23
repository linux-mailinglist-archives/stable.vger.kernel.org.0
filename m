Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E2E1DFB67
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 00:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgEWWrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 18:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388034AbgEWWrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 18:47:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966AEC061A0E;
        Sat, 23 May 2020 15:47:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu7so6587082pjb.0;
        Sat, 23 May 2020 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=N62olFYpOCxIeaJiTrqR1Y/bozfUs9/3QMSiDsJlVt8=;
        b=GBy4QNuZIVCVP5MIPzIgqs3XWDP2mTwbTWf9Fvk5GkMDZHV9CT8fkX8rmz4SpNXY6f
         tQQ7F4Xr1b5qLdgTgVMCqg0nMjH3hKOB+XsMAlhcM49rmeI7SBeTULp+USht8b8iiRCN
         gEyhoeDvR0aMfOUxTvz/fB8rVjHXsJ0dJmE0jEk6qJKJ0nL5zS0nA9RnQ3jMuJ/7FpRm
         b3dYuqTUz0f6GURXTaj9EeIkFXyPE6Y6VZCSP4WLLR7EIO9+Gxr2gxizZKbnbsm6dF1r
         DjJuycQB4fl6M7hXwSY9gS0x3Yp//aiSbkabOdbkkExylmCP5qH+I8/bUnPEkUJ5aWgF
         GBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=N62olFYpOCxIeaJiTrqR1Y/bozfUs9/3QMSiDsJlVt8=;
        b=rKZGM4qcREinwBSjnvfhDM/FaXsiVPYGFsPG3vdmxrn8R+fxn2J/KtPdX5U4xX9gN9
         Hc8o0Wuvmd5bfdbgKlj/uIlqHdH/qOtdb/RQX6d9LQ1phBnOp7tOqJOvN2wkSn7lYuox
         v2OCorlI0CKdlY1DMDgEqNlXgHoK3urm4y4IQTHhMPSeXxgaeFUaNk76+wo+JYU/cqTH
         BYxKpiDZmoyTmAZjNVM2AP3aStXlDxM6F9U3ijHCHh0oUn9Xe6W3RWSsbz5gdB3YV837
         wtHQnqnhWAXCOmX4AJDzfqKKSQ6NpA/1Ov054iXm880wftTOogRQ3StsHimMkk51kgmv
         LGUg==
X-Gm-Message-State: AOAM533wcv1O3ZR0A9AtyTBgGws3hu6/A0AQXk4LPOW79KbSImlPXPPp
        Yw76KFzMhI4fbmEcTapHwE4fCcJj
X-Google-Smtp-Source: ABdhPJw0K9OcYp5JIvpuG3fjIaqDBONTIhvVvdQ5hl34y4RkTl9cTSnCf0m4CmZZq59RQH3RjJjFGw==
X-Received: by 2002:a17:90a:bb85:: with SMTP id v5mr11596681pjr.150.1590274054969;
        Sat, 23 May 2020 15:47:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c24sm9557220pjs.51.2020.05.23.15.47.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 May 2020 15:47:33 -0700 (PDT)
Date:   Sat, 23 May 2020 15:47:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] sparc32: use PUD rather than PGD to get PMD in
 srmmu_nocache_init()
Message-ID: <20200523224732.GA243603@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, May 22, 2020 at 10:23:09PM -0700, Mike Rapoport wrote:
> The kbuild test robot reported the following warning:
> 
>   arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init': arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used [-Werror=unused-but-set-variable]
>   300 |  pud_t *pud;
> 
> This warning is caused by misprint in the page table traversal in
> srmmu_nocache_init() function which accessed a PMD entry using PGD
> rather than PUD.
> 
> Since sparc32 has only 3 page table levels, the PGD and PUD are
> essentially the same and usage of __nocache_fix() removed the type
> checking.
> 
> Use PUD for the consistency and to silence the compiler warning.
> 
> Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Anatoly Pugachev <matorola@gmail.com>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  arch/sparc/mm/srmmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
> index b7c94de70cca..e9f7af32da07 100644
> --- a/arch/sparc/mm/srmmu.c
> +++ b/arch/sparc/mm/srmmu.c
> @@ -333,7 +333,7 @@ static void __init srmmu_nocache_init(void)
>  		pgd = pgd_offset_k(vaddr);
>  		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
>  		pud = pud_offset(__nocache_fix(p4d), vaddr);
> -		pmd = pmd_offset(__nocache_fix(pgd), vaddr);
> +		pmd = pmd_offset(__nocache_fix(pud), vaddr);
>  		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
>  
>  		pteval = ((paddr >> 4) | SRMMU_ET_PTE | SRMMU_PRIV);
> -- 
> 2.17.1

This quite innocent looking patch crashes all my sparc32 boot tests.
Crash log and bisect results below. Reverting it fixes the problem.

Guenter

---
# bad: [423b8baf18a8c03f2d6fa99aa447ed0da189bb95] Merge branch 'akpm' (patches from Andrew)
# good: [051143e1602d90ea71887d92363edd539d411de5] Merge tag 'apparmor-pr-2020-05-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor
git bisect start 'HEAD' '051143e1602d'
# good: [e644645abf4788e919beeb97925fb6bf43e890a2] Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good e644645abf4788e919beeb97925fb6bf43e890a2
# good: [8f261041b18ee80ad8afdd1621c909c4df9f6cc3] Merge tag 'staging-5.7-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good 8f261041b18ee80ad8afdd1621c909c4df9f6cc3
# good: [23f0dac848412dafd197566b62d831d5a68b5b6b] Merge tag 'driver-core-5.7-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect good 23f0dac848412dafd197566b62d831d5a68b5b6b
# good: [33cd65e73abd693c00c4156cf23677c453b41b3b] kasan: disable branch tracing for core runtime
git bisect good 33cd65e73abd693c00c4156cf23677c453b41b3b
# bad: [c2bc26f7ca1ff1165bb6669a7a4cccc20ffd2ced] sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
git bisect bad c2bc26f7ca1ff1165bb6669a7a4cccc20ffd2ced
# good: [f7fa1876af81512444631d324adb77383f56c37a] MAINTAINERS: update email address for Naoya Horiguchi
git bisect good f7fa1876af81512444631d324adb77383f56c37a
# first bad commit: [c2bc26f7ca1ff1165bb6669a7a4cccc20ffd2ced] sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()

---
Configuration device id QEMU version 1 machine id 36
Probing SBus slot 0 offset 0
Probing SBus slot 1 offset 0
Probing SBus slot 2 offset 0
Probing SBus slot 3 offset 0
Probing SBus slot 4 offset 0
Probing SBus slot 5 offset 0
Invalid FCode start byte
CPUs: 1 x FMI,MB86904
UUID: 00000000-0000-0000-0000-000000000000
Welcome to OpenBIOS v1.1 built on Oct 28 2019 17:08
  Type 'help' for detailed information
[sparc] Kernel already loaded
switching to new context:
PROMLIB: obio_ranges 1
PROMLIB: Sun Boot Prom Version 3 Revision 2
Linux version 5.7.0-rc6-00161-g423b8baf18a8 (groeck@server.roeck-us.net) (gcc version 6.5.0 (Buildroot 2018.11-rc2-00071-g4310260), GNU ld (GNU Binutils) 2.31.1) #1 Sat May 23 11:57:22 PDT 2020
printk: bootconsole [earlyprom0] enabled
ARCH: SUN4M
TYPE: SPARCstation Classic
Ethernet address: 52:54:00:12:34:56
Unable to handle kernel paging request at virtual address d9440000
tsk->{mm,active_mm}->context = ffffffff
tsk->{mm,active_mm}->pgd = fc000000
              \|/ ____ \|/
              "@'/ ,. \`@"
              /_| \__/ |_\
                 \__U_/
swapper(0): Oops [#1]
CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-rc6-00161-g423b8baf18a8 #1
PSR: 04901fc3 PC: f06592a0 NPC: f06592a4 Y: 00000000    Not tainted
PC: <srmmu_paging_init+0x450/0xba0>
%G: 00000008 f06c0000  00000000 cd4403f0  fc000000 006c0000  f0622000 ec000000
%O: 0006c200 000003f0  0c000000 f06c0000  00000000 00001000  f0623d48 0c000000
RPC: <0xc000000>
%L: f067f000 f067f1d4  f067f000 f067f344  0fffffff 0000000f  14000000 fc0003f0
%I: f0000000 f0636698  04000000 f067f000  f067f000 f067f000  f0623e68 f06585dc
Disabling lock debugging due to kernel taint
Caller[f06585dc]: paging_init+0x4/0x24
Caller[f06565b8]: setup_arch+0x430/0x468
Caller[f0652b98]: start_kernel+0x48/0x520
Caller[f065243c]: continue_boot+0x324/0x334
Caller[00000000]: 0x0
Instruction DUMP:
 8600c001 
 8600c001 
 8600c001 
<c600c00a>
 8088c018 
 12800007 
 9a103fff 
 8728e004 
 9a21c002 
Kernel panic - not syncing: Attempted to kill the idle task!
Press Stop-A (L1-A) from sun keyboard or send break
twice on console to return to the boot prom
---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
