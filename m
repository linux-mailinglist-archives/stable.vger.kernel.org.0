Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE83A3B36
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 07:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFKFDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 01:03:37 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:36490 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhFKFDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 01:03:37 -0400
Received: by mail-pg1-f175.google.com with SMTP id 27so1507848pgy.3;
        Thu, 10 Jun 2021 22:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7YpOakzhHdRE44ZlZax8n9BZSeUcpRWNnc5DgZyi2aQ=;
        b=J01O4ZHKpOQkfEHRWcjAK6KInyZN8PAxMLqqHDyZunQCvi/NSJtNCjIicFVOIuQlAb
         yylrt3EefWnNHdnNg+hQB5MnT/eSofSaA/GKFtttlvZA28ee8ONE1iF0sCyo1rAxhkFb
         bzAISUZN0D8uQGCEencnqvr70ZcdEtkjPlfeo2XPstQpNfwZE5CIPZOtUs5aiYwqJQiu
         R6p6hlk6Wkf6+hMtFRg6DkrcNmUEgowDtRlnCAS5Wr4/dYUkaI8b7XlwbvmQjh6STZDA
         0M4xa6u9F6yLEet6fYlZAiepzMZHuuUfOfh0DN3jEr8rxa+4dOusir3SUiojIVCA0V32
         ilsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7YpOakzhHdRE44ZlZax8n9BZSeUcpRWNnc5DgZyi2aQ=;
        b=SaldA/9NxlwouphArBZZ4w791Bz2Dh7OV88iOdzl7lXc45GmCYJvhZ9BHKqjFkIQ/m
         0tEKvt4EZv8PLeHSSqme48Al4OTCGuLD8afbtjrMr6BRWIbFr5d3mbpI7A705pW64Fpa
         rW1sOqmv8x6NZ9RWy67rElezBrTh39teVsDhlPdqgzcWsKiklS6yQ1pVWVNkMDyuL8rj
         PEA9EYXejMb0ARuPWUW/v8lboSQqRJVgYy66PJ+g9PEnQM57DYLh+NaS2nb+hKUBG9Qv
         YTd36PqK2JASXZiSlt8s0N5YvEeXAk4ckIDReB8i86KmRrio7xq2+dmFQbMUAFR4Ut6g
         4k4g==
X-Gm-Message-State: AOAM530SxC9MsKldM8NTZia7Iys8MvjF16lp5YyC/oMjYs0h8drD95+q
        /fkjKjYrcfwZHuE7Rpz35UZPAAMseIQ=
X-Google-Smtp-Source: ABdhPJwqMBSXKGr0vVVHXULaBAxNCD4YKTjfRAPJYckXUrqZuIqE6Y/4FhNpnplJ3weQZEZZabVjQA==
X-Received: by 2002:a63:62c2:: with SMTP id w185mr1856319pgb.76.1623387624747;
        Thu, 10 Jun 2021 22:00:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.40])
        by smtp.googlemail.com with ESMTPSA id w27sm4075825pfq.117.2021.06.10.22.00.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 22:00:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH] KVM: X86: Fix x86_emulator slab cache leak
Date:   Thu, 10 Jun 2021 21:59:33 -0700
Message-Id: <1623387573-5969-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context) 
tries to allocate per-vCPU emulation context dynamically, however, the
x86_emulator slab cache is still exiting after the kvm module is unload
as below after destroying the VM and unloading the kvm module.

grep x86_emulator /proc/slabinfo
x86_emulator          36     36   2672   12    8 : tunables    0    0    0 : slabdata      3      3      0

This patch fixes this slab cache leak by destroying the x86_emulator slab cache 
when the kvm module is unloaded.

Fixes: c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context)
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d3955a6a763..fe26f33e8782 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8258,6 +8258,7 @@ void kvm_arch_exit(void)
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
+	kmem_cache_destroy(x86_emulator_cache);
 	kmem_cache_destroy(x86_fpu_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
-- 
2.25.1

