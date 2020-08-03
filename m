Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB223A573
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgHCMgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgHCMf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:35:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B82D420678;
        Mon,  3 Aug 2020 12:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458127;
        bh=gXEwiYtWJrb+EFFUrwnNNz7Jzhi9gU+IQFe3eDUXoAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB6DBxPw8oMEKG93NVIX6X33aTsqPHlCGmhB7QO28m18EUXC+NzQ5f/LEWt4/J4Qf
         DLwPc2X1gyItHFqBdVwUXn94CYCP3jEOxppS6aXihvtp/X9GQVxN3mLCd3SQdiAxBF
         ihs8QEX9qS1UNE9/UnFLtaiD4X+ROhgWr3pq7geo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 18/51] random: fix circular include dependency on arm64 after addition of percpu.h
Date:   Mon,  3 Aug 2020 14:20:03 +0200
Message-Id: <20200803121850.379776706@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit 1c9df907da83812e4f33b59d3d142c864d9da57f upstream.

Daniel Díaz and Kees Cook independently reported that commit
f227e3ec3b5c ("random32: update the net random state on interrupt and
activity") broke arm64 due to a circular dependency on include files
since the addition of percpu.h in random.h.

The correct fix would definitely be to move all the prandom32 stuff out
of random.h but for backporting, a smaller solution is preferred.

This one replaces linux/percpu.h with asm/percpu.h, and this fixes the
problem on x86_64, arm64, arm, and mips.  Note that moving percpu.h
around didn't change anything and that removing it entirely broke
differently.  When backporting, such options might still be considered
if this patch fails to help.

[ It turns out that an alternate fix seems to be to just remove the
  troublesome <asm/pointer_auth.h> remove from the arm64 <asm/smp.h>
  that causes the circular dependency.

  But we might as well do the whole belt-and-suspenders thing, and
  minimize inclusion in <linux/random.h> too. Either will fix the
  problem, and both are good changes.   - Linus ]

Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Reported-by: Kees Cook <keescook@chromium.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Fixes: f227e3ec3b5c
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/random.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -9,7 +9,7 @@
 
 #include <linux/list.h>
 #include <linux/once.h>
-#include <linux/percpu.h>
+#include <asm/percpu.h>
 
 #include <uapi/linux/random.h>
 


