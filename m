Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E104C75C2
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiB1R4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240756AbiB1Rye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68F550065;
        Mon, 28 Feb 2022 09:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D769B815B8;
        Mon, 28 Feb 2022 17:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB00C340E7;
        Mon, 28 Feb 2022 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070176;
        bh=v+vqe5cFqVXm0aqjTyrSV3VL+XcjaDQMvZr8cnMPM2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMHp8gdfqNTT3NarGqEYlAWhBm9CHwD/QLVgvAGqaPd6gzMb/gUwKy6MumoOqpio0
         Mmrs3SNSkt+5+nWt4O7qMiTZNyTiKQru8oaW99sZjuVyGPyLN4DiyoeSbp6hBy7tXD
         9e59Aj2CBs/qWnLMnm1F4R4sAaJDZkHH0UOBw2bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang Zhang <zhangliang5@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 014/164] KVM: x86/mmu: make apf token non-zero to fix bug
Date:   Mon, 28 Feb 2022 18:22:56 +0100
Message-Id: <20220228172401.184361652@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang Zhang <zhangliang5@huawei.com>

commit 6f3c1fc53d86d580d8d6d749c4af23705e4f6f79 upstream.

In current async pagefault logic, when a page is ready, KVM relies on
kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
a READY event to the Guest. This function test token value of struct
kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
READY event is finished by Guest. If value is zero meaning that a READY
event is done, so the KVM can deliver another.
But the kvm_arch_setup_async_pf() may produce a valid token with zero
value, which is confused with previous mention and may lead the loss of
this READY event.

This bug may cause task blocked forever in Guest:
 INFO: task stress:7532 blocked for more than 1254 seconds.
       Not tainted 5.10.0 #16
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:stress          state:D stack:    0 pid: 7532 ppid:  1409
 flags:0x00000080
 Call Trace:
  __schedule+0x1e7/0x650
  schedule+0x46/0xb0
  kvm_async_pf_task_wait_schedule+0xad/0xe0
  ? exit_to_user_mode_prepare+0x60/0x70
  __kvm_handle_async_pf+0x4f/0xb0
  ? asm_exc_page_fault+0x8/0x30
  exc_page_fault+0x6f/0x110
  ? asm_exc_page_fault+0x8/0x30
  asm_exc_page_fault+0x1e/0x30
 RIP: 0033:0x402d00
 RSP: 002b:00007ffd31912500 EFLAGS: 00010206
 RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
 RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
 RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
 R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
 R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000

Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
Message-Id: <20220222031239.1076682-1-zhangliang5@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3905,12 +3905,23 @@ static void shadow_page_table_clear_floo
 	walk_shadow_page_lockless_end(vcpu);
 }
 
+static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
+{
+	/* make sure the token value is not 0 */
+	u32 id = vcpu->arch.apf.id;
+
+	if (id << 12 == 0)
+		vcpu->arch.apf.id = 1;
+
+	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+}
+
 static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				    gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
 
-	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);


