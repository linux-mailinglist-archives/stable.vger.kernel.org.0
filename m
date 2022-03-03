Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795AF4CC53F
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 19:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiCCSeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 13:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiCCSeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 13:34:19 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C3F10A7CA
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 10:33:33 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id c7-20020a17090a674700b001beef0afd32so2810717pjm.2
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 10:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QOuZ5I4KFRMXkF6seWShnE2Ey6ez7qDQdhK2bClCPu0=;
        b=lDeisK5cHZpbtWacdaMm9AZjhDaWYo10ffNAXW4GS7AdNAyg+Hh/n56SMXrjaBrBGB
         UvG1CT+h6m7qNJsCzbDviTmDG+Bovty9yvh5u/fbAP5+WCF779/YNu4zcmVpMKMUJVCo
         kZDdVS4rlis+mXQWEAkHZU9clHM/euY6G6PR/1YG6sVnB8FymzRzfSiKZC8/Qqd+irdT
         oJpjpOTjYdxq7uGIZj8weZuQIPQh4OBN3TN+afP/g1QU5r2EzbcIlPCFVLoI2xuUAkvE
         FFOGmwmAtvioZej3cVRpljxne8EKoY4dt3ef0lJEaIyrJiHLZIyNShsen+31akNCCDZl
         c8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QOuZ5I4KFRMXkF6seWShnE2Ey6ez7qDQdhK2bClCPu0=;
        b=69zkhfD6MZSPEDJEe1PRIhNsxZObG0pOYVwzwRu0yPDSd0PN2G45W4U4fCCTbjUk2g
         PZ21yvsPAidJTsSo95WDIHlLwC/vcryuqA4aw0EK5TXg/UkOr/Vm0vEBJy4UrfdXH9af
         dBmQF/3pyc1eJlBSLrQjkxkgnfWPrVc3pk/AItIB53YQ0CtUlV4YbIIZMxl0n2c+yc1+
         36nf/AzzU1KU5tAIjNE/PdsnmyxjuCHeqRqtkw+/Ks2vFrGRiWFtVuwFavT9LIvb4DcZ
         hHIgEL7aDee2bl6J/0aVWrlNDEl8yblCeWtA9dc9/MNknFWmIFrnFwE4kxTnlGwaq2wf
         v6Mg==
X-Gm-Message-State: AOAM530pnYXQ1uk6dEcvM8uLeVeS9eTgxcG+xddK6vIhliUo50mv3HB1
        WASl5N9V0NVBEu4gR+1V4BdgIQ+uoSpRuQ==
X-Google-Smtp-Source: ABdhPJyMOASFXqZeTTIqtYO0itzLRZL9uApqq7mmkmPJO9JZ5PbxYzX10D2vZj7kQXTCDJOFzri0PvVd+gYYTQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:b602:b0:14f:e42b:d547 with SMTP
 id b2-20020a170902b60200b0014fe42bd547mr37940828pls.91.1646332412852; Thu, 03
 Mar 2022 10:33:32 -0800 (PST)
Date:   Thu,  3 Mar 2022 18:33:27 +0000
In-Reply-To: <20220303183328.1499189-1-dmatlack@google.com>
Message-Id: <20220303183328.1499189-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220303183328.1499189-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are freed
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tie the lifetime the KVM module to the lifetime of each VM via
kvm.users_count. This way anything that grabs a reference to the VM via
kvm_get_kvm() cannot accidentally outlive the KVM module.

Prior to this commit, the lifetime of the KVM module was tied to the
lifetime of /dev/kvm file descriptors, VM file descriptors, and vCPU
file descriptors by their respective file_operations "owner" field.
This approach is insufficient because references grabbed via
kvm_get_kvm() do not prevent closing any of the aforementioned file
descriptors.

This fixes a long standing theoretical bug in KVM that at least affects
async page faults. kvm_setup_async_pf() grabs a reference via
kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
prevents the VM file descriptor from being closed and the KVM module
from being unloaded before this callback runs.

Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
Cc: stable@vger.kernel.org
Suggested-by: Ben Gardon <bgardon@google.com>
[ Based on a patch from Ben implemented for Google's kernel. ]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 35ae6d32dae5..b59f0a29dbd5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static const struct file_operations stat_fops_per_vm;
 
+static struct file_operations kvm_chardev_ops;
+
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -1131,6 +1133,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
+	if (!try_module_get(kvm_chardev_ops.owner)) {
+		r = -ENODEV;
+		goto out_err;
+	}
+
 	return kvm;
 
 out_err:
@@ -1220,6 +1227,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	module_put(kvm_chardev_ops.owner);
 }
 
 void kvm_get_kvm(struct kvm *kvm)

base-commit: b13a3befc815eae574d87e6249f973dfbb6ad6cd
prerequisite-patch-id: 38f66d60319bf0bc9bf49f91f0f9119e5441629b
prerequisite-patch-id: 51aa921d68ea649d436ea68e1b8f4aabc3805156
-- 
2.35.1.616.g0bdcbb4464-goog

