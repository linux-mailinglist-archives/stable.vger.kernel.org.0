Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA424492E3B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245130AbiARTO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:14:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:18954 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236512AbiARTO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 14:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642533266; x=1674069266;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1bzjaE9PWeemsOPh5ZxLa54mzNFS673VSHgejMKQ0n4=;
  b=UZ4RwkKgS9uJxfnXqi1qMo+4sc5Hz8NS4QUaKoO2+V6m5EhcIGAG9AgI
   Gq/MBtKjKblKyqGReuRhDlHMK+6+ISGDRFzHS/Bk0NhxoFUgIv4/sss15
   yc/4dSIBOFpECMhz132vVzctqnk1pRf9KrMJXl5FFo2CfjIY1NoXmjgbL
   uzMxzVnq7N24NBFITAhgl8fP7zZhIsDveXK/Qd9wnj9a75oeym+lx0nAQ
   n/QF3BMKCPI+Vo3hgiK0mNrNAgir7mxjkWxPhcSJJkFwaf32E0ogS3dmn
   B6Dc2INYtLbyQKHZZgYWYZjqEWBx4/92GIMYLijPOtfxm/GoZDcQ6CVBr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244851027"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="244851027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 11:14:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="531923927"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 11:14:25 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] x86/sgx: Silence softlockup detection when releasing large enclaves
Date:   Tue, 18 Jan 2022 11:14:20 -0800
Message-Id: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
triggers the softlockup detector.

Actual SGX systems have 128GB of enclave memory or more.  The
"unclobbered_vdso_oversubscribed" selftest creates one enclave which
consumes all of the enclave memory on the system. Tearing down such a
large enclave takes around a minute, most of it in the loop where
the EREMOVE instruction is applied to each individual 4k enclave page.

Spending one minute in a loop triggers the softlockup detector.

Add a cond_resched() to give other tasks a chance to run and placate
the softlockup detector.

Cc: stable@vger.kernel.org
Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Softlockup message:
watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
Kernel panic - not syncing: softlockup: hung tasks
<snip>
sgx_encl_release+0x86/0x1c0
sgx_release+0x11c/0x130
__fput+0xb0/0x280
____fput+0xe/0x10
task_work_run+0x6c/0xc0
exit_to_user_mode_prepare+0x1eb/0x1f0
syscall_exit_to_user_mode+0x1d/0x50
do_syscall_64+0x46/0xb0
entry_SYSCALL_64_after_hwframe+0x44/0xae

 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..ab2b79327a8a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -410,6 +410,7 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
+		cond_resched();
 	}
 
 	xa_destroy(&encl->page_array);
-- 
2.25.1

