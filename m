Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D5FD9E9B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438651AbfJPV7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438646AbfJPV7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8556921E6F;
        Wed, 16 Oct 2019 21:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263189;
        bh=VKHQfKbsgnFdOJ/vCWv509LB8R6iwIp/yFnQDFa6zDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/2N1j8PxCVkrRlRgHR9mmwgYoXycrr1mBP9HyCA4ZG4tuaWph1EXa2mhIZwJJGfx
         Mliq3qnyD+odoY907tl76fVvO3kzXyL6Ae4VEkrfjzNJCJt2NenLNNUmdoKfRtlpOO
         c5YtaB/VIlCJr+WmwSP/9xHuN0LjYvE+znGhdRPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 077/112] mm/page_alloc.c: fix a crash in free_pages_prepare()
Date:   Wed, 16 Oct 2019 14:51:09 -0700
Message-Id: <20191016214904.226946438@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 234fdce892f905cbc2674349a9eb4873e288e5b3 upstream.

On architectures like s390, arch_free_page() could mark the page unused
(set_page_unused()) and any access later would trigger a kernel panic.
Fix it by moving arch_free_page() after all possible accessing calls.

 Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
 Krnl PSW : 0404e00180000000 0000000026c2b96e (__free_pages_ok+0x34e/0x5d8)
            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 Krnl GPRS: 0000000088d43af7 0000000000484000 000000000000007c 000000000000000f
            000003d080012100 000003d080013fc0 0000000000000000 0000000000100000
            00000000275cca48 0000000000000100 0000000000000008 000003d080010000
            00000000000001d0 000003d000000000 0000000026c2b78a 000000002717fdb0
 Krnl Code: 0000000026c2b95c: ec1100b30659 risbgn %r1,%r1,0,179,6
            0000000026c2b962: e32014000036 pfd 2,1024(%r1)
           #0000000026c2b968: d7ff10001000 xc 0(256,%r1),0(%r1)
           >0000000026c2b96e: 41101100  la %r1,256(%r1)
            0000000026c2b972: a737fff8  brctg %r3,26c2b962
            0000000026c2b976: d7ff10001000 xc 0(256,%r1),0(%r1)
            0000000026c2b97c: e31003400004 lg %r1,832
            0000000026c2b982: ebff1430016a asi 5168(%r1),-1
 Call Trace:
 __free_pages_ok+0x16a/0x5d8)
 memblock_free_all+0x206/0x290
 mem_init+0x58/0x120
 start_kernel+0x2b0/0x570
 startup_continue+0x6a/0xc0
 INFO: lockdep is turned off.
 Last Breaking-Event-Address:
 __free_pages_ok+0x372/0x5d8
 Kernel panic - not syncing: Fatal exception: panic_on_oops
 00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 26A2379C

In the past, only kernel_poison_pages() would trigger this but it needs
"page_poison=on" kernel cmdline, and I suspect nobody tested that on
s390.  Recently, kernel_init_free_pages() (commit 6471384af2a6 ("mm:
security: introduce init_on_alloc=1 and init_on_free=1 boot options"))
was added and could trigger this as well.

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/1569613623-16820-1-git-send-email-cai@lca.pw
Fixes: 8823b1dbc05f ("mm/page_poison.c: enable PAGE_POISONING as a separate option")
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: <stable@vger.kernel.org>	[5.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1174,11 +1174,17 @@ static __always_inline bool free_pages_p
 		debug_check_no_obj_freed(page_address(page),
 					   PAGE_SIZE << order);
 	}
-	arch_free_page(page, order);
 	if (want_init_on_free())
 		kernel_init_free_pages(page, 1 << order);
 
 	kernel_poison_pages(page, 1 << order, 0);
+	/*
+	 * arch_free_page() can make the page's contents inaccessible.  s390
+	 * does this.  So nothing which can access the page's contents should
+	 * happen after this.
+	 */
+	arch_free_page(page, order);
+
 	if (debug_pagealloc_enabled())
 		kernel_map_pages(page, 1 << order, 0);
 


