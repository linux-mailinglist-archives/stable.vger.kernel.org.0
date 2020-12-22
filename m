Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C102DD324
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 15:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgLQOlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 09:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgLQOlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 09:41:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513E1C061794;
        Thu, 17 Dec 2020 06:40:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w6so19185002pfu.1;
        Thu, 17 Dec 2020 06:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=enLPOtX+RwuUEW41weEYdgVO7wJosn5W764QBKADpC0=;
        b=MIwIlFomCfpcfTP7hoYKE80dMrXthuwfQfIE41Eh9iO9XuLzVC0MHAVozM9FFECa4u
         4auSn9F6mNrNxMIow8KyfmaaUqNnMwtiJ920yky/TQomMa2FqHvTDSCDrBMBKlMXG5gk
         JsrjEq79Q0zxgvWEEH3w99F88LWoPr8/8A3UCCSaBvFhfE3NIBoU5sm7aSRlG6JbuRpr
         Do2E8DA14oXXi9EOclDV2pGwUg6m+RPSTg7zzZYx+Bti4MpgiqDH80cibISlp4Dybgs8
         mfWQZmMbFrv3yCD7xTNjUxBWuiQ/2p4egc0gxipwIPMiszEbN3gxHjL256OVu04uNZyA
         qSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=enLPOtX+RwuUEW41weEYdgVO7wJosn5W764QBKADpC0=;
        b=J7ZZYeLzzxGogyT83B1+y7a5S1ZSuKwXFEYDa1n7DS1caOBWPrXJM4SNFa9Tp8wZ7z
         TSm1dg8qIxJqxi383QYeUfK6y9c6oTpfHhWr4n+dkw+NmK9J6CSfcOJRGI710vIUg7vB
         ecgJaex1ONLI7zAXJ1GVKpO/9Ku9atmfgCO0D5qwoeyNk3RNeTxSgMDKkL18enbpHQ0H
         AVFmKg9eqAOPjk7VRYW3hi6lOrxlDiIBkXXVgTCzbea6RopADYRwV6bIFYANBEF6CCMv
         GBIdYoWxaN6Fx65+vqxhnafq6Ugy4FZ9RrNAkWIRf4let5jsX84Z291dOt2iJqTnHDST
         eVjw==
X-Gm-Message-State: AOAM532C7YFqSMLSpwcpxZ+iRVB8EziYRW1Q9Gj4Uwk5J12K7sBhowV0
        FUeHYIqwwVXjLLfYMdURYekDYo96leX8PA==
X-Google-Smtp-Source: ABdhPJyHFpraaFLk+3QhMHDpQ4btopHivgWaat0v6SLM6H6sHi26qZvrt5X38vYkRmFQBca9pqKJcw==
X-Received: by 2002:a65:534d:: with SMTP id w13mr37761820pgr.107.1608216044599;
        Thu, 17 Dec 2020 06:40:44 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id p16sm5294396pju.47.2020.12.17.06.40.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Dec 2020 06:40:44 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH V3] kvm: check tlbs_dirty directly
Date:   Thu, 17 Dec 2020 23:41:18 +0800
Message-Id: <20201217154118.16497-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <X9kEAh7z1rmlmyhZ@google.com>
References: <X9kEAh7z1rmlmyhZ@google.com>
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

Changed from v2:
	don't change the type of need_tlb_flush

 virt/kvm/kvm_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..3083fb53861d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -482,9 +482,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

