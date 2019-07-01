Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F1E29F6F
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391777AbfEXTzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:55:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35486 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391181AbfEXTzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 15:55:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so11124749wrv.2;
        Fri, 24 May 2019 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Q6sdBmuXqvJHLwiBvnlYVZYBhESuLA22iHIDEDPwi9U=;
        b=Tgg4Up/lk2Ap0JSoDQFxLeiKtiT53pOPE/nmBiQX3f8xrTbWkafhxM3i4F+CCzNmwm
         g1J37jCw7QdF1TmskMX+4BtllLLXNWq4t0woF2cEM7h8nAVHK/arCChCsWRhoPVGssV5
         JZynX5mEoCd9rDC6wHRXwYXRYHIbyUsxBxIX1GsZGmPTh6cRLOqWVztlrn4kOPHa0Xm4
         yxV9Eo43RShYr41FEcpYVkSuykoLwnJyptraK9QkIucnM4JuyUYgwh41T1DvyD5KhUBr
         Hxa/xVxETqrnLw+1VOdRovMkWfjNVEz8aSf950EkAQ+TCHJXSbSeyhvZpSVtqis89XYa
         LjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Q6sdBmuXqvJHLwiBvnlYVZYBhESuLA22iHIDEDPwi9U=;
        b=GW0RDvIITkDcxFIAJ4xjG7khvdEK6+NpcObJikJA3+zv+UsBRaBuXzkEoVYRjD5uHe
         BwSXogPt1CN9/j2LCHfyYY8d7yPENzgvtXyKMNQImzeuQDgWAXn5H1ie36G7HdNJpnf+
         Zra1l7yxE60sZaZeV094eHU8kMe1v13l6fvdEdue86O/PGJCV9isbZ8S4DHuJZHQeM9J
         O5MSfnrzXgyqWWqmHMzYADLHgAmnYlRAAyGKfkZwz/7YzkOJTIle00d/p6pv2RnmgwlK
         766o0e3+JqyLEMk9GybikfXnL6neK7gqGHsNVAEsLHKxGD2PTyVM7UX7CAt6ffndSeif
         FZdQ==
X-Gm-Message-State: APjAAAXCdt0A1k2XIMNA8pPdYrMO0JZqP61kZQcdky+TEdnWiwcmJR7m
        KIpIaRzf2Hsg5m4kl/KtGAONM7Le
X-Google-Smtp-Source: APXvYqxtf5NHJQ+rL1PQ6x5O8UXmFLmNYXnMMANzmvqW1Ol2ue8gvm8qW++sHpLMU1ePKRMMo85tmw==
X-Received: by 2002:adf:e3c4:: with SMTP id k4mr11363193wrm.186.1558727721282;
        Fri, 24 May 2019 12:55:21 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j206sm5994324wma.47.2019.05.24.12.55.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:55:20 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pavel@denx.de,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: x86: fix return value for reserved EFER
Date:   Fri, 24 May 2019 21:55:18 +0200
Message-Id: <1558727718-49220-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for
host-initiated writes", 2019-04-02) introduced a "return false" in a
function returning int, and anyway set_efer has a "nonzero on error"
conventon so it should be returning 1.

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7e57de50a3c..acb179f78fdc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1298,7 +1298,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 efer = msr_info->data;
 
 	if (efer & efer_reserved_bits)
-		return false;
+		return 1;
 
 	if (!msr_info->host_initiated) {
 		if (!__kvm_valid_efer(vcpu, efer))
-- 
1.8.3.1

