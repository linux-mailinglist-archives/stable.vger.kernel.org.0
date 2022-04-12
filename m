Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710254FD8D2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353014AbiDLHqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356786AbiDLHjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E852B27;
        Tue, 12 Apr 2022 00:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28451616AB;
        Tue, 12 Apr 2022 07:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360CCC385A5;
        Tue, 12 Apr 2022 07:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747410;
        bh=UAk1/Hdbn8RRHBz5aFkzey4goUKMCj9JeYfNWYuPX58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ie/t0It/Wc87IJ42DIek7FguFazDg/iO2ENeX5Up1mE/KAjZsGODNL0IZHrIeJ+dR
         B/NCvnGi0Mx0ptRwpwib8fAi4XKHe9DlD3yPNW8GVixpalMCjxyXS9CQceLdWWtYvR
         sAm6Weuvo+UMsDr3SfWCs1RUOL6qG/ZaQKk5WnCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 062/343] kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
Date:   Tue, 12 Apr 2022 08:28:00 +0200
Message-Id: <20220412062952.892696936@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
2.35.1



