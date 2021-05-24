Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E82138EF3B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhEXP4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhEXPzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4084A6193F;
        Mon, 24 May 2021 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870929;
        bh=SFIWmuCmd6K2BeIYJTK9POv4VRaOLzfGVszXVW0XUB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+MxT6m+WE4Hjtl+kc3vkgZDPp9XAbM4dWyYpNYyfDlP2L+GR44zjVZa30e0TPoZE
         VdOh8ZEupr/cfQ1ZFhGNyyTnXOpI31rqAZiTv5Q2z43JWMHCNJdghWU5k7eHAsIqMc
         eOZY32CtQQixjhxqxd/TlD3rq2VyxM4ihh9qzUhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 5.10 100/104] openrisc: mm/init.c: remove unused memblock_region variable in map_ram()
Date:   Mon, 24 May 2021 17:26:35 +0200
Message-Id: <20210524152336.161475222@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
@@ -76,7 +76,6 @@ static void __init map_ram(void)
 	/* These mark extents of read-only kernel pages...
 	 * ...from vmlinux.lds.S
 	 */
-	struct memblock_region *region;
 
 	v = PAGE_OFFSET;
 
@@ -122,7 +121,7 @@ static void __init map_ram(void)
 		}
 
 		printk(KERN_INFO "%s: Memory: 0x%x-0x%x\n", __func__,
-		       region->base, region->base + region->size);
+		       start, end);
 	}
 }
 


