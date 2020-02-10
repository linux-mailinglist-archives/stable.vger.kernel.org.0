Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3414A157589
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgBJMlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbgBJMll (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6A820838;
        Mon, 10 Feb 2020 12:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338500;
        bh=mvnVJV3p3/i8WhR2AKqQjf6C6rLK0nHmBp7089fRAX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFp7nOFtPF+8ttiuEbxE9M4YPX9NnABkfHV498Vpo6/SNdL4bWcS99/xI+pT+tkVJ
         Krjfsu1nKt4wtG5hC0C99X1+7ER6206lkHghgIwqLXAmcOZPilH6Q4QHgf7Ljerft/
         yeVpJ4LYSJY8UJQCBtw1t3TRVfQaszJDC+BHgTQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 254/367] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
Date:   Mon, 10 Feb 2020 04:32:47 -0800
Message-Id: <20200210122447.865741331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 56871d444bc4d7ea66708775e62e2e0926384dbc upstream.

The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
generation number.  A high enough generation number would overwrite the
SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted.

Likewise, setting bits 52 and 53 would also cause an incorrect generation
number to be read from the PTE, though this was partially mitigated by the
(useless if it weren't for the bug) removal of SPTE_SPECIAL_MASK from
the spte in get_mmio_spte_generation.  Drop that removal, and replace
it with a compile-time assertion.

Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
Reported-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -418,22 +418,24 @@ static inline bool is_access_track_spte(
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 
-#define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		61
+#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_END		62
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
 
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
+	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
@@ -444,8 +446,6 @@ static u64 get_mmio_spte_generation(u64
 {
 	u64 gen;
 
-	spte &= ~shadow_mmio_mask;
-
 	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
 	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
 	return gen;


