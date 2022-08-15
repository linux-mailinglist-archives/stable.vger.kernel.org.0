Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5BB593D81
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbiHOUNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347046AbiHOUMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298328A6F6;
        Mon, 15 Aug 2022 11:58:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6655B6126A;
        Mon, 15 Aug 2022 18:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F3C433D6;
        Mon, 15 Aug 2022 18:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589931;
        bh=+GXNjbHUTKV1L2+1A30K3LneaVHLN5tQdbVxlRebuCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFzGYtgJUEbaydHODiXDRUORx151z2ZMoi1Au3+lqTvxAYbYI79OzX5GY48P7778t
         TUWrm7SM+QeChE5J8CzTbPk2PMVqY8yWNij8pSJmJvu5GrPdtSTQtu61SHV9STAFIW
         fVuBHxrk9tmrtrFWgMlemADOfr4l3HcgNGOQKjCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0065/1095] RISC-V: Declare cpu_ops_spinwait in <asm/cpu_ops.h>
Date:   Mon, 15 Aug 2022 19:51:04 +0200
Message-Id: <20220815180432.187936691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ben Dooks <ben.dooks@sifive.com>

commit da6d2128e56a50a0d497c8e41ca1d33d88bcc0aa upstream.

The cpu_ops_spinwait is used in a couple of places in arch/riscv
and is causing a sparse warning due to no declaration. Add this
to <asm/cpu_ops.h> with the others to fix the following:

arch/riscv/kernel/cpu_ops_spinwait.c:16:29: warning: symbol 'cpu_ops_spinwait' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Link: https://lore.kernel.org/r/20220714071811.187491-1-ben.dooks@sifive.com
[Palmer: Drop the extern from cpu_ops.c]
Fixes: 2ffc48fc7071 ("RISC-V: Move spinwait booting method to its own config")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/cpu_ops.h | 1 +
 arch/riscv/kernel/cpu_ops.c      | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/cpu_ops.h b/arch/riscv/include/asm/cpu_ops.h
index 134590f1b843..aa128466c4d4 100644
--- a/arch/riscv/include/asm/cpu_ops.h
+++ b/arch/riscv/include/asm/cpu_ops.h
@@ -38,6 +38,7 @@ struct cpu_operations {
 #endif
 };
 
+extern const struct cpu_operations cpu_ops_spinwait;
 extern const struct cpu_operations *cpu_ops[NR_CPUS];
 void __init cpu_set_ops(int cpu);
 
diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
index 170d07e57721..f92c0e6eddb1 100644
--- a/arch/riscv/kernel/cpu_ops.c
+++ b/arch/riscv/kernel/cpu_ops.c
@@ -15,9 +15,7 @@
 const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
 
 extern const struct cpu_operations cpu_ops_sbi;
-#ifdef CONFIG_RISCV_BOOT_SPINWAIT
-extern const struct cpu_operations cpu_ops_spinwait;
-#else
+#ifndef CONFIG_RISCV_BOOT_SPINWAIT
 const struct cpu_operations cpu_ops_spinwait = {
 	.name		= "",
 	.cpu_prepare	= NULL,
-- 
2.37.1



