Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F97D643342
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbiLETfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiLETe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF1B29CAF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDF9361307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1340C433D6;
        Mon,  5 Dec 2022 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268647;
        bh=7gv1xfDN5Bt5AFxAltxGTnGqlfzFNIi27KSRVfTryN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+x2yaUX1Mrx8A+fYXYfCb+wgbbvPBE2dl5uQRCgwn0uMjRDiuSaemKOUpyLGMgKK
         7AT6fUjtdz0DXLB6a1HFGfYEiAZNU6Df5kCtWFiDDgrltBnEcfWFqUr0f9UHKqaqs4
         9gfplrBCSIxrqrepG/lSuymghYfjK9ib1KIbq5vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 54/92] riscv: vdso: fix section overlapping under some conditions
Date:   Mon,  5 Dec 2022 20:10:07 +0100
Message-Id: <20221205190805.303179359@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

commit 74f6bb55c834da6d4bac24f44868202743189b2b upstream.

lkp reported a build error, I tried the config and can reproduce
build error as below:

  VDSOLD  arch/riscv/kernel/vdso/vdso.so.dbg
ld.lld: error: section .note file range overlaps with .text
>>> .note range is [0x7C8, 0x803]
>>> .text range is [0x800, 0x1993]

ld.lld: error: section .text file range overlaps with .dynamic
>>> .text range is [0x800, 0x1993]
>>> .dynamic range is [0x808, 0x937]

ld.lld: error: section .note virtual address range overlaps with .text
>>> .note range is [0x7C8, 0x803]
>>> .text range is [0x800, 0x1993]

Fix it by setting DISABLE_BRANCH_PROFILING which will disable branch
tracing for vdso, thus avoid useless _ftrace_annotated_branch section
and _ftrace_branch section. Although we can also fix it by removing
the hardcoded .text begin address, but I think that's another story
and should be put into another patch.

Link: https://lore.kernel.org/lkml/202210122123.Cc4FPShJ-lkp@intel.com/#r
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221102170254.1925-1-jszhang@kernel.org
Fixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the latency of the time-related functions")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index db6548509bb3..06e6b27f3bcc 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,7 @@ vdso-syms += flush_icache
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
 ccflags-y := -fno-stack-protector
+ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
-- 
2.38.1



