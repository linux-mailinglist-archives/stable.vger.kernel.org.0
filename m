Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7EF4ABCB4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387050AbiBGLiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385743AbiBGLcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44084C0401C0;
        Mon,  7 Feb 2022 03:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAB5F60C8E;
        Mon,  7 Feb 2022 11:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A75FC004E1;
        Mon,  7 Feb 2022 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233541;
        bh=lQLt55YV7KRT1YQaDNzbRPxe1nnNFn1F6OImQ/QhjhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po0+TQeNXbuz2YREVx/MdCUjaX8E2GUek+Awkz3oK1m4q70j8YBG3wv2ns+SAcxWW
         WfhWJ1iPYJ2QRQkQGAQdU7E7m8H/psJihWRpOQbqxLo4TafN4Ew+0O+XXRnEw2tjc4
         8MAeX5QznbsMqtcKKnYtFs9F1Nci9b7JfJxmgzw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>
Subject: [PATCH 5.16 044/126] RISC-V: KVM: make CY, TM, and IR counters accessible in VU mode
Date:   Mon,  7 Feb 2022 12:06:15 +0100
Message-Id: <20220207103805.643776076@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mayuresh Chitale <mchitale@ventanamicro.com>

commit de1d7b6a51dab546160d252e47baa54adf104d4a upstream.

Those applications that run in VU mode and access the time CSR cause
a virtual instruction trap as Guest kernel currently does not
initialize the scounteren CSR.

To fix this, we should make CY, TM, and IR counters accessibile
by default in VU mode (similar to OpenSBI).

Fixes: a33c72faf2d73 ("RISC-V: KVM: Implement VCPU create, init and
destroy functions")
Cc: stable@vger.kernel.org
Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -74,6 +74,7 @@ int kvm_arch_vcpu_precreate(struct kvm *
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *cntx;
+	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
@@ -89,6 +90,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	/* By default, make CY, TM, and IR counters accessible in VU mode */
+	reset_csr->scounteren = 0x7;
+
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 


