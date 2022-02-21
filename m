Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EDB4BDCA4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351702AbiBUJuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352395AbiBUJrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E10424B4;
        Mon, 21 Feb 2022 01:19:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B61D60B1E;
        Mon, 21 Feb 2022 09:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800E7C340E9;
        Mon, 21 Feb 2022 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435179;
        bh=gmkHUnpzJ0MwBGI9rRtdt+R+uHLOQK5Do2JLs3S9+UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QicSAj77maMRT5yCrQ3es0gAIzliQG9I7t8cN/ArYQPvyRe+Kr9Ey9EapC7dlqBjM
         j1nqSo0lg9gokEXPPbEyqnT6Zw6MQWRAODhBUu3NcSxruRu4gz3gbSBGRSSDumrseT
         RMwvfYSjcjlZUXc9BBFEiAmuC54/s0Z8J/7VdAmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 071/227] KVM: x86/xen: Fix runstate updates to be atomic when preempting vCPU
Date:   Mon, 21 Feb 2022 09:48:10 +0100
Message-Id: <20220221084937.237665558@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit fcb732d8f8cf6084f8480015ad41d25fb023a4dd upstream.

There are circumstances whem kvm_xen_update_runstate_guest() should not
sleep because it ends up being called from __schedule() when the vCPU
is preempted:

[  222.830825]  kvm_xen_update_runstate_guest+0x24/0x100
[  222.830878]  kvm_arch_vcpu_put+0x14c/0x200
[  222.830920]  kvm_sched_out+0x30/0x40
[  222.830960]  __schedule+0x55c/0x9f0

To handle this, make it use the same trick as __kvm_xen_has_interrupt(),
of using the hva from the gfn_to_hva_cache directly. Then it can use
pagefault_disable() around the accesses and just bail out if the page
is absent (which is unlikely).

I almost switched to using a gfn_to_pfn_cache here and bailing out if
kvm_map_gfn() fails, like kvm_steal_time_set_preempted() does — but on
closer inspection it looks like kvm_map_gfn() will *always* fail in
atomic context for a page in IOMEM, which means it will silently fail
to make the update every single time for such guests, AFAICT. So I
didn't do it that way after all. And will probably fix that one too.

Cc: stable@vger.kernel.org
Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <b17a93e5ff4561e57b1238e3e7ccd0b613eb827e.camel@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   97 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 30 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -93,32 +93,57 @@ static void kvm_xen_update_runstate(stru
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	struct gfn_to_hva_cache *ghc = &vx->runstate_cache;
+	struct kvm_memslots *slots = kvm_memslots(v->kvm);
+	bool atomic = (state == RUNSTATE_runnable);
 	uint64_t state_entry_time;
-	unsigned int offset;
+	int __user *user_state;
+	uint64_t __user *user_times;
 
 	kvm_xen_update_runstate(v, state);
 
 	if (!vx->runstate_set)
 		return;
 
-	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	if (unlikely(slots->generation != ghc->generation || kvm_is_error_hva(ghc->hva)) &&
+	    kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len))
+		return;
+
+	/* We made sure it fits in a single page */
+	BUG_ON(!ghc->memslot);
+
+	if (atomic)
+		pagefault_disable();
 
-	offset = offsetof(struct compat_vcpu_runstate_info, state_entry_time);
-#ifdef CONFIG_X86_64
 	/*
-	 * The only difference is alignment of uint64_t in 32-bit.
-	 * So the first field 'state' is accessed directly using
-	 * offsetof() (where its offset happens to be zero), while the
-	 * remaining fields which are all uint64_t, start at 'offset'
-	 * which we tweak here by adding 4.
+	 * The only difference between 32-bit and 64-bit versions of the
+	 * runstate struct us the alignment of uint64_t in 32-bit, which
+	 * means that the 64-bit version has an additional 4 bytes of
+	 * padding after the first field 'state'.
+	 *
+	 * So we use 'int __user *user_state' to point to the state field,
+	 * and 'uint64_t __user *user_times' for runstate_entry_time. So
+	 * the actual array of time[] in each state starts at user_times[1].
 	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
+	user_state = (int __user *)ghc->hva;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+
+	user_times = (uint64_t __user *)(ghc->hva +
+					 offsetof(struct compat_vcpu_runstate_info,
+						  state_entry_time));
+#ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
 
 	if (v->kvm->arch.xen.long_mode)
-		offset = offsetof(struct vcpu_runstate_info, state_entry_time);
+		user_times = (uint64_t __user *)(ghc->hva +
+						 offsetof(struct vcpu_runstate_info,
+							  state_entry_time));
 #endif
 	/*
 	 * First write the updated state_entry_time at the appropriate
@@ -132,10 +157,8 @@ void kvm_xen_update_runstate_guest(struc
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	if (__put_user(state_entry_time, user_times))
+		goto out;
 	smp_wmb();
 
 	/*
@@ -149,11 +172,8 @@ void kvm_xen_update_runstate_guest(struc
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->current_runstate,
-					  offsetof(struct vcpu_runstate_info, state),
-					  sizeof(vx->current_runstate)))
-		return;
+	if (__put_user(vx->current_runstate, user_state))
+		goto out;
 
 	/*
 	 * Write the actual runstate times immediately after the
@@ -168,24 +188,23 @@ void kvm_xen_update_runstate_guest(struc
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
 		     sizeof(vx->runstate_times));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->runstate_times[0],
-					  offset + sizeof(u64),
-					  sizeof(vx->runstate_times)))
-		return;
-
+	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times)))
+		goto out;
 	smp_wmb();
 
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-
 	state_entry_time &= ~XEN_RUNSTATE_UPDATE;
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	__put_user(state_entry_time, user_times);
+	smp_wmb();
+
+ out:
+	mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+
+	if (atomic)
+		pagefault_enable();
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
@@ -337,6 +356,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
@@ -354,6 +379,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct pvclock_vcpu_time_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      data->u.gpa,
@@ -375,6 +406,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_runstate_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
 					      data->u.gpa,


