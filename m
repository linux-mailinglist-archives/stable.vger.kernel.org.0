Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0B520D827
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgF2Tgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733017AbgF2Tae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE162529F;
        Mon, 29 Jun 2020 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445009;
        bh=Dz13eb/rJGgeoaRVyWqs3XRGPmYfk43xXMq8OI26fbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8Mb36iTsHoqwIPO6Hv8NMp1GKDM2pzAA/CjKmHhMwAkE2x7pXeYMdOPWIllSpPn1
         JlVFrzZjMwLNPeUafmPXlbgfgFL5/sfsOlks3VVTofNY3M5mozMRb9BB9zOy7zQjZq
         pPfMykz+tjKZjEYF978TkqdL6lpwMT+H3wPlN/wU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Fleming <matt@codeblueprint.co.uk>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 110/131] x86/asm/64: Align start of __clear_user() loop to 16-bytes
Date:   Mon, 29 Jun 2020 11:34:41 -0400
Message-Id: <20200629153502.2494656-111-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Fleming <matt@codeblueprint.co.uk>

commit bb5570ad3b54e7930997aec76ab68256d5236d94 upstream.

x86 CPUs can suffer severe performance drops if a tight loop, such as
the ones in __clear_user(), straddles a 16-byte instruction fetch
window, or worse, a 64-byte cacheline. This issues was discovered in the
SUSE kernel with the following commit,

  1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")

which increased the code object size from 10 bytes to 15 bytes and
caused the 8-byte copy loop in __clear_user() to be split across a
64-byte cacheline.

Aligning the start of the loop to 16-bytes makes this fit neatly inside
a single instruction fetch window again and restores the performance of
__clear_user() which is used heavily when reading from /dev/zero.

Here are some numbers from running libmicro's read_z* and pread_z*
microbenchmarks which read from /dev/zero:

  Zen 1 (Naples)

  libmicro-file
                                        5.7.0-rc6              5.7.0-rc6              5.7.0-rc6
                                                    revert-1153933703d9+               align16+
  Time mean95-pread_z100k       9.9195 (   0.00%)      5.9856 (  39.66%)      5.9938 (  39.58%)
  Time mean95-pread_z10k        1.1378 (   0.00%)      0.7450 (  34.52%)      0.7467 (  34.38%)
  Time mean95-pread_z1k         0.2623 (   0.00%)      0.2251 (  14.18%)      0.2252 (  14.15%)
  Time mean95-pread_zw100k      9.9974 (   0.00%)      6.0648 (  39.34%)      6.0756 (  39.23%)
  Time mean95-read_z100k        9.8940 (   0.00%)      5.9885 (  39.47%)      5.9994 (  39.36%)
  Time mean95-read_z10k         1.1394 (   0.00%)      0.7483 (  34.33%)      0.7482 (  34.33%)

Note that this doesn't affect Haswell or Broadwell microarchitectures
which seem to avoid the alignment issue by executing the loop straight
out of the Loop Stream Detector (verified using perf events).

Fixes: 1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://lkml.kernel.org/r/20200618102002.30034-1-matt@codeblueprint.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/usercopy_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 9c5606d88f618..7077b3e282414 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -23,6 +23,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 	asm volatile(
 		"	testq  %[size8],%[size8]\n"
 		"	jz     4f\n"
+		"	.align 16\n"
 		"0:	movq $0,(%[dst])\n"
 		"	addq   $8,%[dst]\n"
 		"	decl %%ecx ; jnz   0b\n"
-- 
2.25.1

