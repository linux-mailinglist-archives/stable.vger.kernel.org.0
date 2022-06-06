Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB8653E24D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiFFIk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiFFIk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:40:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC388E180
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 01:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654504854; x=1686040854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zkmf8dpJwqQab7Y0AsW0CgxvTOmU9yaEcr//UEsV20=;
  b=WI8yjiBi+uBhnzf678MFvIwBD3AmMz9XL6zcxe/AMXvGI+H/Y2XC3too
   YG1XpRPOeyS8AFjKtj+wiknFpvCnBRv3g0dxBiK4ugtEHSFmWRmmR5KxM
   OXsLKLQzJh/Wf4HzxS8qlOGaLoOfEaLnH5cvMfBFu5ad92FPZ7Cp2qbIi
   bAu37RB1QxjE8eMne7Hw57vUBP9TTxsxT9mjmBeqQJ9kAZCTnxHfoGRuz
   Z2HZmkHXfzzc6fzITjx8HrQOEDZorrOwBeztvp8zflp8ZBwZlQIqBukGa
   KhJmv3CSslihhZqupYP83NZIg+3GdkFcu3r0h2cDhVabJmOlYxwJOiIFg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="256475868"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="256475868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="825710895"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2022 01:40:51 -0700
From:   shaoqin.huang@intel.com
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon,  6 Jun 2022 17:42:11 -0600
Message-Id: <20220606234211.2931304-2-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220606234211.2931304-1-shaoqin.huang@intel.com>
References: <20220606234211.2931304-1-shaoqin.huang@intel.com>
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

