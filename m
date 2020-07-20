Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE06F226B24
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgGTPsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbgGTPsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB222064B;
        Mon, 20 Jul 2020 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260096;
        bh=0vN9ldW4dl4UP1zx716nsKtBzsTg8JvdS54xIkDdDHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLpOz8pnWhAc0SQPh/m1YDd52fcedlpZHMbpMC9+qyD2ngK8m/ilTSbGml/WzLK0N
         I6A3oPYEF9+JbHdVDfFDhEIu9F3WKnYmAvdSIudMM8IZQVQatrVFDeLqjFvpbGOMi4
         wDV8z9MalK+PfcMB6gDYrstgd+4CHYs8lKJCNSPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Buettner <kevinb@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 088/125] copy_xstate_to_kernel: Fix typo which caused GDB regression
Date:   Mon, 20 Jul 2020 17:37:07 +0200
Message-Id: <20200720152807.272231710@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Buettner <kevinb@redhat.com>

commit 5714ee50bb4375bd586858ad800b1d9772847452 upstream.

This fixes a regression encountered while running the
gdb.base/corefile.exp test in GDB's test suite.

In my testing, the typo prevented the sw_reserved field of struct
fxregs_state from being output to the kernel XSAVES area.  Thus the
correct mask corresponding to XCR0 was not present in the core file for
GDB to interrogate, resulting in the following behavior:

   [kev@f32-1 gdb]$ ./gdb -q testsuite/outputs/gdb.base/corefile/corefile testsuite/outputs/gdb.base/corefile/corefile.core
   Reading symbols from testsuite/outputs/gdb.base/corefile/corefile...
   [New LWP 232880]

   warning: Unexpected size of section `.reg-xstate/232880' in core file.

With the typo fixed, the test works again as expected.

Signed-off-by: Kevin Buettner <kevinb@redhat.com>
Fixes: 9e4636545933 ("copy_xstate_to_kernel(): don't leave parts of destination uninitialized")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/fpu/xstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1029,7 +1029,7 @@ int copy_xstate_to_kernel(void *kbuf, st
 		copy_part(offsetof(struct fxregs_state, st_space), 128,
 			  &xsave->i387.st_space, &kbuf, &offset_start, &count);
 	if (header.xfeatures & XFEATURE_MASK_SSE)
-		copy_part(xstate_offsets[XFEATURE_MASK_SSE], 256,
+		copy_part(xstate_offsets[XFEATURE_SSE], 256,
 			  &xsave->i387.xmm_space, &kbuf, &offset_start, &count);
 	/*
 	 * Fill xsave->i387.sw_reserved value for ptrace frame:


