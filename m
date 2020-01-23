Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB801463DF
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAWIut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:50:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52577 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAWIut (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 03:50:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so1642932wmc.2;
        Thu, 23 Jan 2020 00:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ocf97TvHPaFYNxscXDRJHUBlARjdRQtQP9awJzp3ggM=;
        b=Bcdjx5nP2PyF1pD8yL4cLQIT8pTkxYXjeP4r69kS+xEJBu1ilgChEknhOfsLIpb/m1
         uYUwh2rCIbs01lUBhwr9Ou1/mCfI0nKcdIrUIB2LgaDUPXETNPOZkVl9LFWp7/DHO28m
         W4iygarapFuxapjwDs7UG+d7Fox3AnM9UMgjmLwHF4ALPAWBMFP1VyRW/p7TKSafRqOB
         GVTkXg7fZCad8ImlnWFtG9YHq7koXjsBLfQlJo7I01WC2kYc5if3fkIfkk8g6RommRYQ
         pu5M6GaJsOV0WH1QBgMfYxS35e3Tnt5AvAIcszGPVbJMHyG6oGdISsmqZ+k06tEgcIF4
         vogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ocf97TvHPaFYNxscXDRJHUBlARjdRQtQP9awJzp3ggM=;
        b=M1PIcahXXPQaXEXC9qQnvv73hdFoNPMNmhWBGb3MQ/DBhV3YaO154wXXYLddtz76ZL
         o2Ioqg3yGv13cPKO0BYzj82sgE2NOsLeQ13M832ocjpRPcf61WiM8KWRe1vBRnQBHJrN
         trHk7YMl25eik7kZCm6J9s9+g1xLeA+5NgxE4s6dv1BbYaVAJNk0rw6IabF2Y/LPYESZ
         wsft5gyqSkFQdk18v4zQrM1OfWD7SGwoZ6yHCPRJ1YO22CzUFxJhstmtp/68eUL3je6Z
         bC8i1jyHemDj6KIs5ooxqEShymqPIDVCt6znz2d4MVaq3YmG31nPT5LpZkSPIEA0ihZv
         OlOg==
X-Gm-Message-State: APjAAAWCdQkjnMJCV6w6gvYUzp6OqiWjK093XFq5ZZ+7FZ5RZn0kggIy
        X4mW8sSnzRXbGna0be+JWbTY3j2O
X-Google-Smtp-Source: APXvYqyCK86pGbQYwiwOZKZZWQekIpHNgNyyVHOM0H3y6SCCn8bVX3KEWezFnmRAmGxSKEL2HCBFYw==
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr2907767wml.156.1579769446157;
        Thu, 23 Jan 2020 00:50:46 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b16sm2198739wrj.23.2020.01.23.00.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jan 2020 00:50:45 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
Date:   Thu, 23 Jan 2020 09:50:42 +0100
Message-Id: <1579769442-13698-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 57e4dbddba72..b9052c7ba43d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -418,22 +418,24 @@ static inline bool is_access_track_spte(u64 spte)
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
@@ -444,8 +446,6 @@ static u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	spte &= ~shadow_mmio_mask;
-
 	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
 	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
 	return gen;
-- 
1.8.3.1

