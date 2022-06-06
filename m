Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AEC53E39A
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiFFIua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiFFIuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:50:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E4F35
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 01:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654505237; x=1686041237;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6zkmf8dpJwqQab7Y0AsW0CgxvTOmU9yaEcr//UEsV20=;
  b=EuYogeSGYJ836chbXp9uGGeUGyfHNiKJMLiKGnOgt+D8zQ8Z6D8iVGQq
   X0I1ZHnwquvsh/kJHwAPcDWNzCxs1I5IFSxPyL9DKtYvCg6DV2vYqwyhq
   q84gVoztba2IP3E7NTOPde11uvipEGpnetjyrBq//jkgWrpALo83IBkIF
   GVAMZfUCL3PhsOxJmP2NsTbCP8I7oqGT4fmfZ/F3f14/FErAV7SdaK4tG
   dbjCxD9gcJasJdRohUmOrKlFArGF+o1DO2XGhtWiYvUck9+jQs3w812Lb
   qwSwHGw5yTG9dxjDFaWTtowC/Q4tRafXHX2oLMVoy1Knt/FbtgQ2SeNyd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="256476369"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="256476369"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682162720"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 01:47:16 -0700
From:   shaoqin.huang@intel.com
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon,  6 Jun 2022 17:48:43 -0600
Message-Id: <20220606234843.2931871-1-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

When freeing obsolete previous roots, check prev_roots as intended, not
the current root.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4653688fa6d..e826ee9138fa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5179,7 +5179,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
-		if (is_obsolete_root(kvm, mmu->root.hpa))
+		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-- 
2.30.2

