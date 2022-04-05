Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150494F2DAE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245322AbiDEIzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240820AbiDEIce (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF438AE5C;
        Tue,  5 Apr 2022 01:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD7160FF5;
        Tue,  5 Apr 2022 08:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A942DC385A0;
        Tue,  5 Apr 2022 08:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147102;
        bh=MkH5R5DF93Xd6h3fKtnqZk3hN/YKatJAjvoLBElU3d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kr5gCoosneFtXH6CxB/bhNk2D4S1qoyWBBrF8Da7RTeJNS6wsyyffPPjMmC7VDpgf
         C09IBDCgZBFxO6zE5b0Yj0gKH1SYrX0LpB1//GpzpmI4BoVXkWsnvcsO+kSusDQ93D
         cCOia93E77q4+oFxw4OkH3tNeKRKxb90hELM04h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 1000/1126] KVM: Prevent module exit until all VMs are freed
Date:   Tue,  5 Apr 2022 09:29:07 +0200
Message-Id: <20220405070436.843321635@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

commit 5f6de5cbebee925a612856fce6f9182bb3eee0db upstream.

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
Fixes: 3d3aab1b973b ("KVM: set owner of cpu and vm file operations")
Cc: stable@vger.kernel.org
Suggested-by: Ben Gardon <bgardon@google.com>
[ Based on a patch from Ben implemented for Google's kernel. ]
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220303183328.1499189-2-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -117,6 +117,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static const struct file_operations stat_fops_per_vm;
 
+static struct file_operations kvm_chardev_ops;
+
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -1137,6 +1139,16 @@ static struct kvm *kvm_create_vm(unsigne
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
+	/*
+	 * When the fd passed to this ioctl() is opened it pins the module,
+	 * but try_module_get() also prevents getting a reference if the module
+	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
+	 */
+	if (!try_module_get(kvm_chardev_ops.owner)) {
+		r = -ENODEV;
+		goto out_err;
+	}
+
 	return kvm;
 
 out_err:
@@ -1226,6 +1238,7 @@ static void kvm_destroy_vm(struct kvm *k
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	module_put(kvm_chardev_ops.owner);
 }
 
 void kvm_get_kvm(struct kvm *kvm)


