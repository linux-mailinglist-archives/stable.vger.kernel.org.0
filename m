Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8422F53E3C6
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiFFIsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiFFIrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:47:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D21154B17
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 01:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654505052; x=1686041052;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6zkmf8dpJwqQab7Y0AsW0CgxvTOmU9yaEcr//UEsV20=;
  b=CjNin7VuMfZGXWM/XBiVwThD9e3PyEvbzLwf3Zgdw6M2Q72TXW2C9LKa
   emoWdtul4g4Gy2DWplm9vkeW+tf5Wl7rEkJphdPuGiPX08kUAura0lPuN
   wXtNF8jjpBFBTWIQhBzj6W6DeT88KO3OriL9/cVJzatERpcqBnqjQlSre
   bw5hkwlXboLRBqV0gRmY1qddxBsDXGpf4DWfX1b3aFsedDInktVQQjBF6
   b09OuyTgZKrSkrZpwdmYvNurS8WXW0V5Co0+GwxREv1F+q58L9HsRBA9R
   90Mf0u5sGFslpHCIAHo0UHrJjsceYTfa8y1Xvf/fZ0xa0UJ9gunBv9TCN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="339855237"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="339855237"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682161482"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 01:42:55 -0700
From:   shaoqin.huang@intel.com
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon,  6 Jun 2022 17:44:19 -0600
Message-Id: <20220606234419.2931598-1-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
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

