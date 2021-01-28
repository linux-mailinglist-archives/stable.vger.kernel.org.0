Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1D307693
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 14:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhA1M7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 07:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231880AbhA1M7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 07:59:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B15764DD8;
        Thu, 28 Jan 2021 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611838709;
        bh=+X6/S8TIzROyCscNL2Zpna/HXn70q3+ajUjZ7HNRiAU=;
        h=From:To:Cc:Subject:Date:From;
        b=RGWcjlLIWrGovksSstY30JmqTRfZCBscviaxR4kslvyFkhO8bCAtHDB2WUjsYZzcv
         MutNhdGi36yfC/dc4S28cWOtdWPd37n2sW8o/oFY9mvvUBDHGwmql7zRm2vOf0hwdk
         Nkf2K9jItce47ytcpxq0QWGqcn9i9QsiPjv5Ha7+Qil6wiUnlER3rY+fUdLiGxizhg
         a2f/urXpywgTwFsHm++rY6YjbyNYOHXN3269HrLtqI6jYhtGcsKfPS7gXW5nft/iqO
         RRLZHsYkfZr9Gfev44tEmL2xdoL7Vwd9bVvPkHdwet9nmSJtoTE3GNELBQCyh+XBF6
         nuebD84od3Zyw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, Jarkko Sakkinen <jarkko@kernel.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] x86/sgx: Fix use-after-free in sgx_mmu_notifier_release()
Date:   Thu, 28 Jan 2021 14:58:23 +0200
Message-Id: <20210128125823.18660-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The most trivial example of a race condition can be demonstrated by this
sequence where mm_list contains just one entry:

CPU A                           CPU B
-> sgx_release()
                                -> sgx_mmu_notifier_release()
                                -> list_del_rcu()
                                <- list_del_rcu()
-> kref_put()
-> sgx_encl_release()
                                -> synchronize_srcu()
-> cleanup_srcu_struct()

A sequence similar to this has also been spotted in tests under high
stress:

[  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100

Albeit not spotted in the tests, it's also entirely possible that the
following scenario could happen:

CPU A                           CPU B
-> sgx_release()
                                -> sgx_mmu_notifier_release()
                                -> list_del_rcu()
-> kref_put()
-> sgx_encl_release()
-> cleanup_srcu_struct()
<- cleanup_srcu_struct()
                                -> synchronize_srcu()

This scenario would lead into use-after free in cleaup_srcu_struct().

Fix this by taking a reference to the enclave in
sgx_mmu_notifier_release().

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Suggested-by: Sean Christopherson <seanjc@google.com>
Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
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
 arch/x86/kernel/cpu/sgx/encl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..5ecbcf94ec2a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -465,6 +465,7 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 	spin_lock(&encl_mm->encl->mm_lock);
 	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
 		if (tmp == encl_mm) {
+			kref_get(&encl_mm->encl->refcount);
 			list_del_rcu(&encl_mm->list);
 			break;
 		}
@@ -474,6 +475,7 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 	if (tmp == encl_mm) {
 		synchronize_srcu(&encl_mm->encl->srcu);
 		mmu_notifier_put(mn);
+		kref_put(&encl_mm->encl->refcount, sgx_encl_release);
 	}
 }
 
-- 
2.30.0

