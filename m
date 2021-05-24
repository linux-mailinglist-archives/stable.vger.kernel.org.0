Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD8938F055
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbhEXQCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236031AbhEXQBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1294761998;
        Mon, 24 May 2021 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871209;
        bh=2Z+d4Wgsx/otMK7BW/mHbEtbdQX5RNVNLnz08ZqUfkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFrcuDmsvdMAtl3klY4EsFnGB+Zb/XjnlF5bgcudILrIHbsUgPHK+VGphNrT6DUYM
         ehRPrqZL9rfsYbjJIEHz336g427QKVNHIlsBx0Ko+D3FhnWFiplw8F+XXhsWR5bJAt
         GKHeND7l4fEVI/cJnrh5NIMyHUL97cL9S6HyZxNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 5.12 123/127] openrisc: mm/init.c: remove unused memblock_region variable in map_ram()
Date:   Mon, 24 May 2021 17:27:20 +0200
Message-Id: <20210524152339.031806993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 4eff124347191d1548eb4e14e20e77513dcbd0fe upstream.

Kernel test robot reports:

cppcheck possible warnings: (new ones prefixed by >>, may not real problems)

>> arch/openrisc/mm/init.c:125:10: warning: Uninitialized variable: region [uninitvar]
            region->base, region->base + region->size);
            ^

Replace usage of memblock_region fields with 'start' and 'end' variables
that are initialized in for_each_mem_range() and remove the declaration of
region.

Fixes: b10d6bca8720 ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -75,7 +75,6 @@ static void __init map_ram(void)
 	/* These mark extents of read-only kernel pages...
 	 * ...from vmlinux.lds.S
 	 */
-	struct memblock_region *region;
 
 	v = PAGE_OFFSET;
 
@@ -121,7 +120,7 @@ static void __init map_ram(void)
 		}
 
 		printk(KERN_INFO "%s: Memory: 0x%x-0x%x\n", __func__,
-		       region->base, region->base + region->size);
+		       start, end);
 	}
 }
 


