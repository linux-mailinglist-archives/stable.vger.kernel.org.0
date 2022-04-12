Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517DA4FD8AE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiDLHVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351856AbiDLHNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB9ED46;
        Mon, 11 Apr 2022 23:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB66B81B47;
        Tue, 12 Apr 2022 06:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD045C385A1;
        Tue, 12 Apr 2022 06:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746420;
        bh=yACMg3K5W5/I6pA+flBzd9n3DRtIlF1HetQbnpP/24s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0RIirf/AbI7/mxqKX6lQ1ECLdiz4PXGNMcBFn07EAbYpucKEVkKyIsmr14cl/0HF
         04AsHAOPRoyXhhUxPoG8pminbNJDoRDsqE4iMvGVktWrPoPQr3ZMK2VXZrkbkdLbSr
         W5k6Nj8vDC1bH0OyFN3nWUzPHStVUGMYTUcvkvtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 277/277] powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit
Date:   Tue, 12 Apr 2022 08:31:20 +0200
Message-Id: <20220412062950.057689842@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit ffa0b64e3be58519ae472ea29a1a1ad681e32f48 upstream.

mpe: On 64-bit Book3E vmalloc space starts at 0x8000000000000000.

Because of the way __pa() works we have:
  __pa(0x8000000000000000) == 0, and therefore
  virt_to_pfn(0x8000000000000000) == 0, and therefore
  virt_addr_valid(0x8000000000000000) == true

Which is wrong, virt_addr_valid() should be false for vmalloc space.
In fact all vmalloc addresses that alias with a valid PFN will return
true from virt_addr_valid(). That can cause bugs with hardened usercopy
as described below by Kefeng Wang:

  When running ethtool eth0 on 64-bit Book3E, a BUG occurred:

    usercopy: Kernel memory exposure attempt detected from SLUB object not in SLUB page?! (offset 0, size 1048)!
    kernel BUG at mm/usercopy.c:99
    ...
    usercopy_abort+0x64/0xa0 (unreliable)
    __check_heap_object+0x168/0x190
    __check_object_size+0x1a0/0x200
    dev_ethtool+0x2494/0x2b20
    dev_ioctl+0x5d0/0x770
    sock_do_ioctl+0xf0/0x1d0
    sock_ioctl+0x3ec/0x5a0
    __se_sys_ioctl+0xf0/0x160
    system_call_exception+0xfc/0x1f0
    system_call_common+0xf8/0x200

  The code shows below,

    data = vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN));
    copy_to_user(useraddr, data, gstrings.len * ETH_GSTRING_LEN))

  The data is alloced by vmalloc(), virt_addr_valid(ptr) will return true
  on 64-bit Book3E, which leads to the panic.

  As commit 4dd7554a6456 ("powerpc/64: Add VIRTUAL_BUG_ON checks for __va
  and __pa addresses") does, make sure the virt addr above PAGE_OFFSET in
  the virt_addr_valid() for 64-bit, also add upper limit check to make
  sure the virt is below high_memory.

  Meanwhile, for 32-bit PAGE_OFFSET is the virtual address of the start
  of lowmem, high_memory is the upper low virtual address, the check is
  suitable for 32-bit, this will fix the issue mentioned in commit
  602946ec2f90 ("powerpc: Set max_mapnr correctly") too.

On 32-bit there is a similar problem with high memory, that was fixed in
commit 602946ec2f90 ("powerpc: Set max_mapnr correctly"), but that
commit breaks highmem and needs to be reverted.

We can't easily fix __pa(), we have code that relies on its current
behaviour. So for now add extra checks to virt_addr_valid().

For 64-bit Book3S the extra checks are not necessary, the combination of
virt_to_pfn() and pfn_valid() should yield the correct result, but they
are harmless.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Add additional change log detail]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220406145802.538416-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/page.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -132,7 +132,11 @@ static inline bool pfn_valid(unsigned lo
 #define virt_to_page(kaddr)	pfn_to_page(virt_to_pfn(kaddr))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-#define virt_addr_valid(kaddr)	pfn_valid(virt_to_pfn(kaddr))
+#define virt_addr_valid(vaddr)	({					\
+	unsigned long _addr = (unsigned long)vaddr;			\
+	_addr >= PAGE_OFFSET && _addr < (unsigned long)high_memory &&	\
+	pfn_valid(virt_to_pfn(_addr));					\
+})
 
 /*
  * On Book-E parts we need __va to parse the device tree and we can't


