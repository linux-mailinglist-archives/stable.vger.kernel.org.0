Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD73B6038
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhF1OWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhF1OWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85F6061C7C;
        Mon, 28 Jun 2021 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889971;
        bh=Gng668oBJNwPCNqmYWvLzv7pCOt/cSV4b4aNdMm8VnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kabeEF/XF9zbw3U5UyQgq2V7bM+2Axoszoe2TXIm9D34L6jcqu2ORcwO+B+6P2hYN
         gOGa0QegCGtlrdzGlpKu0WzgM75pbrIUWl39KGI6bTuKVjc/LpfGZ6siuQJ10PeWBN
         I/YuwwKHN3N6fD7am6Qfa6/ypXZrLB6ghnxNHsc7tyGPQvnDBx3A4HwhvcosOr82KP
         vdiwvwD44FlJ5Y14OH/fxL5OY7iZky9paJNhQVrAL3t9FmRm/xiJ0kF5ECgZ9P0cwZ
         xWEl/MEbslTcLT0vbSRR3OxYtR2RzQ7q//SMZy1GRzLMtrFlhXnVfpEipBf+Ax76fb
         duUsAB5qH5PZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 072/110] s390: clear pt_regs::flags on irq entry
Date:   Mon, 28 Jun 2021 10:17:50 -0400
Message-Id: <20210628141828.31757-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit ca1f4d702d534387aa1f16379edb3b03cdb6ceda upstream.

The current irq entry code doesn't initialize pt_regs::flags. On exit to
user mode arch_do_signal_or_restart() tests whether PIF_SYSCALL is set,
which might yield wrong results.

Fix this by clearing pt_regs::flags in the entry.S irq handler
code.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Fixes: 56e62a737028 ("s390: convert to generic entry")
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 9cc71ca9a88f..e84f495e7eb2 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -418,6 +418,7 @@ ENTRY(\name)
 	xgr	%r6,%r6
 	xgr	%r7,%r7
 	xgr	%r10,%r10
+	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_ASYNC
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	tm	%r8,0x0001		# coming from user space?
-- 
2.30.2

