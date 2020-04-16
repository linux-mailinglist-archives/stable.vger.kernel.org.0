Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA7C1ACAE1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395426AbgDPPkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897479AbgDPNhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D48B20732;
        Thu, 16 Apr 2020 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044251;
        bh=ZSidY9B/9jET69cPgLCQBHpYzngw+ATiuDUI9F+CWkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0Ot34QgDa3wfFTVd8y+eLGCuy0eC1Z9xfZcjJDJUlpkhK8s+M0CWaMCW17FRVoBG
         DZa+fQLlt5UHpghkVv5iy3jy426Pxy80R2HaYqkTIMYbsK8yR8eSmzxsdfD11mPk1Y
         +4DjHkuK5No4CiqWQ8urQ79odLD1b/G8g228nmeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.5 142/257] KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supported
Date:   Thu, 16 Apr 2020 15:23:13 +0200
Message-Id: <20200416131344.179121663@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

commit 9bee484b280a059c1faa10ae174af4f4af02c805 upstream.

kvmppc_uvmem_init checks for Ultravisor support and returns early if
it is not present. Calling kvmppc_uvmem_free at module exit will cause
an Oops:

$ modprobe -r kvm-hv

  Oops: Kernel access of bad area, sig: 11 [#1]
  <snip>
  NIP:  c000000000789e90 LR: c000000000789e8c CTR: c000000000401030
  REGS: c000003fa7bab9a0 TRAP: 0300   Not tainted  (5.6.0-rc6-00033-g6c90b86a745a-dirty)
  MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24002282  XER: 00000000
  CFAR: c000000000dae880 DAR: 0000000000000008 DSISR: 40000000 IRQMASK: 1
  GPR00: c000000000789e8c c000003fa7babc30 c0000000016fe500 0000000000000000
  GPR04: 0000000000000000 0000000000000006 0000000000000000 c000003faf205c00
  GPR08: 0000000000000000 0000000000000001 000000008000002d c00800000ddde140
  GPR12: c000000000401030 c000003ffffd9080 0000000000000001 0000000000000000
  GPR16: 0000000000000000 0000000000000000 000000013aad0074 000000013aaac978
  GPR20: 000000013aad0070 0000000000000000 00007fffd1b37158 0000000000000000
  GPR24: 000000014fef0d58 0000000000000000 000000014fef0cf0 0000000000000001
  GPR28: 0000000000000000 0000000000000000 c0000000018b2a60 0000000000000000
  NIP [c000000000789e90] percpu_ref_kill_and_confirm+0x40/0x170
  LR [c000000000789e8c] percpu_ref_kill_and_confirm+0x3c/0x170
  Call Trace:
  [c000003fa7babc30] [c000003faf2064d4] 0xc000003faf2064d4 (unreliable)
  [c000003fa7babcb0] [c000000000400e8c] dev_pagemap_kill+0x6c/0x80
  [c000003fa7babcd0] [c000000000401064] memunmap_pages+0x34/0x2f0
  [c000003fa7babd50] [c00800000dddd548] kvmppc_uvmem_free+0x30/0x80 [kvm_hv]
  [c000003fa7babd80] [c00800000ddcef18] kvmppc_book3s_exit_hv+0x20/0x78 [kvm_hv]
  [c000003fa7babda0] [c0000000002084d0] sys_delete_module+0x1d0/0x2c0
  [c000003fa7babe20] [c00000000000b9d0] system_call+0x5c/0x68
  Instruction dump:
  3fc2001b fb81ffe0 fba1ffe8 fbe1fff8 7c7f1b78 7c9c2378 3bde4560 7fc3f378
  f8010010 f821ff81 486249a1 60000000 <e93f0008> 7c7d1b78 712a0002 40820084
  ---[ end trace 5774ef4dc2c98279 ]---

So this patch checks if kvmppc_uvmem_init actually allocated anything
before running kvmppc_uvmem_free.

Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure guests")
Cc: stable@vger.kernel.org # v5.5+
Reported-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Tested-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_uvmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -778,6 +778,9 @@ out:
 
 void kvmppc_uvmem_free(void)
 {
+	if (!kvmppc_uvmem_bitmap)
+		return;
+
 	memunmap_pages(&kvmppc_uvmem_pgmap);
 	release_mem_region(kvmppc_uvmem_pgmap.res.start,
 			   resource_size(&kvmppc_uvmem_pgmap.res));


