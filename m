Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A04F460B
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbiDEM2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355739AbiDELz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 07:55:26 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388BDB879;
        Tue,  5 Apr 2022 04:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649157199; x=1680693199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=32517Peu1iHVDouFzkQPCx+iZWRftDCxZE0lexD+4Kg=;
  b=e1sl0XgvQrGgf/5wwHcW4wxu4KCf4fKar37EyzYccc3x+KOqERdrsT2J
   buLBow4+RwJeOfhXMOPD0Bl6JNtrEyUuQn2D+dCQ89PxbMtnxkh5q0f4f
   jO5/N/U/5SyFalo2hVZr0EBvBdy8nmMccmRjqkhG/vbp8j0SRwT+VVtGy
   Ka6byebBayaTRpLH4XwoSvEzE8ZpsLB4Kf43zcyrfEAh6TWuK8nQqWCr+
   40uLj0Qmn5wqKEu3w2szIEcpkEvXfoWDwkOQJLaWsdTmf56+HHGDwgUjb
   lQc71z28QR+Ua1pCXcTmkb8HX9p69UBTIu0O1cyLYwxKCmn1sgVKm7i1l
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="321417246"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321417246"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:13:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="523952439"
Received: from chang-linux-3.sc.intel.com ([172.25.112.114])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2022 04:13:18 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     yang.zhong@intel.com, bonzini@gnu.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [PATCH][Rebased for 5.16] x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation
Date:   Tue,  5 Apr 2022 04:04:56 -0700
Message-Id: <20220405110456.24877-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <164905801910825@kroah.com>
References: <164905801910825@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Zhong <yang.zhong@intel.com>

This is backport for 5.16

Upstream commit 063452fd94d153d4eb38ad58f210f3d37a09cca4

ARCH_REQ_XCOMP_PERM is supposed to add the requested feature to the
permission bitmap of thread_group_leader()->fpu. But the code overwrites
the bitmap with the requested feature bit only rather than adding it.

Fix the code to add the requested feature bit to the master bitmask.

Fixes: db8268df0983 ("x86/arch_prctl: Add controls for dynamic XSTATE components")
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <bonzini@gnu.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220129173647.27981-2-chang.seok.bae@intel.com
[chang: Backport for 5.16]
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d28829403ed0..fc1ab0116f4e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1626,7 +1626,7 @@ static int __xstate_request_perm(u64 permitted, u64 requested)
 		return ret;
 
 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
-	WRITE_ONCE(fpu->perm.__state_perm, requested);
+	WRITE_ONCE(fpu->perm.__state_perm, mask);
 	/* Protected by sighand lock */
 	fpu->perm.__state_size = ksize;
 	fpu->perm.__user_state_size = usize;
-- 
2.17.1

