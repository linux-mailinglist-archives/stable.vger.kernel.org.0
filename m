Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F9324D51
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhBYJ4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235494AbhBYJyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3FF964EF5;
        Thu, 25 Feb 2021 09:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246843;
        bh=iBNOvr58JQz924Lz8whUfoQyHyI302JA1X7nNfhZi04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKoLLHcZEJJC4KJl4T/DJzipKsIWmulD/UNqWhOiH5X+KVOjGmvGBwsvI2OIUMRLd
         rnBiUCPVUr64QvWSX9hINUMBmRi/oT3qWTM2SxAYi5G1lJksMGVdhivzP7gJ5LaCQ8
         hl845N330VO3oUW9mpwmJJ7rBRzg8UcmNx2a+XYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 12/12] KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()
Date:   Thu, 25 Feb 2021 10:53:46 +0100
Message-Id: <20210225092515.573855820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream.

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
  include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
                                  to ‘long unsigned int’ changes value from
                                  ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1903,7 +1903,7 @@ static int hva_to_pfn_remapped(struct vm
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;


