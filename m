Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE72B56FD32
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiGKJwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiGKJup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCAB29830;
        Mon, 11 Jul 2022 02:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE38B80E7A;
        Mon, 11 Jul 2022 09:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1DAC34115;
        Mon, 11 Jul 2022 09:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531499;
        bh=jLg70Q9nZHijQ04V8fPVGvO1b75QYGWIzu9gmbZ9Xr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGg2gj4XzgitG/GO3LyXj39N1tFw364Ok67w5cnx+p4enDl45qvTIafk41NITHF8f
         3ody7LDM1/vXk3XYW86x61aIRRp6ZoqhMvv3lSwSvLaivMOGIV9Wdb06a/MgeauAS1
         6tpWhfXs+XcD/b90+UUsvul32ConanwhcRcycNDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/230] KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref
Date:   Mon, 11 Jul 2022 11:06:22 +0200
Message-Id: <20220711090607.639773751@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5c697c367a66307a5d943c3449421aff2aa3ca4a ]

Initialize debugfs_entry to its semi-magical -ENOENT value when the VM
is created.  KVM's teardown when VM creation fails is kludgy and calls
kvm_uevent_notify_change() and kvm_destroy_vm_debugfs() even if KVM never
attempted kvm_create_vm_debugfs().  Because debugfs_entry is zero
initialized, the IS_ERR() checks pass and KVM derefs a NULL pointer.

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 1068b1067 P4D 1068b1067 PUD 1068b0067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 871 Comm: repro Not tainted 5.18.0-rc1+ #825
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__dentry_path+0x7b/0x130
  Call Trace:
   <TASK>
   dentry_path_raw+0x42/0x70
   kvm_uevent_notify_change.part.0+0x10c/0x200 [kvm]
   kvm_put_kvm+0x63/0x2b0 [kvm]
   kvm_dev_ioctl+0x43a/0x920 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x31/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  Modules linked in: kvm_intel kvm irqbypass

Fixes: a44a4cc1c969 ("KVM: Don't create VM debugfs files outside of the VM directory")
Cc: stable@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@google.com>
Reported-by: syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Message-Id: <20220415004622.2207751-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9134ae252d7c..9eac68ae291e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -934,12 +934,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created.
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	if (!debugfs_initialized())
 		return 0;
 
@@ -1055,6 +1049,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created (by kvm_create_vm_debugfs()).
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
-- 
2.35.1



