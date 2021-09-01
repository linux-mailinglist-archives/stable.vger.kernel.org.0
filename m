Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1583FDBFE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346051AbhIAMqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344776AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 773A661209;
        Wed,  1 Sep 2021 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499876;
        bh=d1Qf3OsZwmL4ZO08kHR9JddNHKHIWQJyuTHXHe/qw/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihKsmhYzEmsLqHghosI+5Olh8hKylt4NpHgK3eUUaYfARObtH9EUP/96Fo+VMNlVh
         f0iC6JPnVnh9jhueRiaT4vfVUiukDEzHnNiK6HmcIOIlrS4VTA2yNfeg1FSrOL4Zz2
         RvReUSBnDYdrL51cqCtBEFGXYZpE7ktzUgnTro2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 018/113] powerpc: Re-enable ARCH_ENABLE_SPLIT_PMD_PTLOCK
Date:   Wed,  1 Sep 2021 14:27:33 +0200
Message-Id: <20210901122302.587592459@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 310d2e83cb9b7f1e7232319880e3fcb57592fa10 upstream.

Commit 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
broke PMD split page table lock for powerpc.

It selects the non-existent config ARCH_ENABLE_PMD_SPLIT_PTLOCK in
arch/powerpc/platforms/Kconfig.cputype, but clearly intended to
select ARCH_ENABLE_SPLIT_PMD_PTLOCK (notice the word swapping!), as
that commit did for all other architectures.

Fix it by selecting the correct symbol ARCH_ENABLE_SPLIT_PMD_PTLOCK.

Fixes: 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
[mpe: Reword change log to make it clear this is a bug fix]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210819113954.17515-3-lukas.bulwahn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/Kconfig.cputype |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -97,7 +97,7 @@ config PPC_BOOK3S_64
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
-	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING


