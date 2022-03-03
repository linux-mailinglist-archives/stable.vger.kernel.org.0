Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3FE4CC531
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiCCS1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 13:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiCCS1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 13:27:43 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B311A41CA
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 10:26:57 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id c12-20020a170902848c00b0015025f53e9cso3344469plo.7
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 10:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QOuZ5I4KFRMXkF6seWShnE2Ey6ez7qDQdhK2bClCPu0=;
        b=sLy9gR27I5Dr4L5BunA0ik6XS/gV9s1EnI+tW51on6ePT2+tp1bk8pAbAD+VkLZ1y0
         eRZOLFXFP2YBbEHDUZss6GcHZ3U5Emtpx+Qhp/8lHSQuCZ2v6DjHs1JJjiFPk999aGQU
         YaKhj9WzcKtZjWxrSkP63aux++Rzxkcq8vLYzoR+QTsWcu7iGG/XNdI+n23CNqOFyjb9
         xD8Oz4RgOeIYXfJGK2mwYDlKxYkz7sck7Um+TByxxZTL6JkiKHO+io3XSU5ns/EA8xCM
         3z6feyuRG0MN/hXKY7ltreP138DlJIFJcnoNaXWL7cAnBrIBE7sTG1mfZzWzsY3z6EUw
         qi1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QOuZ5I4KFRMXkF6seWShnE2Ey6ez7qDQdhK2bClCPu0=;
        b=rY3abToThOn/3XJOH0u0KA1mEHP5j/iZyekTF2Pf7FuWCy6oHV//4yKqTwawqOT4fg
         SDW7IxyRmkGeN6Uo3PRMdcP5t5IL4PGsEaj9q2BDgOYUfRYdHXTQ1X/H8Obnk3BfV8qh
         DhLQK5ynjJMcBpKnwXo0W3PiWYEcC6JESxdCof2bZ6wifQLAxnbNAYRv8UEhzkJq5/IL
         1+Z41WXM26iBSrjBejo2iJxn332iuwqCBbZCd0pjlzK8gGhpQSsbUlCvDahLXdUneSnH
         tcRKbMghJXVujPKUPlHSF11BCRFNjNIcln6odFzyBvlMTOoaUaoCTU2Jig+fp3FYos3S
         1r0A==
X-Gm-Message-State: AOAM530vjEISB9AjvtSaEyEpBc97tep0iYYHggEjM4ShnfIAweemCAxT
        SV3tPNE3/Jl0StLSNbl4yM+1rWfi6LMAFA==
X-Google-Smtp-Source: ABdhPJwv9F/tPxaYbn91Rb4OvtOb5KbJjAUyoZWfwNN8uizj7XVr2QgDsgz9NlIiaqWeFSpEyCol0tiA1Nww7w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21ca:b0:4c9:ff9:47e3 with SMTP
 id t10-20020a056a0021ca00b004c90ff947e3mr39636853pfj.10.1646332016540; Thu,
 03 Mar 2022 10:26:56 -0800 (PST)
Date:   Thu,  3 Mar 2022 18:26:51 +0000
In-Reply-To: <20220303182652.1496761-1-dmatlack@google.com>
Message-Id: <20220303182652.1496761-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220303182652.1496761-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 1/2] KVM: Prevent module exit until all VMs are freed
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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

