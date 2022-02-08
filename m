Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC44AE15E
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385340AbiBHSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 13:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358560AbiBHSst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 13:48:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D4DC0612C1;
        Tue,  8 Feb 2022 10:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644346129; x=1675882129;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GKYfrOdPKIidCVFdft/pVkcauP1SFgER+aJOOG3WDEA=;
  b=nvxCrdDs4OeAnUM9i++1tL6hCNiNV1a8ZMXu2s/MV/yWXB2zsl5q/G61
   cR3AyMXgHkhgE1wdVY7YftNxyMDaCiFAGTERLvGXYD/zrmMDkr5rUoHOR
   bzZsILWoaMRTBOqBVQCN1uQhEFjJ6PLpOWyb2cbxm+Msg6CGClNMsTkkB
   D0RqUTQkseeqYgAt9JvJYLEG4idlo1UwKatmXwyzChHR2wG3RHSwNJ9aA
   IioWmKRt1h5QFFSJ/oDu/nrDG72iwpLLEbjmsgSOIWuVvZG6XRsC4NDSF
   5uNLZ/UwS1MlXxO3ocA7Iyz/zy9RnqlSAkYHXnMTni+mxnfNLc5X4nt5v
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="236430341"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="236430341"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 10:48:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="484914385"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 10:48:14 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     vijay.dhanraj@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH V3] x86/sgx: Silence softlockup detection when releasing large enclaves
Date:   Tue,  8 Feb 2022 10:48:07 -0800
Message-Id: <ced01cac1e75f900251b0a4ae1150aa8ebd295ec.1644345232.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>  (kselftest as sanity check)
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

Changes since V2:
- V2: https://lore.kernel.org/lkml/b5e9f218064aa76e3026f778e1ad0a1d823e3db8.1643133224.git.reinette.chatre@intel.com/
- Add Jarkko's "Reviewed-by" and "Tested-by" tags.

Changes since V1:
- V1: https://lore.kernel.org/lkml/1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com/
- Add comment provided by Jarkko.

 arch/x86/kernel/cpu/sgx/encl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 001808e3901c..48afe96ae0f0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -410,6 +410,8 @@ void sgx_encl_release(struct kref *ref)
 		}
 
 		kfree(entry);
+		/* Invoke scheduler to prevent soft lockups. */
+		cond_resched();
 	}
 
 	xa_destroy(&encl->page_array);
-- 
2.25.1

