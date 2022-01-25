Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B504D49BB39
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiAYSZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:25:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:4719 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbiAYSYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 13:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643135050; x=1674671050;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UJIqw8gcL194wHLtJoARGquGC2qqeBOMWHN3mV2Gobg=;
  b=EyMMRXFt5NOcoBwlH8/Xj1wheqWzCIBlOy27ftXRanL2+l+2GqTs0/Ix
   YUkEozVsVFuOFr3JWKuuSIg3m1MahS/V/zvf0cp90tiyoUOGdNBOarW/6
   sXBoW3mlTHGg71DCaNHSs3Z7WrIKZ7vlqYjGyROAhUnK16DyWMai0RLB8
   9suKfH76ItUTKni3zOxvQnW4e2rYGvIlszallSwnpJZeRxb41V0m9KeUm
   9k8+ndr8lZNZf5q6Tiwn/Q0jRfEbYwzGFpcsEIrTcCFSsU1YvG/bAOKpM
   0x8UoFH+iCRqFuMyxATYtEnmHa66Aq+1LX48JQR+7xAgzm8ZEzhOtzDmn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246319033"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="246319033"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 10:22:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="563134939"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 10:22:48 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     vijay.dhanraj@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH V2] x86/sgx: Silence softlockup detection when releasing large enclaves
Date:   Tue, 25 Jan 2022 10:22:43 -0800
Message-Id: <b5e9f218064aa76e3026f778e1ad0a1d823e3db8.1643133224.git.reinette.chatre@intel.com>
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

