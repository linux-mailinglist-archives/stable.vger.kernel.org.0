Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF07A6AF586
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjCGT0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjCGT0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:26:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A5A8820
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73EA3CE1C82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7472EC433D2;
        Tue,  7 Mar 2023 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216331;
        bh=f8D20QC3CJzX/ndMRx1yYHKDtzyAqslqUxzqFV+byVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJkIvW+ijgu//Wk7v8N5ZtPzmXnWtlwYJvmZ60s5+RU7R651TCRBoqJGq8P72ibhX
         sFMO/ytKv6EwzRXRck5KOZiJguntR3ym6ulAqcvXE4BlVIffzHNLYcUofkMjDZMfUU
         nMSY1SEMSqwGE2DCMoRfc/PbQ+dJxkm7UYwbwz/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 550/567] RISC-V: add a spin_shadow_stack declaration
Date:   Tue,  7 Mar 2023 18:04:46 +0100
Message-Id: <20230307165929.809074992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

commit eb9be8310c58c166f9fae3b71c0ad9d6741b4897 upstream.

The patchwork automation reported a sparse complaint that
spin_shadow_stack was not declared and should be static:
../arch/riscv/kernel/traps.c:335:15: warning: symbol 'spin_shadow_stack' was not declared. Should it be static?

However, this is used in entry.S and therefore shouldn't be static.
The same applies to the shadow_stack that this pseudo spinlock is
trying to protect, so do like its charge and add a declaration to
thread_info.h

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: 7e1864332fbc ("riscv: fix race when vmap stack overflow")
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230210185945.915806-1-conor@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/thread_info.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -43,6 +43,7 @@
 #ifndef __ASSEMBLY__
 
 extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+extern unsigned long spin_shadow_stack;
 
 #include <asm/processor.h>
 #include <asm/csr.h>


