Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6B359A85
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhDIJ73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhDIJ6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:58:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27149611ED;
        Fri,  9 Apr 2021 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962270;
        bh=s85p77OcQwPWo1UzKkyxbKC8HoOdSwFTGCwgKYgsNXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG8hrXBo5QeLkQTNgs+YNQkkaaJsMoHOEKArhQB17WUkTkS2jbrDCej2xG+VveUtt
         atLAe0Ad1YAR1eX8wXNs3QFpzSCE/QrzJ1yygNRhc0l2uFMaXgfgYHwDnFG+YWoZXn
         ma+4EuONpi4wU9NLgdCKMLf7WcAQ5Jw03rRvXJw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 19/23] bpf, x86: Validate computation of branch displacements for x86-64
Date:   Fri,  9 Apr 2021 11:53:49 +0200
Message-Id: <20210409095303.505232339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
References: <20210409095302.894568462@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit e4d4d456436bfb2fe412ee2cd489f7658449b098 upstream.

The branch displacement logic in the BPF JIT compilers for x86 assumes
that, for any generated branch instruction, the distance cannot
increase between optimization passes.

But this assumption can be violated due to how the distances are
computed. Specifically, whenever a backward branch is processed in
do_jit(), the distance is computed by subtracting the positions in the
machine code from different optimization passes. This is because part
of addrs[] is already updated for the current optimization pass, before
the branch instruction is visited.

And so the optimizer can expand blocks of machine code in some cases.

This can confuse the optimizer logic, where it assumes that a fixed
point has been reached for all machine code blocks once the total
program size stops changing. And then the JIT compiler can output
abnormal machine code containing incorrect branch displacements.

To mitigate this issue, we assert that a fixed point is reached while
populating the output image. This rejects any problematic programs.
The issue affects both x86-32 and x86-64. We mitigate separately to
ease backporting.

Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1050,7 +1050,16 @@ emit_jmp:
 		}
 
 		if (image) {
-			if (unlikely(proglen + ilen > oldproglen)) {
+			/*
+			 * When populating the image, assert that:
+			 *
+			 *  i) We do not write beyond the allocated space, and
+			 * ii) addrs[i] did not change from the prior run, in order
+			 *     to validate assumptions made for computing branch
+			 *     displacements.
+			 */
+			if (unlikely(proglen + ilen > oldproglen ||
+				     proglen + ilen != addrs[i])) {
 				pr_err("bpf_jit: fatal error\n");
 				return -EFAULT;
 			}


