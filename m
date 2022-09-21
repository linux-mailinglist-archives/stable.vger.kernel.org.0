Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A935C0335
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiIUQAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiIUP6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FFBA0337;
        Wed, 21 Sep 2022 08:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67A11CE1DEC;
        Wed, 21 Sep 2022 15:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565CFC433C1;
        Wed, 21 Sep 2022 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775443;
        bh=1T/Z2KvEm7OGMVSlMdj+JwHx3mo6B4tq2QxqS58Qryo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNEnyGujhXFGUJKaOFxdD1WcBoXGl7lnSu/7cjFqJLgNVhGKUKu1Y37jdeOOO/C0q
         6gHeDUNgKBRFRASwfjOV/8/Zgo90eXidqv1YqKmgZJkFps/EW/tKi0+HaX/P1SHUJ8
         bS/NQIFoxoBen30jpD9RWQLppxMuX3i768pML+kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/39] KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs
Date:   Wed, 21 Sep 2022 17:46:06 +0200
Message-Id: <20220921153645.732495616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 112665286d08c87e66d699e7cba43c1497ad165f ]

Interrupts that occur in kernel mode expect that context tracking
is set to kernel. Enabling local irqs before context tracking
switches from guest to host means interrupts can come in and trigger
warnings about wrong context, and possibly worse.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210130130852.2952424-3-npiggin@gmail.com
Stable-dep-of: 235cee162459 ("KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 38b7a3491aac..d6c4e27f7ed9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3399,8 +3399,9 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
+	guest_exit_irqoff();
+
 	local_irq_enable();
-	guest_exit();
 
 	/* Let secondaries go back to the offline loop */
 	for (i = 0; i < controlled_threads; ++i) {
@@ -4235,8 +4236,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_set_host_core(pcpu);
 
+	guest_exit_irqoff();
+
 	local_irq_enable();
-	guest_exit();
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
-- 
2.35.1



