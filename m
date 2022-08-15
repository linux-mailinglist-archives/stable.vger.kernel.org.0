Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409185943F6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245152AbiHOWDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350418AbiHOWCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1BE27CCA;
        Mon, 15 Aug 2022 12:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F207EB80EA8;
        Mon, 15 Aug 2022 19:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC6C433C1;
        Mon, 15 Aug 2022 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592193;
        bh=BquEyuFVINTO9pj6c/C0lL1koQzpgtW1m20hzVLlITU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euS0r8B2uZfnkCb2hU4L9YbPD3htWGDoiEKJAxEUBJR3LIKrkgxvkbQOOVrXEuNZV
         S1mOBahi6vvC9k271699F/YB48j6DpafA3QCjFQ9EP2bRq8xXPAw4AgGLH9+mXS6rW
         tCCnWQdoU1ib8LshGNCkNkf9rz/8Fe0oE4JroKXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 0072/1157] RISC-V: Declare cpu_ops_spinwait in <asm/cpu_ops.h>
Date:   Mon, 15 Aug 2022 19:50:28 +0200
Message-Id: <20220815180442.405075717@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 arch/riscv/include/asm/cpu_ops.h |    1 +
 arch/riscv/kernel/cpu_ops.c      |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/riscv/include/asm/cpu_ops.h
+++ b/arch/riscv/include/asm/cpu_ops.h
@@ -38,6 +38,7 @@ struct cpu_operations {
 #endif
 };
 
+extern const struct cpu_operations cpu_ops_spinwait;
 extern const struct cpu_operations *cpu_ops[NR_CPUS];
 void __init cpu_set_ops(int cpu);
 
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


