Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A9038A2C9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhETJpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231582AbhETJnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA2DE61448;
        Thu, 20 May 2021 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503177;
        bh=gU/ZrlSGQCpZ8unKozdd6U/i+PtXxU+4cDcxs0AgTyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBwy773uyWF/DvOc0qLvYkPw4qAqGyNbPwvdjUicT6HBtux5XXIePLh6JXA2/O/ys
         3SCerWn8HXDxSJXQjqmaHOipwd1KTN4ZUb9g3ZrYOCDPAa50k3rrf/rJpo9T2JH+cM
         LceRvi6m/5cpdJjgMacXq3b6EPFIyv/c/GqQ/MJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Jian Cai <jiancai@google.com>
Subject: [PATCH 4.19 102/425] arm64: vdso: remove commas between macro name and arguments
Date:   Thu, 20 May 2021 11:17:51 +0200
Message-Id: <20210520092134.808939277@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Cai <jiancai@google.com>

LLVM's integrated assembler appears to assume an argument with default
value is passed whenever it sees a comma right after the macro name.
It will be fine if the number of following arguments is one less than
the number of parameters specified in the macro definition. Otherwise,
it fails. For example, the following code works:

$ cat foo.s
.macro  foo arg1=2, arg2=4
        ldr r0, [r1, #\arg1]
        ldr r0, [r1, #\arg2]
.endm

foo, arg2=8

$ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
arm-linux-gnueabihf-objdump -dr ias.o

ias.o:     file format elf32-littlearm

Disassembly of section .text:

00000000 <.text>:
   0: e5910001 ldr r0, [r1, #2]
   4: e5910003 ldr r0, [r1, #8]

While the the following code would fail:

$ cat foo.s
.macro  foo arg1=2, arg2=4
        ldr r0, [r1, #\arg1]
        ldr r0, [r1, #\arg2]
.endm

foo, arg1=2, arg2=8

$ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
foo.s:6:14: error: too many positional arguments
foo, arg1=2, arg2=8

This causes build failures as follows:

arch/arm64/kernel/vdso/gettimeofday.S:230:24: error: too many positional
arguments
 clock_gettime_return, shift=1
                       ^
arch/arm64/kernel/vdso/gettimeofday.S:253:24: error: too many positional
arguments
 clock_gettime_return, shift=1
                       ^
arch/arm64/kernel/vdso/gettimeofday.S:274:24: error: too many positional
arguments
 clock_gettime_return, shift=1

This error is not in mainline because commit 28b1a824a4f4 ("arm64: vdso:
Substitute gettimeofday() with C implementation") rewrote this assembler
file in C as part of a 25 patch series that is unsuitable for stable.
Just remove the comma in the clock_gettime_return invocations in 4.19 so
that GNU as and LLVM's integrated assembler work the same.

Link:
https://github.com/ClangBuiltLinux/linux/issues/1349

Suggested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jian Cai <jiancai@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes v1 -> v2:
  Keep the comma in the macro definition to be consistent with other
  definitions.

Changes v2 -> v3:
  Edit tags.

Changes v3 -> v4:
  Update the commit message based on Nathan's comments.

 arch/arm64/kernel/vdso/gettimeofday.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -227,7 +227,7 @@ realtime:
 	seqcnt_check fail=realtime
 	get_ts_realtime res_sec=x10, res_nsec=x11, \
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 monotonic:
@@ -250,7 +250,7 @@ monotonic:
 		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
 
 	add_ts sec=x10, nsec=x11, ts_sec=x3, ts_nsec=x4, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 monotonic_raw:
@@ -271,7 +271,7 @@ monotonic_raw:
 		clock_nsec=x15, nsec_to_sec=x9
 
 	add_ts sec=x10, nsec=x11, ts_sec=x13, ts_nsec=x14, nsec_to_sec=x9
-	clock_gettime_return, shift=1
+	clock_gettime_return shift=1
 
 	ALIGN
 realtime_coarse:


