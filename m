Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2C95586EC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiFWSSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiFWSQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C87B62BC0;
        Thu, 23 Jun 2022 10:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21B1E61EA7;
        Thu, 23 Jun 2022 17:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DE3C3411B;
        Thu, 23 Jun 2022 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005010;
        bh=/T/e1N9YLiwK9V5+3P5zlJujZu1xfXX+AeCN9RlNAmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srG1d5Bhc5TObdNhfbdMCpv+SEjQNlVA1bYShN721jog4vFLV0/vAPjZlDiyGfL4X
         Nk1oX8pFVqqFRLeNxf9zgTjAhSds977Z9CRDVFHRXPsWUiy+vHcxHuIRqY7h4ZDnMR
         cNaodQOE6A+wkbym6Qddv7TOZguiFKFxYyUEz16I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 223/234] RISC-V: fix barrier() use in <vdso/processor.h>
Date:   Thu, 23 Jun 2022 18:44:50 +0200
Message-Id: <20220623164349.360556198@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 30aca1bacb398dec6c1ed5eeca33f355bd7b6203 upstream.

riscv's <vdso/processor.h> uses barrier() so it should include
<asm/barrier.h>

Fixes this build error:
  CC [M]  drivers/net/ethernet/emulex/benet/be_main.o
In file included from ./include/vdso/processor.h:10,
                 from ./arch/riscv/include/asm/processor.h:11,
                 from ./include/linux/prefetch.h:15,
                 from drivers/net/ethernet/emulex/benet/be_main.c:14:
./arch/riscv/include/asm/vdso/processor.h: In function 'cpu_relax':
./arch/riscv/include/asm/vdso/processor.h:14:2: error: implicit declaration of function 'barrier' [-Werror=implicit-function-declaration]
   14 |  barrier();

This happens with a total of 5 networking drivers -- they all use
<linux/prefetch.h>.

rv64 allmodconfig now builds cleanly after this patch.

Fixes fallout from:
815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")

Fixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the latency of the time-related functions")
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
[sudip: change in old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -30,6 +30,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/barrier.h>
+
 struct task_struct;
 struct pt_regs;
 


