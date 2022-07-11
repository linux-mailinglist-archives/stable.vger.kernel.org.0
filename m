Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5275F5700A3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 13:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiGKL3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 07:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiGKL3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 07:29:07 -0400
X-Greylist: delayed 85 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 04:10:59 PDT
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB6FF1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 04:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657537856; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Bs7IofnqMe0KLWWwwc/Z1IbOwQGWRUW1VdUXdwvLoJj6PCEumJgrAuZMW4QVsepkpZeb8q0A37M0abvn5j5atuuV2P4+s4r8g5evELjywbpcdB8vDGs1g6mqTWGlt/y9cwVW4Wjtjsm9m5MIErZR8QOj5TkzHW9EL8H1su8Rreg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1657537856; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9EFnWzIjRXhO6NFpuLgRlclbpqckdg65FzZOVvTbWLg=; 
        b=jsYLdEC43iSng8uwwTp4v2RALM8hTDklAlLvQOM98hbOQTQHwTfITm2Skt3bvtsKcrnckgqp6clNynu5c7p0DO+h8fJ5ynT/cZUiDjOeCreW6yqwm9XqHMmVGlOncP6mzX+cX/aq6AIx1JCSndYZux3ClQTSrfbpD8Zr0/Moq54=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=linux.beauty;
        spf=pass  smtp.mailfrom=me@linux.beauty;
        dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657537856;
        s=zmail; d=linux.beauty; i=me@linux.beauty;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9EFnWzIjRXhO6NFpuLgRlclbpqckdg65FzZOVvTbWLg=;
        b=jfJ4QYUrq7NcOnXq4I7jpkt2kJ8fqWo5ZabTG+1WAVYgwz8bsQpls+ZB7yHd4KfU
        5+yqiojKwqAnLYfDn3VGCVgSEmVtG/X1JOnUlQ6Gi0lFaybhvq+8OpNjfPx7a1RSVR4
        5tJbDDZuKr0/nGnIj7KU8k2ytibZJym1rQI5w/AQ=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1657537854896612.3843737986871; Mon, 11 Jul 2022 04:10:54 -0700 (PDT)
Date:   Mon, 11 Jul 2022 19:10:54 +0800
From:   Li Chen <me@linux.beauty>
To:     "lchen" <lchen@ambarella.com>
Cc:     "Patrick Wang" <patrick.wang.shcn@gmail.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "stable" <stable@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Message-ID: <181ecf47d93.d40b4cfe300210.8880172372139691338@linux.beauty>
In-Reply-To: <20220711110804.11134-1-me@linux.beauty>
References: <20220711110804.11134-1-me@linux.beauty>
Subject: Re: [PATCH] mm: kmemleak: take a full lowmem check in
 kmemleak_*_phys()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, pls ignore this mail, my bad.

Regards,
Li
 ---- On Mon, 11 Jul 2022 19:08:04 +0800  Li Chen <me@linux.beauty> wrote --- 
 > From: Patrick Wang <patrick.wang.shcn@gmail.com>
 > 
 > commit 23c2d497de21f25898fbea70aeb292ab8acc8c94 upstream.
 > 
 > The kmemleak_*_phys() apis do not check the address for lowmem's min
 > boundary, while the caller may pass an address below lowmem, which will
 > trigger an oops:
 > 
 >   # echo scan > /sys/kernel/debug/kmemleak
 >   Unable to handle kernel paging request at virtual address ff5fffffffe00000
 >   Oops [#1]
 >   Modules linked in:
 >   CPU: 2 PID: 134 Comm: bash Not tainted 5.18.0-rc1-next-20220407 #33
 >   Hardware name: riscv-virtio,qemu (DT)
 >   epc : scan_block+0x74/0x15c
 >    ra : scan_block+0x72/0x15c
 >   epc : ffffffff801e5806 ra : ffffffff801e5804 sp : ff200000104abc30
 >    gp : ffffffff815cd4e8 tp : ff60000004cfa340 t0 : 0000000000000200
 >    t1 : 00aaaaaac23954cc t2 : 00000000000003ff s0 : ff200000104abc90
 >    s1 : ffffffff81b0ff28 a0 : 0000000000000000 a1 : ff5fffffffe01000
 >    a2 : ffffffff81b0ff28 a3 : 0000000000000002 a4 : 0000000000000001
 >    a5 : 0000000000000000 a6 : ff200000104abd7c a7 : 0000000000000005
 >    s2 : ff5fffffffe00ff9 s3 : ffffffff815cd998 s4 : ffffffff815d0e90
 >    s5 : ffffffff81b0ff28 s6 : 0000000000000020 s7 : ffffffff815d0eb0
 >    s8 : ffffffffffffffff s9 : ff5fffffffe00000 s10: ff5fffffffe01000
 >    s11: 0000000000000022 t3 : 00ffffffaa17db4c t4 : 000000000000000f
 >    t5 : 0000000000000001 t6 : 0000000000000000
 >   status: 0000000000000100 badaddr: ff5fffffffe00000 cause: 000000000000000d
 >     scan_gray_list+0x12e/0x1a6
 >     kmemleak_scan+0x2aa/0x57e
 >     kmemleak_write+0x32a/0x40c
 >     full_proxy_write+0x56/0x82
 >     vfs_write+0xa6/0x2a6
 >     ksys_write+0x6c/0xe2
 >     sys_write+0x22/0x2a
 >     ret_from_syscall+0x0/0x2
 > 
 > The callers may not quite know the actual address they pass(e.g. from
 > devicetree).  So the kmemleak_*_phys() apis should guarantee the address
 > they finally use is in lowmem range, so check the address for lowmem's
 > min boundary.
 > 
 > Link: https://lkml.kernel.org/r/20220413122925.33856-1-patrick.wang.shcn@gmail.com
 > Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
 > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
 > Cc: <stable@vger.kernel.org>
 > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > ---
 >  mm/kmemleak.c | 8 ++++----
 >  1 file changed, 4 insertions(+), 4 deletions(-)
 > 
 > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
 > index b78861b8e013..859303aae180 100644
 > --- a/mm/kmemleak.c
 > +++ b/mm/kmemleak.c
 > @@ -1125,7 +1125,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 >  void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 >                     gfp_t gfp)
 >  {
 > -    if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 > +    if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 >          kmemleak_alloc(__va(phys), size, min_count, gfp);
 >  }
 >  EXPORT_SYMBOL(kmemleak_alloc_phys);
 > @@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
 >   */
 >  void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 >  {
 > -    if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 > +    if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 >          kmemleak_free_part(__va(phys), size);
 >  }
 >  EXPORT_SYMBOL(kmemleak_free_part_phys);
 > @@ -1151,7 +1151,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
 >   */
 >  void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 >  {
 > -    if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 > +    if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 >          kmemleak_not_leak(__va(phys));
 >  }
 >  EXPORT_SYMBOL(kmemleak_not_leak_phys);
 > @@ -1163,7 +1163,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
 >   */
 >  void __ref kmemleak_ignore_phys(phys_addr_t phys)
 >  {
 > -    if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 > +    if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 >          kmemleak_ignore(__va(phys));
 >  }
 >  EXPORT_SYMBOL(kmemleak_ignore_phys);
 > -- 
 > 2.36.1
 > 
 > 
