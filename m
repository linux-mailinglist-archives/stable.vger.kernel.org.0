Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162532F702D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 02:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbhAOBrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 20:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731536AbhAOBrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 20:47:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC6A23A5A;
        Fri, 15 Jan 2021 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610675214;
        bh=Ctj2J6AS+IFDkD8O+jb+vtqlCpCNkWpL77EBbBpr6xI=;
        h=From:To:Cc:Subject:Date:From;
        b=QSDvAVdYUCH7rElsEBBKn6XbYNyxQB37yZJQcGV3/pxokdEttKxJ0d56et08X2zjM
         +2KtLVDX6PK0RiEbjzzCrajFEPH5RoG/zTUPp5wbqfwNxtqI1slkkWgQjbjwpVo/7k
         mjz5ogmiX1xnjrKPy6BoSZMoa6K43vcoF/w7xNZLROvoLKd9SSy4EmlJTkW+yXfgB1
         P/kO/TlWxYvxQt7+yy6eUD9nDTvv805UxjQ9CLdewV4bqIAxDJG8Cn5RutJ7HsZ8iA
         dJgn94ugaX6W1Gx7qKqNf7ELdtFIx93Y7iuQfdkR5X5I7URZIxfMIFEiK1b4ngPdEy
         WpHLxoSp552iQ==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        seanjc@google.com, Jarkko Sakkinen <jarkko@kernel.org>,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in sgx_release()
Date:   Fri, 15 Jan 2021 03:46:38 +0200
Message-Id: <20210115014638.15037-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

The most trivial example of a race condition can be demonstrated with this
example where mm_list contains just one entry:

CPU A                   CPU B
sgx_release()
                        sgx_mmu_notifier_release()
                        list_del_rcu()
sgx_encl_release()
                        synchronize_srcu()
cleanup_srcu_struct()

To fix this, call synchronize_srcu() before checking whether mm_list is
empty in sgx_release().

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v4:
- Rewrite the commit message.
- Just change the call order. *_expedited() is out of scope for this
  bug fix.
v3: Fine-tuned tags, and added missing change log for v2.
v2: Switch to synchronize_srcu_expedited().
 arch/x86/kernel/cpu/sgx/driver.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..53056345f5f8 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -65,11 +65,16 @@ static int sgx_release(struct inode *inode, struct file *file)
 
 		spin_unlock(&encl->mm_lock);
 
+		/*
+		 * The call is need even if the list empty, because sgx_encl_mmu_notifier_release()
+		 * could have initiated a new grace period.
+		 */
+		synchronize_srcu(&encl->srcu);
+
 		/* The enclave is no longer mapped by any mm. */
 		if (!encl_mm)
 			break;
 
-		synchronize_srcu(&encl->srcu);
 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
 	}
-- 
2.29.2

