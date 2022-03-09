Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7570C4D3C1B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiCIVdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiCIVdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:33:15 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EA511D7A7
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:32:16 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id b4-20020a170902e94400b0015309b5c481so1013990pll.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OuHKMBHK1hfsv9PTwgLrKkJAtQ7PY6TuBBA78I/fvJ4=;
        b=AIIwunmbHzVTF90VIuxF0B+cPMpBG7vFTP0OkJvOthEDzWNCqONIkLvtNxhmiLHBxu
         EjEd0vKZjhfo3xMhZrnrf3N27GYOWuqyKJAHKpzQo3vO9ZGvzvU3dyvrFvbvQoC8T0mX
         /vo3+PRWA2NW2uPyyinE5+Gyjw0JZ0T7ZILAQomQiqHWK+XFPzzdh5yaOoUCo98mGGRp
         eLo5gIKTejRzAwtYCi89OWk3MaLRJkHnOS1joG4QKxe+55pelAMy1Bcg1cB2PTedaDfs
         j5YSlO3C5IDBkoIf1t5C6s/dp664blVOML9S8pQI8LmSDx2mMb0kTDYjxx4Ilf2j0jLm
         whyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OuHKMBHK1hfsv9PTwgLrKkJAtQ7PY6TuBBA78I/fvJ4=;
        b=aGZOhXGNSfT4fV9PL101vKS09JsOabU0ZHOkitWFOfR/96wZXepovdvCLnqZ4Qt4kk
         xshyZ151OxtGKv3SwEHZIDm8szyf5IbFiTpSdqz4jvyaYXwsbGfWCx4DkeQH62RG2rRP
         St6So1Na6sPmxdDiRvTnq2r87Vpvhk4+FmLxNn1oFtr7z6sKIny7KSyCbI/HtmBpXVMY
         cXpXTyH8lSRtMbrbyBgOvhCyITtYA3C/iB/brOLB5lzwhPuapBq0WOTLBkdfjUKPza7m
         lZOl6AwopqlkRi0QePwIcrOp5HjKvkTyIeFaNCxtX37zAGhu+Hm2Xvf/eRmQ2ciCa/CL
         bCow==
X-Gm-Message-State: AOAM533QIy0jdLh63ylXG+pAR5yMmEvpdGEOLITqp474tL+ctXI06Zxy
        d59GfIgbl9+YokOG1gcqSX0sTcasz45YRg==
X-Google-Smtp-Source: ABdhPJxw1hDwld16WPMlCFx0ZIw0ORi+ox3/ggeKsSO3s8u+x8KpQLec5E5jW86ylGJ1R4b7fyyLWZB9eZ/c6A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a087:b0:1b9:157f:4cc1 with SMTP
 id r7-20020a17090aa08700b001b9157f4cc1mr1521697pjp.117.1646861536007; Wed, 09
 Mar 2022 13:32:16 -0800 (PST)
Date:   Wed,  9 Mar 2022 21:32:07 +0000
In-Reply-To: <20220309213208.872644-1-dmatlack@google.com>
Message-Id: <20220309213208.872644-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220309213208.872644-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v2 1/2] KVM: Prevent module exit until all VMs are freed
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, seanjc@google.com,
        bgardon@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
kvm_get_kvm() donot prevent closing any of the aforementioned file
descriptors.

This fixes a long standing theoretical bug in KVM that at least affects
async page faults. kvm_setup_async_pf() grabs a reference via
kvm_get_kvm(), and drops it in an asynchronous work callback. Nothing
prevents the VM file descriptor from being closed and the KVM module
from being unloaded before this callback runs.

PPC and s390 also look broken beyond the Fixes commits listed below, but
the below commits should be more than enough to guarantee inclusion in
all stable kernels.

Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")
[ This 2.6.29 commit was an incomplete attempt to fix this bug. ]
Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
[ This 2.6.38 commit introduced async_pf and is definitely broken. ]
Cc: stable@vger.kernel.org
Suggested-by: Ben Gardon <bgardon@google.com>
[ Based on a patch from Ben implemented for Google's kernel. ]
Reviewed-by: Sean Christopherson <seanjc@google.com>

Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9581a24c3d17..e17f9fd847e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static const struct file_operations stat_fops_per_vm;
 
+static struct file_operations kvm_chardev_ops;
+
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -1132,6 +1134,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
+	/* Use the "try" variant to play nice with e.g. "rmmod --wait". */
+	if (!try_module_get(kvm_chardev_ops.owner)) {
+		r = -ENODEV;
+		goto out_err;
+	}
+
 	return kvm;
 
 out_err:
@@ -1221,6 +1229,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	module_put(kvm_chardev_ops.owner);
 }
 
 void kvm_get_kvm(struct kvm *kvm)

base-commit: ce41d078aaa9cf15cbbb4a42878cc6160d76525e
-- 
2.35.1.616.g0bdcbb4464-goog

