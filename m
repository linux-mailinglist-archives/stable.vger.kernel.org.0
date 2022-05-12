Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B561F52575F
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 23:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358943AbiELVvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 17:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358946AbiELVvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 17:51:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C521A3B1;
        Thu, 12 May 2022 14:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652392269; x=1683928269;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xhXsmErcSssyQz0qj1iBlVLDFmZa2ltRLPoYYh5tLAM=;
  b=m56GnppuAE9xXycrjwPWODjrDjYuNw5aoBvpWI5LHkf095kldfcwsub/
   p9YuMkPRBYDCqVGBjuOR4i3iqC+SHkwAUuOL83lOkGGogo6G1MCFwXy/u
   bGj0SRsy2YrNzDq9jFD8zZlthP5NkY7/rKhmrxTST7Xpn+kFJC51GJ6AD
   43t1GAOMTEG1n3zs18nCztdk3SZK+qbI1z8T2b/Z8W1jZfYkhX0zhe1zJ
   ty0HD2s85s9JTixj/0Um1EyChuBvdNHTF2REbaA0q3TfWQ2JntNvaJxx0
   tewTloJZ0dtuq2oh5zwNN3ElQ3yraGsQsuIk5gUDEMKgkd4R1jMRq/Abd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="267736143"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="267736143"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="553955562"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:51:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     haitao.huang@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH V3 0/5] SGX shmem backing store issue
Date:   Thu, 12 May 2022 14:50:56 -0700
Message-Id: <cover.1652389823.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2:
https://lore.kernel.org/linux-sgx/cover.1652131695.git.reinette.chatre@intel.com/

Changes since V2:
- Expand audience of series to include stable team, x86 maintainers, and lkml.
- Mark pages as dirty after receiving important data, not before. (Dave)
- Improve changelogs.
- Add Haitao and Jarkko's tags.
- Fix incorrect exit if address does not have enclave page associated. (Dave)
- See individual patches for detailed changes.

First version of series was submitted with incomplete fixes as RFC V1:
https://lore.kernel.org/linux-sgx/cover.1651171455.git.reinette.chatre@intel.com/

Changes since RFC V1:
- Remaining issue was root-caused with debugging help from Dave.
  Patch 4/5 is new and eliminates all occurences of the ENCLS[ELDU] related
  WARN.
- Drop "x86/sgx: Do not free backing memory on ENCLS[ELDU] failure" from
  series. ENCLS[ELDU] failure is not recoverable so it serves no purpose to
  keep the backing memory that could not be restored to the enclave.
- Patch 1/5 is new and refactors sgx_encl_put_backing() to only put
  references to pages and not also mark the pages as dirty. (Dave)
- Mark PCMD page dirty before (not after) writing data to it. (Dave)
- Patch 5/5 is new and adds debug code to WARN if PCMD page is ever
  found to contain data after it is truncated. (Dave)

== Cover Letter ==

Hi Everybody,

Haitao reported encountering the following WARN while stress testing SGX
with the SGX2 series [1] applied:

ELDU returned 1073741837 (0x4000000d)
WARNING: CPU: 72 PID: 24407 at arch/x86/kernel/cpu/sgx/encl.c:81 sgx_encl_eldu+0x3cf/0x400
...
Call Trace:
<TASK>
? xa_load+0x6e/0xa0
__sgx_encl_load_page+0x3d/0x80
sgx_encl_load_page_in_vma+0x4a/0x60
sgx_vma_fault+0x7f/0x3b0
? sysvec_call_function_single+0x66/0xd0
? asm_sysvec_call_function_single+0x12/0x20
__do_fault+0x39/0x110
__handle_mm_fault+0x1222/0x15a0
handle_mm_fault+0xdb/0x2c0
do_user_addr_fault+0x1d1/0x650
? exit_to_user_mode_prepare+0x45/0x170
exc_page_fault+0x76/0x170
? asm_exc_page_fault+0x8/0x30
asm_exc_page_fault+0x1e/0x30
...
</TASK>

ENCLS[ELDU] is returning a #GP when attempting to load an enclave
page from the backing store into the enclave.

Haitao's stress testing involves running two concurrent loops of the SGX2
selftests on a system with 4GB EPC memory. One of the tests is modified
to reduce the oversubscription heap size:

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index d480c2dd2858..12008789325b 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -398,7 +398,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	 * Create enclave with additional heap that is as big as all
 	 * available physical SGX memory.
 	 */
-	total_mem = get_total_epc_mem();
+	total_mem = get_total_epc_mem()/16;
 	ASSERT_NE(total_mem, 0);
 	TH_LOG("Creating an enclave with %lu bytes heap may take a while ...",
 	       total_mem);

If the the test compiled with above snippet is renamed as "test_sgx_small"
and the original renamed as "test_sgx_large" the two concurrent loops are
run as follows:

(for i in $(seq 1 999); do echo "Iteration $i"; sudo ./test_sgx_large; done ) > log.large 2>&1
(for i in $(seq 1 9999); do echo "Iteration $i"; sudo ./test_sgx_small; done ) > log.small 2>&1

If the SGX driver is modified to always WARN when ENCLS[ELDU] encounters a #GP
(see below) then the WARN appears after a few iterations of "test_sgx_large"
and shows up throughout the testing.

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..68c1dbc84ed3 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -18,7 +18,7 @@
 #define ENCLS_WARN(r, name) {						  \
 	do {								  \
 		int _r = (r);						  \
-		WARN_ONCE(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
+		WARN(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
 	} while (0);							  \
 }


I learned the following during investigation of the issue:
* Reverting commit 08999b2489b4 ("x86/sgx: Free backing memory after
  faulting the enclave page") resolves the issue. With that commit
  reverted the concurrent selftest loops can run to completion without
  encountering any WARNs.

* The issue is also resolved if only the calls (introduced by commit
  08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave
  page") ) to sgx_encl_truncate_backing_page() within __sgx_encl_eldu()
  are disabled.

* ENCLS[ELDU] faults with #GP when the provided PCMD data is all zeroes. It
  does so because of a check that is not documented in the SDM. In this
  check a page type of zero indicates an SECS page is being loaded into the
  enclave, but since the SECS data is not empty the instruction faults with
  #GP.

The fixes in this series address scenarios where the PCMD data in the
backing store may not be correct. While the SGX2 tests uncovered these
issues, the fixes are not related to SGX2 and apply on top of v5.18-rc6.
There are no occurences of the WARN when the stress testing is performed
with this series applied.

Thank you very much

Reinette

[1] https://lore.kernel.org/lkml/cover.1649878359.git.reinette.chatre@intel.com/

Reinette Chatre (5):
  x86/sgx: Disconnect backing page references from dirty status
  x86/sgx: Mark PCMD page as dirty when modifying contents
  x86/sgx: Obtain backing storage page with enclave mutex held
  x86/sgx: Fix race between reclaimer and page fault handler
  x86/sgx: Ensure no data in PCMD page after truncate

 arch/x86/kernel/cpu/sgx/encl.c | 113 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/encl.h |   2 +-
 arch/x86/kernel/cpu/sgx/main.c |  13 ++--
 3 files changed, 114 insertions(+), 14 deletions(-)

base-commit: c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a
-- 
2.25.1

