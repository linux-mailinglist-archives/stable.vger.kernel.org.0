Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5DE6432D0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiLETaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiLET3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26439B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A33886131D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EABC433D6;
        Mon,  5 Dec 2022 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268364;
        bh=HOVv4pLwTNJJu8TLRCYMflyBjWrNteM0Yu3djjxzXwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QL7majOjPTh5g0+HQs9LCzsuwViMTBbr10KKoJfy5XeemaHXP+fG4lvwQyoFfLhu9
         jBulWcRK2RY4Hk/WWc6M/2OfBFC5KnjlICeflPvVmbGtHwrsE2Vmzq+lJ7spOMiJFj
         r6ay121rl6KPEZ3Ao2QfrMGgm4UIroWQT047MTCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 075/124] riscv: vdso: fix section overlapping under some conditions
Date:   Mon,  5 Dec 2022 20:09:41 +0100
Message-Id: <20221205190810.553127111@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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
 arch/riscv/kernel/vdso/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,7 @@ vdso-syms += flush_icache
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
 ccflags-y := -fno-stack-protector
+ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)


