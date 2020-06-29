Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6C20E6CB
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404166AbgF2Vud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D74247A2;
        Mon, 29 Jun 2020 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444110;
        bh=LjpRqfLzZxCARXyxYn/UGAlTTNcE5bmGQyWx9hTCtSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3aaZsZjgXDm/yvBmsAcF1glFZMbCd6ljZNYespqvZ3jnL6dqN2Fb2c5jbqLHwzDV
         +vTWl0KvakiaYK6MHc2fgg0DjS+9XjX6bU9gCXV1Coz9l3jLuFaqEbj+zKAE0grK/H
         lkI7/NjnVIAe1CP4HNIF/ihzNd9NTckEkSThXM2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Fleming <matt@codeblueprint.co.uk>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 221/265] x86/asm/64: Align start of __clear_user() loop to 16-bytes
Date:   Mon, 29 Jun 2020 11:17:34 -0400
Message-Id: <20200629151818.2493727-222-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index fff28c6f73a21..b0dfac3d3df71 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 	asm volatile(
 		"	testq  %[size8],%[size8]\n"
 		"	jz     4f\n"
+		"	.align 16\n"
 		"0:	movq $0,(%[dst])\n"
 		"	addq   $8,%[dst]\n"
 		"	decl %%ecx ; jnz   0b\n"
-- 
2.25.1

