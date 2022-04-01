Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2124EF03C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiDAOe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347308AbiDAOcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831DD4ECF2;
        Fri,  1 Apr 2022 07:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B3AEB82505;
        Fri,  1 Apr 2022 14:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5287FC3410F;
        Fri,  1 Apr 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823313;
        bh=1TNaHoTjmLLAXXqU3dSJXOFgOgLAz7DHgZlECxIiXwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMvfsC3sWV0qnFOGaqxYlGC7Nau39n7Za1HWl82D9VxDhGz165+CR2MMq6XXLpXCe
         VPQBrUKwv4OZ8PkefaQFy88MCNaKn+hMfcwcOIeVZj8TVVnxaG0Dua22gtY/MGaUrC
         YT/bZW4JfXreESeZT4XfE1jhD4yQxgFekn0mzCcggp3eIO2+eKXx2PALxIUb3VCNaH
         Wxx3kP2d5JGsj6LI14522Et2qdp6m3Hw/sL1oZ8ugx8ekEkbX6NiokGBgXOGI+2EH/
         /LnT/Ft/64TfgyGSoFyBBmprRibLciSBKZwoZZkfO3dIWK3JZsNJk3cd4SyIdy9Ai2
         iKlUW42KWT6KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pbonzini@redhat.com, shuah@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 053/149] kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
Date:   Fri,  1 Apr 2022 10:24:00 -0400
Message-Id: <20220401142536.1948161-53-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit 11024a7a0ac26dd31ddfa0f6590e158bdf9ab858 ]

The guest in vgic_irq gets its arguments in a struct. This struct used
to fit nicely in a single register so vcpu_args_set() was able to pass
it by value by setting x0 with it. Unfortunately, this args struct grew
after some commits and some guest args became random (specically
kvm_supports_irqfd).

Fix this by passing the guest args as a pointer (after allocating some
guest memory for it).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-3-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 7eca97799917..7f3afee5cc00 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -472,10 +472,10 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
 		guest_restore_active(args, MIN_SPI, 4, f->cmd);
 }
 
-static void guest_code(struct test_args args)
+static void guest_code(struct test_args *args)
 {
-	uint32_t i, nr_irqs = args.nr_irqs;
-	bool level_sensitive = args.level_sensitive;
+	uint32_t i, nr_irqs = args->nr_irqs;
+	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
 	gic_init(GIC_V3, 1, dist, redist);
@@ -484,11 +484,11 @@ static void guest_code(struct test_args args)
 		gic_irq_enable(i);
 
 	for (i = MIN_SPI; i < nr_irqs; i++)
-		gic_irq_set_config(i, !args.level_sensitive);
+		gic_irq_set_config(i, !level_sensitive);
 
-	gic_set_eoi_split(args.eoi_split);
+	gic_set_eoi_split(args->eoi_split);
 
-	reset_priorities(&args);
+	reset_priorities(args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	inject_fns  = level_sensitive ? inject_level_fns
@@ -497,17 +497,17 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_supported_inject_fn(&args, inject_fns, f) {
-		test_injection(&args, f);
-		test_preemption(&args, f);
-		test_injection_failure(&args, f);
+	for_each_supported_inject_fn(args, inject_fns, f) {
+		test_injection(args, f);
+		test_preemption(args, f);
+		test_injection_failure(args, f);
 	}
 
 	/* Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
-	for_each_supported_activate_fn(&args, set_active_fns, f)
-		test_restore_active(&args, f);
+	for_each_supported_activate_fn(args, set_active_fns, f)
+		test_restore_active(args, f);
 
 	GUEST_DONE();
 }
@@ -739,6 +739,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	int gic_fd;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
+	vm_vaddr_t args_gva;
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
@@ -757,7 +758,9 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
 	/* Setup the guest args page (so it gets the args). */
-	vcpu_args_set(vm, 0, 1, args);
+	args_gva = vm_vaddr_alloc_page(vm);
+	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
+	vcpu_args_set(vm, 0, 1, args_gva);
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
-- 
2.34.1

