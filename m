Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC8D593BDB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbiHOUNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346016AbiHOUJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D8B631E;
        Mon, 15 Aug 2022 11:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5303FB8105C;
        Mon, 15 Aug 2022 18:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DB7C433C1;
        Mon, 15 Aug 2022 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589782;
        bh=qQyraYE4LbhTbwMvV6lt7Z7x61Pv/yXQ96/5OMaQNNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rO/jRrMmgFF6FQtbzDSnuLQHlXKfr2dNMaYdKEFoUABta23KXHXjRynW/bz53qw6t
         mYwvK+pUIPKr8Dv73hvOsJRH3eRar0Bm16izF0Aldk46LNUae0NboQscjAc7L3oy0X
         cOjJkCJs9gxTyqE6WG3kM+vI6moLubGow3Sca6Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0029/1095] KVM: Fully serialize gfn=>pfn cache refresh via mutex
Date:   Mon, 15 Aug 2022 19:50:28 +0200
Message-Id: <20220815180430.572594455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <seanjc@google.com>

commit 93984f19e7bce4c18084a6ef3dacafb155b806ed upstream.

Protect gfn=>pfn cache refresh with a mutex to fully serialize refreshes.
The refresh logic doesn't protect against

- concurrent unmaps, or refreshes with different GPAs (which may or may not
  happen in practice, for example if a cache is only used under vcpu->mutex;
  but it's allowed in the code)

- a false negative on the memslot generation.  If the first refresh sees
  a stale memslot generation, it will refresh the hva and generation before
  moving on to the hva=>pfn translation.  If it then drops gpc->lock, a
  different user of the cache can come along, acquire gpc->lock, see that
  the memslot generation is fresh, and skip the hva=>pfn update due to the
  userspace address also matching (because it too was updated).

The refresh path can already sleep during hva=>pfn resolution, so wrap
the refresh with a mutex to ensure that any given refresh runs to
completion before other callers can start their refresh.

Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429210025.3293691-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_types.h |    2 ++
 virt/kvm/pfncache.c       |   12 ++++++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -19,6 +19,7 @@ struct kvm_memslots;
 enum kvm_mr_change;
 
 #include <linux/bits.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/spinlock_types.h>
 
@@ -69,6 +70,7 @@ struct gfn_to_pfn_cache {
 	struct kvm_vcpu *vcpu;
 	struct list_head list;
 	rwlock_t lock;
+	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
 	enum pfn_cache_usage usage;
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -157,6 +157,13 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	if (page_offset + len > PAGE_SIZE)
 		return -EINVAL;
 
+	/*
+	 * If another task is refreshing the cache, wait for it to complete.
+	 * There is no guarantee that concurrent refreshes will see the same
+	 * gpa, memslots generation, etc..., so they must be fully serialized.
+	 */
+	mutex_lock(&gpc->refresh_lock);
+
 	write_lock_irq(&gpc->lock);
 
 	old_pfn = gpc->pfn;
@@ -250,6 +257,8 @@ int kvm_gfn_to_pfn_cache_refresh(struct
  out:
 	write_unlock_irq(&gpc->lock);
 
+	mutex_unlock(&gpc->refresh_lock);
+
 	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 
 	return ret;
@@ -261,6 +270,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
 	void *old_khva;
 	kvm_pfn_t old_pfn;
 
+	mutex_lock(&gpc->refresh_lock);
 	write_lock_irq(&gpc->lock);
 
 	gpc->valid = false;
@@ -276,6 +286,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 
 	write_unlock_irq(&gpc->lock);
+	mutex_unlock(&gpc->refresh_lock);
 
 	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 }
@@ -290,6 +301,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm
 
 	if (!gpc->active) {
 		rwlock_init(&gpc->lock);
+		mutex_init(&gpc->refresh_lock);
 
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;


