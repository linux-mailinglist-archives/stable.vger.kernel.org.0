Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A76015EB1
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 09:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfEGH7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 03:59:16 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:44712 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfEGH7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 03:59:16 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id x477wKuY027108; Tue, 7 May 2019 16:58:20 +0900
X-Iguazu-Qid: 2wHI0pXS3IUcaJjLn7
X-Iguazu-QSIG: v=2; s=0; t=1557215900; q=2wHI0pXS3IUcaJjLn7; m=VD7dm5karpU23Jq4iN2T2Siy1/GaUeeEYAjr0nZDb48=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1112) id x477wGdw019508;
        Tue, 7 May 2019 16:58:16 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id x477wC2N020685;
        Tue, 7 May 2019 16:58:16 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id x477wBRe022866;
        Tue, 7 May 2019 16:58:12 +0900
Date:   Tue, 7 May 2019 16:58:09 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Qian Cai <cai@lca.pw>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Avi Kivity <avi@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 62/99] kmemleak: powerpc: skip scanning holes in the
 .bss section
X-TSB-HOP: ON
Message-ID: <20190507071925.irtu4gpc7tijmpbw@toshiba.co.jp>
References: <20190506143053.899356316@linuxfoundation.org>
 <20190506143059.710412844@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506143059.710412844@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, May 06, 2019 at 04:32:35PM +0200, Greg Kroah-Hartman wrote:
> [ Upstream commit 298a32b132087550d3fa80641ca58323c5dfd4d9 ]
> 
> Commit 2d4f567103ff ("KVM: PPC: Introduce kvm_tmp framework") adds
> kvm_tmp[] into the .bss section and then free the rest of unused spaces
> back to the page allocator.
> 
> kernel_init
>   kvm_guest_init
>     kvm_free_tmp
>       free_reserved_area
>         free_unref_page
>           free_unref_page_prepare
> 
> With DEBUG_PAGEALLOC=y, it will unmap those pages from kernel.  As the
> result, kmemleak scan will trigger a panic when it scans the .bss
> section with unmapped pages.
> 
> This patch creates dedicated kmemleak objects for the .data, .bss and
> potentially .data..ro_after_init sections to allow partial freeing via
> the kmemleak_free_part() in the powerpc kvm_free_tmp() function.
> 
> Link: http://lkml.kernel.org/r/20190321171917.62049-1-catalin.marinas@arm.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Tested-by: Qian Cai <cai@lca.pw>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/powerpc/kernel/kvm.c |  7 +++++++
>  mm/kmemleak.c             | 16 +++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)

This commit has other problems, so we also need the following commits:

commit dce5b0bdeec61bdbee56121ceb1d014151d5cab1
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Apr 18 17:50:48 2019 -0700

    mm/kmemleak.c: fix unused-function warning

    The only references outside of the #ifdef have been removed, so now we
    get a warning in non-SMP configurations:

      mm/kmemleak.c:1404:13: error: unused function 'scan_large_block' [-Werror,-Wunused-function]

    Add a new #ifdef around it.

    Link: http://lkml.kernel.org/r/20190416123148.3502045-1-arnd@arndb.de
    Fixes: 298a32b13208 ("kmemleak: powerpc: skip scanning holes in the .bss section")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
    Cc: Michael Ellerman <mpe@ellerman.id.au>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Please apply this commit.

Best regards,
  Nobuhiro
 
