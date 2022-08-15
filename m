Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7115593DD3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344162AbiHOUOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346283AbiHOULI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0636C19285;
        Mon, 15 Aug 2022 11:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C442E6126D;
        Mon, 15 Aug 2022 18:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A4FC433D7;
        Mon, 15 Aug 2022 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589851;
        bh=KKc5u0c4svxwVAcIxxjFmvahLmLCXSorZlxcM4OLRUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZEm9ZVsImEKThcmT4hmWlp6hPSAHG2+5KrBP5qpVtJsAXDbPcOdXUYG7ul4NPZkL
         K2FxoZWgBZs926qpGEt7/CUOhdy2svaZUaMjqluWltjFa9wXfEdyD7OcTUuNGTXzHl
         oEnnYAviDNDsDjNCL8UkjNTvi/odPTt9EqqUx9/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0027/1095] KVM: Drop unused @gpa param from gfn=>pfn caches __release_gpc() helper
Date:   Mon, 15 Aug 2022 19:50:26 +0200
Message-Id: <20220815180430.481743335@linuxfoundation.org>
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

commit 345b0fd6fe5f66dfe841bad0b39dd11a5672df68 upstream.

Drop the @pga param from __release_gpc() and rename the helper to make it
more obvious that the cache itself is not being released.  The helper
will be reused by a future commit to release a pfn+khva combination that
is _never_ associated with the cache, at which point the current name
would go from slightly misleading to blatantly wrong.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429210025.3293691-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -95,7 +95,7 @@ bool kvm_gfn_to_pfn_cache_check(struct k
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
 
-static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_t gpa)
+static void gpc_release_pfn_and_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
 {
 	/* Unmap the old page if it was mapped before, and release it */
 	if (!is_error_noslot_pfn(pfn)) {
@@ -146,7 +146,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	unsigned long page_offset = gpa & ~PAGE_MASK;
 	kvm_pfn_t old_pfn, new_pfn;
 	unsigned long old_uhva;
-	gpa_t old_gpa;
 	void *old_khva;
 	bool old_valid;
 	int ret = 0;
@@ -160,7 +159,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 
 	write_lock_irq(&gpc->lock);
 
-	old_gpa = gpc->gpa;
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
@@ -244,7 +242,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct
  out:
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
+	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 
 	return ret;
 }
@@ -254,14 +252,12 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
-	gpa_t old_gpa;
 
 	write_lock_irq(&gpc->lock);
 
 	gpc->valid = false;
 
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
-	old_gpa = gpc->gpa;
 	old_pfn = gpc->pfn;
 
 	/*
@@ -273,7 +269,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
 
 	write_unlock_irq(&gpc->lock);
 
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
+	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 


