Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E920D17E87C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgCITbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:31:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37951 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgCITbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:31:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AE23E21FF3;
        Mon,  9 Mar 2020 15:31:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 15:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2f0HdX
        OGTUt0nmR9vpJvDdkDcQzf/+HOk3IksvAdLCs=; b=3Nv5nMN2UwN6VLOhH0QL+Q
        HI41O3u+cg+6h2gtnBPH9HCEoJX/GlChwZSLkWW0OL7i4SZRNFEyqkrkPLsfqoPR
        GmySHtM50Efvks5WW2sAP5tq3R0MIedpFvPqLbFkZ815xS7E1bjyaEi0bB26Jijd
        Vd95Y8FwGQ4XAWr5tU1LXEVGhbTRB/nsyEmrZ5xArI12UxnK9zd/NN0elVbbLCLu
        KKK9+9Xyd6Mxvfg0l10JSB/9/UI//+iIbVQeGCg9QPgAdrVYF1DTf7hW/LqO7tV4
        ckGn/zQTmgJebZPj1iLdvcDI1Mu7adBoPwM6WvkxtCM8xqlsTw2CXO3Uw+5TPLkA
        ==
X-ME-Sender: <xms:mZlmXhCaVfpxL3D8yGkf2N8vvpsL5_gK30aZ1TIaFr1uhZQpanKljw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mZlmXnJxVF13r1Ju1qqlTWxSANNfDNfTyqVA3_cTSTQsKu_mvd6agA>
    <xmx:mZlmXszAwSH5mCe_zXL554qeOcjNG8H_jY_l4spDbvSulNLTW3HnuQ>
    <xmx:mZlmXjxEiH1wW7YGFsWFqTV5NiamU-a8Y989gHlYKojbhQdY5lj34Q>
    <xmx:mZlmXmv1vpsgrLX_W3py8v8-HG56ZvO6XfNtMesy34MEaqqrAhTz5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 015B630611FB;
        Mon,  9 Mar 2020 15:31:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/mm: Fix missing KUAP disable in" failed to apply to 5.4-stable tree
To:     mpe@ellerman.id.au, stefanb@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 20:31:33 +0100
Message-ID: <15837822939038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 59bee45b9712c759ea4d3dcc4eff1752f3a66558 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue, 3 Mar 2020 23:28:47 +1100
Subject: [PATCH] powerpc/mm: Fix missing KUAP disable in
 flush_coherent_icache()

Stefan reported a strange kernel fault which turned out to be due to a
missing KUAP disable in flush_coherent_icache() called from
flush_icache_range().

The fault looks like:

  Kernel attempted to access user page (7fffc30d9c00) - exploit attempt? (uid: 1009)
  BUG: Unable to handle kernel data access on read at 0x7fffc30d9c00
  Faulting instruction address: 0xc00000000007232c
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
  CPU: 35 PID: 5886 Comm: sigtramp Not tainted 5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40 #79
  NIP:  c00000000007232c LR: c00000000003b7fc CTR: 0000000000000000
  REGS: c000001e11093940 TRAP: 0300   Not tainted  (5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40)
  MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28000884  XER: 00000000
  CFAR: c0000000000722fc DAR: 00007fffc30d9c00 DSISR: 08000000 IRQMASK: 0
  GPR00: c00000000003b7fc c000001e11093bd0 c0000000023ac200 00007fffc30d9c00
  GPR04: 00007fffc30d9c18 0000000000000000 c000001e11093bd4 0000000000000000
  GPR08: 0000000000000000 0000000000000001 0000000000000000 c000001e1104ed80
  GPR12: 0000000000000000 c000001fff6ab380 c0000000016be2d0 4000000000000000
  GPR16: c000000000000000 bfffffffffffffff 0000000000000000 0000000000000000
  GPR20: 00007fffc30d9c00 00007fffc30d8f58 00007fffc30d9c18 00007fffc30d9c20
  GPR24: 00007fffc30d9c18 0000000000000000 c000001e11093d90 c000001e1104ed80
  GPR28: c000001e11093e90 0000000000000000 c0000000023d9d18 00007fffc30d9c00
  NIP flush_icache_range+0x5c/0x80
  LR  handle_rt_signal64+0x95c/0xc2c
  Call Trace:
    0xc000001e11093d90 (unreliable)
    handle_rt_signal64+0x93c/0xc2c
    do_notify_resume+0x310/0x430
    ret_from_except_lite+0x70/0x74
  Instruction dump:
  409e002c 7c0802a6 3c62ff31 3863f6a0 f8010080 48195fed 60000000 48fe4c8d
  60000000 e8010080 7c0803a6 7c0004ac <7c00ffac> 7c0004ac 4c00012c 38210070

This path through handle_rt_signal64() to setup_trampoline() and
flush_icache_range() is only triggered by 64-bit processes that have
unmapped their VDSO, which is rare.

flush_icache_range() takes a range of addresses to flush. In
flush_coherent_icache() we implement an optimisation for CPUs where we
know we don't actually have to flush the whole range, we just need to
do a single icbi.

However we still execute the icbi on the user address of the start of
the range we're flushing. On CPUs that also implement KUAP (Power9)
that leads to the spurious fault above.

We should be able to pass any address, including a kernel address, to
the icbi on these CPUs, which would avoid any interaction with KUAP.
But I don't want to make that change in a bug fix, just in case it
surfaces some strange behaviour on some CPU.

So for now just disable KUAP around the icbi. Note the icbi is treated
as a load, so we allow read access, not write as you'd expect.

Fixes: 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200303235708.26004-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index ef7b1119b2e2..1c07d5a3f543 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -373,7 +373,9 @@ static inline bool flush_coherent_icache(unsigned long addr)
 	 */
 	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE)) {
 		mb(); /* sync */
+		allow_read_from_user((const void __user *)addr, L1_CACHE_BYTES);
 		icbi((void *)addr);
+		prevent_read_from_user((const void __user *)addr, L1_CACHE_BYTES);
 		mb(); /* sync */
 		isync();
 		return true;

