Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B6B4C85FE
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 09:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiCAIMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 03:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiCAIMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 03:12:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E3883003;
        Tue,  1 Mar 2022 00:11:54 -0800 (PST)
Received: from integral2.. (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id B483F7EC80;
        Tue,  1 Mar 2022 08:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646122313;
        bh=zdjHxjV5WVf3cpuRmNxzzSq7B8CXjRT0mG4Lpjuog2o=;
        h=From:To:Cc:Subject:Date:From;
        b=MfhrwLxxD6kbQ0SCSfBIQCUUYcBnNglFhXQXnhx/zNIuKqnZ8rpvS9rEsrnnw+FY3
         2+63aUj+4tLVqiBi/2dVnNroml53rrruClzZjOQq8C3sgSvFd78yqmU3jNm/4t7Ksy
         dyi4+DiYLpgTO0D+lxna9FaZiWY3HRdpu9MKni9Na1lN3Vy6kSmckbp9ztBihmrgAc
         NuYlJR243Pg6pdV9TQEW62Lr1qPmT4ROCcaR1JEldcAM8CzanzU3emU2jkd51JE8Dr
         A+/gLVNsuNmxLnZyNcUkhHc3K45rVnugcvoa8bEomUH95jN+a0TLq18y9RVyAar8Y7
         lv15MZzmpjdkA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v3 0/2] Two x86 fixes
Date:   Tue,  1 Mar 2022 15:11:31 +0700
Message-Id: <20220301081133.106875-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Two fixes for x86 arch.

## Changelog
v3:
  - Fold in changes from Alviro, the previous version is still
    leaking @bank[n].

v2:
  - Fix wrong copy/paste.

## Summary
[PATCH v3 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`

The asm constraint does not reflect that the asm statement can modify
the value of @loops. But the asm statement in delay_loop() does change
the @loops.

If by any chance the compiler inlines this function, it may clobber
random stuff (e.g. local variable, important temporary value in reg,
etc.).

Fortunately, delay_loop() is only called indirectly (so it can't
inline), and then the register it clobbers is %rax (which is by the
nature of the calling convention, it's a caller saved register), so it
didn't yield any bug.

^ That shouldn't be an excuse for using the wrong constraint anyway.

This changes "a" (as an input) to "+a" (as an input and output).


[PATCH v3 2/2] x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails.

@bp is a local variable, calling mce_threshold_remove_device() when
threshold_create_bank() fails will not free the @bp. Note that
mce_threshold_remove_device() frees the @bp only if it's already
stored in the @threshold_banks per-CPU variable.

At that point, the @threshold_banks per-CPU variable is still NULL,
so the mce_threshold_remove_device() will just be a no-op and the
@bp is leaked.

Fix this by storing @bp to @threshold_banks before the loop, so in
case we fail, mce_threshold_remove_device() will free the @bp.

This bug is introduced by commit 6458de97fc15530b544 ("x86/mce/amd:
Straighten CPU hotplug path") [1].


Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (2):
  x86/delay: Fix the wrong asm constraint in `delay_loop()`
  x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails

 arch/x86/kernel/cpu/mce/amd.c | 16 ++++++++++------
 arch/x86/lib/delay.c          |  4 ++--
 2 files changed, 12 insertions(+), 8 deletions(-)


base-commit: 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3
-- 
2.32.0

