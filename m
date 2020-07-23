Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D08422BA2D
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 01:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgGWXWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 19:22:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53896 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgGWXWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 19:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595546539; x=1627082539;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/iyoglcxkS318Sg6qJHiPt3/SwDfA+JjozFFVeV5pMY=;
  b=oud/p3PaQA2IdECPHtFnsW/vYe9neqgVM0hNfVbUTDAGNNyXIvlL6h44
   XL5hQaOolJNAFw/Wvx6ys11fJa6frBG1q8kADPZVeWLPtkSZxf85ZOwuz
   jwfVzVX8522wBpaL/TwuRxGhmvoU3qT5tseW8yZ3zS2zEdZXgbEEUdenK
   VpWONNnA4qnoRsradMe5p9/tmHz3kJ8h8g2U3E36lP2NMa0hPnqBAewoo
   gLSBx/sMIgF5WQNa+V+LulvRzcOS1ojsvAfUzC8bKqjoNVgXZrsRuK34j
   6kogCB15refiqLv9fOhJuiUI/DUB2MINi98HVbyFlACgqgf6GRGJuNk4i
   Q==;
IronPort-SDR: E6xkxJhAvk9IlxlmmSNdZvH60YJz0d86nUEb+WOlVOVOWlmPoC1UU1Z7TvxOeXJ7whK45egdpJ
 mZfBUXqp2OA3qVlY+oVog6Ouusc80hYpMzTCg+q1x7LPlnO7rKVD9lkmQUrOfmX2Ve8NxS5kWm
 3+O1Weph0AMGPrwFAZo1JxFn7vopuVLZjr3kn9CxlpPrVxqalFOGB4I1BFyvJ0rij95RRKknlc
 4tnj3cgA2cF08C2Jrhor8mVUMydx3dTDcblT76YB9dY4OKsVo5TQNMJ/iuC7HbUAGM+szMz2Cx
 SR4=
X-IronPort-AV: E=Sophos;i="5.75,388,1589212800"; 
   d="scan'208";a="252546067"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jul 2020 07:22:19 +0800
IronPort-SDR: IdIlcPUalfm/E3xDxAJnovdA1QJlRREpBk3ZaOD4vPpIxTIfYPQ/TrBqH5v1IZyPLH7Ot5Hsgj
 MSVAd6M7mz/vKe12i5bB53cZ9xXT/Rk8E=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:10:33 -0700
IronPort-SDR: jN5CtwZpnd+5N/goMHUWZJYQbmHItg8c2A91kwQxZACRbomktFOQsOgxQ5XD6qEzTP31o6d/nC
 A3tRmg5flFsg==
WDCIronportException: Internal
Received: from unknown (HELO redsun52) ([10.149.66.28])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:22:18 -0700
Date:   Fri, 24 Jul 2020 00:22:15 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@wdc.com>
To:     linux-riscv@lists.infradead.org
cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr' access
In-Reply-To: <alpine.LFD.2.21.2007232038170.24175@redsun52.ssa.fujisawa.hgst.com>
Message-ID: <alpine.DEB.2.20.2007232213510.4462@tpp.orcam.me.uk>
References: <alpine.LFD.2.21.2007232038170.24175@redsun52.ssa.fujisawa.hgst.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adjust the calls to `user_regset_copyout' and `user_regset_copyin' in 
`riscv_fpr_get' and `riscv_fpr_set' respectively so as to use @start_pos 
and @end_pos according to API documentation in <linux/regset.h>, that is 
to point at the beginning and the end respectively of the data chunk to 
be copied.  Update @data accordingly, also for the first call, to make 
it clear which structure member is accessed.

We currently have @start_pos fixed at 0 across all calls, which works as 
a result of the implementation, in particular because we have no padding 
between the FP general registers and the FP control and status register, 
but appears not to have been the intent of the API and is not what other 
ports do, requiring one to study the copy handlers to understand what is 
going on here.

Signed-off-by: Maciej W. Rozycki <macro@wdc.com>
Fixes: b8c8a9590e4f ("RISC-V: Add FP register ptrace support for gdb.")
Cc: stable@vger.kernel.org # 4.20+
---
 arch/riscv/kernel/ptrace.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

linux-riscv-ptrace-fcsr.diff
Index: linux-hv/arch/riscv/kernel/ptrace.c
===================================================================
--- linux-hv.orig/arch/riscv/kernel/ptrace.c
+++ linux-hv/arch/riscv/kernel/ptrace.c
@@ -61,10 +61,13 @@ static int riscv_fpr_get(struct task_str
 	int ret;
 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
 
-	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, fstate, 0,
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &fstate->f, 0,
 				  offsetof(struct __riscv_d_ext_state, fcsr));
 	if (!ret) {
-		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, fstate, 0,
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &fstate->fcsr,
+					  offsetof(struct __riscv_d_ext_state,
+						   fcsr),
 					  offsetof(struct __riscv_d_ext_state, fcsr) +
 					  sizeof(fstate->fcsr));
 	}
@@ -80,10 +83,13 @@ static int riscv_fpr_set(struct task_str
 	int ret;
 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
 
-	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, fstate, 0,
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &fstate->f, 0,
 				 offsetof(struct __riscv_d_ext_state, fcsr));
 	if (!ret) {
-		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, fstate, 0,
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					 &fstate->fcsr,
+					 offsetof(struct __riscv_d_ext_state,
+						  fcsr),
 					 offsetof(struct __riscv_d_ext_state, fcsr) +
 					 sizeof(fstate->fcsr));
 	}
