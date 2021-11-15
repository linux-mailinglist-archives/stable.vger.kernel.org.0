Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD54545223D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345427AbhKPBKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245100AbhKOTTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A41D63502;
        Mon, 15 Nov 2021 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000903;
        bh=Jbd0XzbgPEl7d8y6htMcCu4QkvmMC9zLwenjssqKUgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF2BIPsk4Xwy8AdrWg5+b7wnpr6O1tOCcXKLWybZldKoLGcJFh0km2cYVN0Wez7f3
         8QSbAEFj7+Z9+Bc3R7dMNJA1d/Da3WAlk9kYkUXEUhJnXnLABsAnjxjmSYVyVjS+al
         j0jFGdKPz8ZZrO7x+oPgLiuwFCNph0/aomRnGHSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 836/849] powerpc/bpf: Fix write protecting JIT code
Date:   Mon, 15 Nov 2021 18:05:19 +0100
Message-Id: <20211115165448.519522940@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

commit 44a8214de96bafb5210e43bfa2c97c19bf75af3d upstream.

Running program with bpf-to-bpf function calls results in data access
exception (0x300) with the below call trace:

  bpf_int_jit_compile+0x238/0x750 (unreliable)
  bpf_check+0x2008/0x2710
  bpf_prog_load+0xb00/0x13a0
  __sys_bpf+0x6f4/0x27c0
  sys_bpf+0x2c/0x40
  system_call_exception+0x164/0x330
  system_call_vectored_common+0xe8/0x278

as bpf_int_jit_compile() tries writing to write protected JIT code
location during the extra pass.

Fix it by holding off write protection of JIT code until the extra
pass, where branch target addresses fixup happens.

Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211025055649.114728-1-hbathini@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -241,8 +241,8 @@ skip_codegen_passes:
 	fp->jited_len = alloclen;
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
-	bpf_jit_binary_lock_ro(bpf_hdr);
 	if (!fp->is_func || extra_pass) {
+		bpf_jit_binary_lock_ro(bpf_hdr);
 		bpf_prog_fill_jited_linfo(fp, addrs);
 out_addrs:
 		kfree(addrs);


