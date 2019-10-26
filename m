Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9444E5AD4
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfJZNSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727757AbfJZNSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BECD721E6F;
        Sat, 26 Oct 2019 13:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095895;
        bh=Da2+BDVNfV3cOEI+tV/Lq5ouvPU5Dta7w1CoeLfooqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXKOwjtgV7m3nBjnqmfJ2Gj46RhpBpsbzI9NF0ZlNKZZStGVlQc6eqYRHfjB68kqA
         iuvUr+OpxX4g2BztYk6G7IpWB55DTkwX/jnrIDPRYOcYofyCwACkJ8f7PSg0nFCbNH
         49MsK/zqi0rCt6Q6qYPmBfZyl+e1F44BQ1P1RYas=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry V Levin <ldv@altlinux.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Meelis Roos <mroos@linux.ee>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 77/99] sparc64: disable fast-GUP due to unexplained oopses
Date:   Sat, 26 Oct 2019 09:15:38 -0400
Message-Id: <20191026131600.2507-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 8e0d0ad206f08506c893326ca7c9c3d9cc042cef ]

HAVE_FAST_GUP enables the lockless quick page table walker for simple
cases, and is a nice optimization for some random loads that can then
use get_user_pages_fast() rather than the more careful page walker.

However, for some unexplained reason, it seems to be subtly broken on
sparc64.  The breakage is only with some compiler versions and some
hardware, and nobody seems to have figured out what triggers it,
although there's a simple reprodicer for the problem when it does
trigger.

The problem was introduced with the conversion to the generic GUP code
in commit 7b9afb86b632 ("sparc64: use the generic get_user_pages_fast
code"), but nothing looks obviously wrong in that conversion.  It may be
a compiler bug that just hits us with the code reorganization.  Or it
may be something very specific to sparc64.

This disables HAVE_FAST_GUP entirely.  That makes things like futexes a
bit slower, but at least they work.  If we can figure out the trigger,
that would be lovely, but it's been three months already..

Link: https://lore.kernel.org/lkml/20190717215956.GA30369@altlinux.org/
Fixes: 7b9afb86b632 ("sparc64: use the generic get_user_pages_fast code")
Reported-by: Dmitry V Levin <ldv@altlinux.org>
Reported-by: Anatoly Pugachev <matorola@gmail.com>
Requested-by: Meelis Roos <mroos@linux.ee>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 7926a2e11bdc2..6a31f240840d4 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -28,7 +28,6 @@ config SPARC
 	select RTC_DRV_M48T59
 	select RTC_SYSTOHC
 	select HAVE_ARCH_JUMP_LABEL if SPARC64
-	select HAVE_FAST_GUP if SPARC64
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_PCI_IOMAP
-- 
2.20.1

