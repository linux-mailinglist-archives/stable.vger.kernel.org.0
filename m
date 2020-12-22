Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D8D2DAE51
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 14:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgLONxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 08:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgLONxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 08:53:06 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1896C06179C;
        Tue, 15 Dec 2020 05:52:25 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id iq13so1246210pjb.3;
        Tue, 15 Dec 2020 05:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kA8Dwcq079V/BJPEpdlGaQgTJviaipiaUEGQZv3ilX8=;
        b=daoTMTDrO6Fl4hCPzcXNElDZryGJXL62M45+T1ejKcPGICQMEA6H3bAEC61eqISyXJ
         jGEIYG0WB4KaOhEHWsZQlA5JvR9eRijwjcZNF+1GngNN6B1aFJg+jhz67K9qaaMilDz6
         AnXtO3LfNOuyTWA2DiWycSYA6wk5eaMQbe8QfUTmsdrUFkPzyPQ3twFdaCRiFNMEL5TX
         G3eeURYq79byly8utQxZ4vwHvXHakwBUpp/RxRbkOCszAJdPv4BanQGB1NmxYfrmaffc
         ucsAguqzRSAKTl+iZPTELMWIua7BSwizb0SrOvAeDaSDUfAGi5bpGBVkPJj+nH/fUPcv
         FdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kA8Dwcq079V/BJPEpdlGaQgTJviaipiaUEGQZv3ilX8=;
        b=aNsJ6qJdDc2rbbvW1OYruw2ucBW+XLzBQiF2bwUwuc4lf1toyr+n8BnGnH6nBPcSDP
         SuL8eBnYut3TAuZuvJYtRpnJGMuIn30mGv3pIq/G9mpZgBRz9tHHoD8GWOOdVHNr1HvH
         PbhQtbpJkKMgMR+bdDVy8EsfrVNgSsAeml/6bPB4TdB8cckrdaHRvC69YshBdx4Fa3Hs
         B3T2dGNnhmiMIzSrO6bleMjY2HgLJBjf8zEv0Cl17Z53MBxlS/ZsEhgVwrKmZA1Dj+os
         dfgy/iqXIw6AF/BG3MMD6J1Xib3egJS7ce/rfOFxnjx45Ur3BUhxHeYV2WseReimVHz6
         o3gg==
X-Gm-Message-State: AOAM532vUp3+ZWiBOJ977KRvXTqFn5ledFVG23vMmXcAsWe04Migj2D5
        0UcIGBRcE2ky4cX7mN2mORKPdMjw9pD4lw==
X-Google-Smtp-Source: ABdhPJw0R9lG114WLwNTwfAx6zsDTaCbuaJEOOvbsRp076YUCHHb3kSKWTKR0C/HtM2Eid2CmO60mQ==
X-Received: by 2002:a17:90a:f404:: with SMTP id ch4mr29284264pjb.78.1608040345186;
        Tue, 15 Dec 2020 05:52:25 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id b1sm22000363pjh.54.2020.12.15.05.52.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Dec 2020 05:52:24 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH V2] kvm: check tlbs_dirty directly
Date:   Tue, 15 Dec 2020 22:52:59 +0800
Message-Id: <20201215145259.18684-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
References: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
        need_tlb_flush |= kvm->tlbs_dirty;
with need_tlb_flush's type being int and tlbs_dirty's type being long.

It means that tlbs_dirty is always used as int and the higher 32 bits
is useless.  We need to check tlbs_dirty in a correct way and this
change checks it directly without propagating it to need_tlb_flush.

And need_tlb_flush is changed to boolean because it is used as a
boolean and its name starts with "need".

Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
cause problems in practice.  It would require encountering tlbs_dirty
on a 4 billion count boundary, and KVM would need to be using shadow
paging or be running a nested guest.

Cc: stable@vger.kernel.org
Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1:
	Update the patch and the changelog as Sean Christopherson suggested.

 virt/kvm/kvm_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..1c17f3d073cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -470,7 +470,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int need_tlb_flush = 0, idx;
+	int idx;
+	bool need_tlb_flush;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
@@ -480,11 +481,10 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
-	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
-					     range->flags);
-	need_tlb_flush |= kvm->tlbs_dirty;
+	need_tlb_flush = !!kvm_unmap_hva_range(kvm, range->start, range->end,
+					       range->flags);
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

