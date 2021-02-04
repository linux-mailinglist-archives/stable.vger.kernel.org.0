Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08F30F553
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 15:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhBDOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 09:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236829AbhBDOkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 09:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B2764EE2;
        Thu,  4 Feb 2021 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612449550;
        bh=iLvEJLr/7hPAPOQD8ilNW6UIeGHzslNxwFZrNXPAO6I=;
        h=From:To:Cc:Subject:Date:From;
        b=pyf9Sg4Ur8iSkZwKQ1Cm1DvsyHUM4e1646IjfATSRa08fAP/bUPq/P1Mamu80JyOV
         O2ls5/1k+qrcGUeNkG3bYn97mp4YMa8rn5j+T3bBfpQYP21/JCNXv8Qfko9f7JOwkf
         MT9ysBlNW4AVAEEfh3yohzba73x5ttx5Us6K/ldGjuDkx2x3lfRpy4TQhhj4fzyrD2
         J8uZVMgc1XfyYsHcR0kpkbxSwtO66mI8PU4ZfD6acL27PXDrsAE9KHhuekaBcVIWdd
         EUPguUFUqA7gmxN76jHzOI9cqLuFkBtDN+XDkF4wpZsV7Sw4WCzZGNuQLjPIQJt4vU
         JeDIuoVP+EX8g==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6] x86/sgx: Maintain encl->refcount for each encl->mm_list entry
Date:   Thu,  4 Feb 2021 16:38:45 +0200
Message-Id: <20210204143845.39697-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This has been shown in tests:

[  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100

There are two functions that drain encl->mm_list:

- sgx_release() (i.e. VFS release) removes the remaining mm_list entries.
- sgx_mmu_notifier_release() removes mm_list entry for the registered
  process, if it still exists.

If encl->refcount is taken only for VFS, this can lead to
sgx_encl_release() being executed before sgx_mmu_notifier_release()
completes, which is exactly what happens in the above klog entry.

Each process also needs its own enclave reference.

In order to fix the race condition, increase encl->refcount when an
entry to encl->mm_list added for a process. Release this reference
when the mm_list entry is cleaned up, either in
sgx_mmu_notifier_release() or sgx_release().

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v6:
- Maintain refcount for each encl->mm_list entry.
v5:
- To make sure that the instance does not get deleted use kref_get()
  kref_put(). This also removes the need for additional
  synchronize_srcu().
v4:
- Rewrite the commit message.
- Just change the call order. *_expedited() is out of scope for this
  bug fix.
v3: Fine-tuned tags, and added missing change log for v2.
v2: Switch to synchronize_srcu_expedited().
 arch/x86/kernel/cpu/sgx/driver.c | 6 ++++++
 arch/x86/kernel/cpu/sgx/encl.c   | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..8d8fcc91c0d6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -72,6 +72,12 @@ static int sgx_release(struct inode *inode, struct file *file)
 		synchronize_srcu(&encl->srcu);
 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
+
+		/*
+		 * Release the mm_list reference, as sgx_mmu_notifier_release()
+		 * will only do this only, when it grabs encl_mm.
+		 */
+		kref_put(&encl->refcount, sgx_encl_release);
 	}
 
 	kref_put(&encl->refcount, sgx_encl_release);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..c1d9c86c0265 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -474,6 +474,7 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 	if (tmp == encl_mm) {
 		synchronize_srcu(&encl_mm->encl->srcu);
 		mmu_notifier_put(mn);
+		kref_put(&encl_mm->encl->refcount, sgx_encl_release);
 	}
 }
 
@@ -545,6 +546,13 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	}
 
 	spin_lock(&encl->mm_lock);
+
+	/*
+	 * Take a reference to guarantee that the enclave is not destroyed,
+	 * while sgx_mmu_notifier_release() is active.
+	 */
+	kref_get(&encl->refcount);
+
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
 	smp_wmb();
-- 
2.30.0

