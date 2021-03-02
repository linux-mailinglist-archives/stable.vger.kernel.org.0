Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717A332AF97
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238262AbhCCA1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350687AbhCBMX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F0764FA7;
        Tue,  2 Mar 2021 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686327;
        bh=EoCIQz3xaTLNSIaU4iIbXXKYNai1QNAaYohHxkVBbBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvjphDe/XMsQwxMZq1ZI0oAzmK785n43odipDQHNENIeMYOzwPwONVF7KqJLJW3yA
         uLl2qO1CNtW6iVO/F4rLE0K0Rc7svjCgpTQ2g+02SO9sHymj6F01bbdD+J3fz8MFH2
         cGHuK9GHpAqwPVrN2joPCHOi18ZyZpOgy4Qir7Ls3QDv4J+96128RhU5pVga1j5GPj
         YQ5W3W8cONxakX+bsS57J6bFmA9vxxWa4q8Yr2YbSGzQjBwP/1nuep1GomB7+9Csae
         pVQJItwUO4HVBO4wG3p8sfh1DtqK8Ei00I849WaFaIwk7fLFMW0YQnYa/GKtRKnxJS
         eFGa4W969f7kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Larsson <andreas@gaisler.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/21] sparc32: Limit memblock allocation to low memory
Date:   Tue,  2 Mar 2021 06:58:23 -0500
Message-Id: <20210302115835.63269-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit bda166930c37604ffa93f2425426af6921ec575a ]

Commit cca079ef8ac29a7c02192d2bad2ffe4c0c5ffdd0 changed sparc32 to use
memblocks instead of bootmem, but also made high memory available via
memblock allocation which does not work together with e.g. phys_to_virt
and can lead to kernel panic.

This changes back to only low memory being allocatable in the early
stages, now using memblock allocation.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/init_32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 92634d4e440c..89a9244f2cf0 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -199,6 +199,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
 	size = memblock_phys_mem_size() - memblock_reserved_size();
 	*pages_avail = (size >> PAGE_SHIFT) - high_pages;
 
+	/* Only allow low memory to be allocated via memblock allocation */
+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
+
 	return max_pfn;
 }
 
-- 
2.30.1

