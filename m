Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBDF61582E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiKBCql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiKBCql (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB772125B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB1B617C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA79C433D7;
        Wed,  2 Nov 2022 02:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357199;
        bh=rPwsAuXBdAxHOu4HqODLXq9b/f1Z/opJOxoOykonSVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nFyPAGgWTecSd2K6nWuBpc9FSYXh4fRd2BPoSOG3jqMDQyEf5wpiu8xUmMC1VQmO
         yY8uignaF9mDE0EUVuLqEA9j56dezJg3FCv4xRcgZuo3DzXBLU0JUOLiVD3xBFqatV
         doPYm0u9Py/ziCEb6WdaMdBS4HFIdom1zCw8nuxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gavin Shan <gshan@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 130/240] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
Date:   Wed,  2 Nov 2022 03:31:45 +0100
Message-Id: <20221102022114.321862668@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit 05c2224d4b049406b0545a10be05280ff4b8ba0a ]

It's required by vm_userspace_mem_region_add() that memory size
should be aligned to host page size. However, one guest page is
provided by memslot_modification_stress_test. It triggers failure
in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
as the following messages indicate.

 # ./memslot_modification_stress_test
 Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
 guest physical test memory: [0xffbfff0000, 0xffffff0000)
 Finished creating vCPUs
 Started all vCPUs
 ==== Test Assertion Failure ====
   lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
   pid=5712 tid=5712 errno=0 - Success
      1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
      2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
      3	 (inlined by) run_test at memslot_modification_stress_test.c:110
      4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
      5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
      6	0x0000ffffb8cd4383: ?? ??:0
      7	0x0000000000401827: _start at :?
   Number of guest pages is not compatible with the host. Try npages=16

Fix the issue by providing 16 guest pages to the memory slot for this
particular combination of 64KB-page-size-host and 4KB-page-size-guest
on aarch64.

Fixes: ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221013063020.201856-1-gshan@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde404..bb1d17a1171b 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -67,7 +67,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	const uint64_t pages = 1;
+	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
 	uint64_t gpa;
 	int i;
 
-- 
2.35.1



