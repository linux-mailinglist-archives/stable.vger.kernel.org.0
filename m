Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F62053E235
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiFFItw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiFFIsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:48:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16B016CF44
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 01:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654505186; x=1686041186;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zkmf8dpJwqQab7Y0AsW0CgxvTOmU9yaEcr//UEsV20=;
  b=aB0X5ywjtdLhQ7aFRavBDYyhERcqb0pQ5R3X2wf5cGlX0qO9ihuivY6v
   NVv90q6ky1N27DiOr0CVoAjpxjsrwjp9BlJ6s8RfXZRxNRtSDtguhQUaV
   N3peucLdDTmWKuGGg0utt1IDpWM3pNSXq/Myxd5VXdSQXRcqrJdfj8lBz
   NMID0ncGeCJYf7zs9Bx3whM6Pz9uEJWO2V/K2mMmhV87qIGpFS3O6ehSa
   8Gie+EUxG32f/HJcj671f+R0GhHIiYWp67enlPLjyvPtEaspDwRQVGEo1
   CMJyfT4SWYynIxFeant8Tib7uHMtER5PCxIr1ZHG/lGoDKfSXbAYnSwmO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="264485292"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="264485292"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:45:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682162079"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 01:45:08 -0700
From:   shaoqin.huang@intel.com
To:     shaoqin.huang@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon,  6 Jun 2022 17:46:36 -0600
Message-Id: <20220606234636.2931713-1-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

