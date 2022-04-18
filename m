Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701C9505005
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiDRMUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbiDRMT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F171C92C;
        Mon, 18 Apr 2022 05:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50AFC60F07;
        Mon, 18 Apr 2022 12:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FECC385A1;
        Mon, 18 Apr 2022 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284206;
        bh=3a2v0mJy0hoCm06UP+LU9YrkWPFsjP8HGnh6ARG1qAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1m5o8OZE72Vqsa+C+x2DG+IzZYSFnxNDaIlBvRrhuBRAKX5ugMXO3zAIVcpipgmD
         w2/R3zEAs3dGQZ87niJNayTbw1SBKmlCsChOSyDOtOUOUR1Ld9uLDs7sp4QjsFZhnV
         U21ulhCrRSvVGA/FvDkkNPlMvdhSNUp9zz1Vhi4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>
Subject: [PATCH 5.17 010/219] RISC-V: KVM: Dont clear hgatp CSR in kvm_arch_vcpu_put()
Date:   Mon, 18 Apr 2022 14:09:39 +0200
Message-Id: <20220418121203.767117836@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Anup Patel <apatel@ventanamicro.com>

commit 8c3ce496bd612bd21679e445f75fcabb6be997b2 upstream.

We might have RISC-V systems (such as QEMU) where VMID is not part
of the TLB entry tag so these systems will have to flush all TLB
entries upon any change in hgatp.VMID.

Currently, we zero-out hgatp CSR in kvm_arch_vcpu_put() and we
re-program hgatp CSR in kvm_arch_vcpu_load(). For above described
systems, this will flush all TLB entries whenever VCPU exits to
user-space hence reducing performance.

This patch fixes above described performance issue by not clearing
hgatp CSR in kvm_arch_vcpu_put().

Fixes: 34bde9d8b9e6 ("RISC-V: KVM: Implement VCPU world-switch")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -653,8 +653,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *
 				     vcpu->arch.isa);
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
 
-	csr_write(CSR_HGATP, 0);
-
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
 	csr->vsie = csr_read(CSR_VSIE);
 	csr->vstvec = csr_read(CSR_VSTVEC);


