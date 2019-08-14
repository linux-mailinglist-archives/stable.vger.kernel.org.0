Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2348B8D36C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfHNMrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 08:47:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39392 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHNMrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 08:47:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so20854818wra.6
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 05:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=0abMaL98A4yUgQniTDsZFrJ+rBCdo3jDZiprUFAzj5k=;
        b=eZ6/X3hS013bo2KMZWgpcatL6nNrYUQC/qq8g9aYhpqtkJgCeeOQAmvHGixELujfai
         2WU9EAz5K72yf+5NW8p3WK/fdFmFJwcW4J9/NArk3JNh66drAfc3zICEEPyZj8RjIWAz
         UF1c0nD2v9Ye8KbVFboyajpB9il+mkL4uusvwo0aj8BqoiVCvI3Bhbt1RgjU5ASvdH98
         IrqtGWJJGF+YzfapUGyKtgs3HkWrqf9giwZdMGxr4FacQZzWtPF1NUz9OpUt5g8Y5Q/0
         cHgTdvEtLVv9Dr55U0OXTeDlHBCKUEOdWC7T6tawz9XZAIfawKa5/XdfzJtk7PK6gxBt
         kgnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=0abMaL98A4yUgQniTDsZFrJ+rBCdo3jDZiprUFAzj5k=;
        b=T1AYC3dCNrP4AJJevIYJYQaM8jO0BuXJY76x9GmBt/PzZhdpxMFDSIcDABmnp6Z0/6
         GlEkRxdLK8pDLiHtiMgEs7WKdPSvcsU4Ajbh8comGBvV+OpiDwvuM5bIon+YC8MOq+Mn
         ZQ/WDroUd7H202zkppWAH/5RGsrWQ5zUF2Emiu+XZVY5QXiBJ6TVUCv4cfSccxjZghbC
         CaHN8ioku9GbJG+R7vwZMqDvU18fSXd3XSkicuN+pBY3efQFaDqdn1ytt4KUhSC3ZGoI
         hsaT6ZJrbXb6TQBGsFoJGGhwxCQ4DeLwK2HTsslxpPpPyMqFak2z9+QhCj1Q3L9+r7cv
         ZQLw==
X-Gm-Message-State: APjAAAXTurbD5Dz6IFtqZL02Gibc5eq9If6QCGEvBPCAkdv265pFGum6
        32TZy+WcTM7K/1lMh2g2nR8zhdzU
X-Google-Smtp-Source: APXvYqwsuym7u6JMWF4TrRDRxNjLsTnO6xb+cPftprTBDsY51hoJC/tPhjGPk9xnMKEOGKcD2eCetg==
X-Received: by 2002:a5d:6307:: with SMTP id i7mr40581654wru.144.1565786857931;
        Wed, 14 Aug 2019 05:47:37 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c12sm9170416wrx.46.2019.08.14.05.47.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:47:36 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM/nSVM: properly map nested VMCB
Date:   Wed, 14 Aug 2019 14:47:35 +0200
Message-Id: <1565786855-15387-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ upstream commit 8f38302c0be2d2daf3b40f7d2142ec77e35d209e ]

Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest
memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter is
GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other way
around.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 735b8c01895e..5beca1030c9a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3293,7 +3293,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(svm->nested.vmcb), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -3583,7 +3583,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb_gpa = svm->vmcb->save.rax;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
-- 
1.8.3.1

