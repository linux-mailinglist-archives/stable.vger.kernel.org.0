Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6661250F8B9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiDZJHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347670AbiDZJGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDDA15C3A7;
        Tue, 26 Apr 2022 01:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E214AB81CF0;
        Tue, 26 Apr 2022 08:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50856C385AC;
        Tue, 26 Apr 2022 08:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962715;
        bh=zqYE2dBiFpRl4OeuEjvjF+2WlsvVq3M+PLNfL0rUOW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Qcw77QJ89XaQBUmHN54RgYBTS/UnhnkJSj77M3TMO5i8hDqS/BvmyNN6dfp7PXjq
         tg0B+75xxnGxHT8jxOgibCHVt63lYoIQ6TYUYTNz+ZCqPXpth+6kSCKLqioPMhGaw6
         hJsLUxlUfdlOF2CKXFH1loyUESyaLKouYBYV++VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 066/146] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
Date:   Tue, 26 Apr 2022 10:21:01 +0200
Message-Id: <20220426081751.920361986@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 21db83846683d3987666505a3ec38f367708199a ]

In order to correctly destroy a VM, all references to the VM must be
freed. The arch_timer selftest creates a VGIC for the guest, which
itself holds a reference to the VM.

Close the GIC FD when cleaning up a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220406235615.1447180-4-oupton@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index b08d30bf71c5..3b940a101bc0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -362,11 +362,12 @@ static void test_init_timer_irq(struct kvm_vm *vm)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
+static int gic_fd;
+
 static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
 	unsigned int i;
-	int ret;
 	int nr_vcpus = test_args.nr_vcpus;
 
 	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
@@ -383,8 +384,8 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	if (ret < 0) {
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (gic_fd < 0) {
 		print_skip("Failed to create vgic-v3");
 		exit(KSFT_SKIP);
 	}
@@ -395,6 +396,12 @@ static struct kvm_vm *test_vm_create(void)
 	return vm;
 }
 
+static void test_vm_cleanup(struct kvm_vm *vm)
+{
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
 static void test_print_help(char *name)
 {
 	pr_info("Usage: %s [-h] [-n nr_vcpus] [-i iterations] [-p timer_period_ms]\n",
@@ -478,7 +485,7 @@ int main(int argc, char *argv[])
 
 	vm = test_vm_create();
 	test_run(vm);
-	kvm_vm_free(vm);
+	test_vm_cleanup(vm);
 
 	return 0;
 }
-- 
2.35.1



