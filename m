Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C184E5BD0
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 00:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345467AbiCWXdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345405AbiCWXdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 19:33:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8FE90CD5;
        Wed, 23 Mar 2022 16:31:44 -0700 (PDT)
Date:   Wed, 23 Mar 2022 23:31:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648078302;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PT1maxWW5NNo9X1wLuCr6EW7XZ21JWxdjhPR3iYLg6M=;
        b=m97itk0cwVz2OFyFZgoHOLAehrle3xst6TRwYXT8Fzqs7/NftfylqFRIPfTc+YgMZyObr9
        crPuhA1+A+w/zWr2L4yAmx38LcNY3Iztb3bvaGuK2Hl4AovskX11ess2hlolHOc2hTyGIQ
        kEpJLFLvE4/X7fBAe29tFoTXJUBenf9wg6r1SFgqYkLh7iM+kE4JXWHFOStAuGEXZ44R9i
        qBdjBWditqJ6rwuINo1Ff3tyEE2g81xZDNGVTR7qhz4V4GvQfO79hzfQ4CG/uGhAwyOuf3
        nluERvh64gBEtId1k/6hdr0hI+0j3KP3hEtV7r7bP0CVYAL3R8e/m1n8QdHjow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648078302;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PT1maxWW5NNo9X1wLuCr6EW7XZ21JWxdjhPR3iYLg6M=;
        b=hoJySjsgFmvMf/dUsT0yWpvZELjWwCo2Pf/1Ylxr0fNeFVWgZ8FAnDJalRYPeHbclDhjFG
        JTPc4jcuQ1XXuRCw==
From:   "tip-bot2 for Yang Zhong" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation
Cc:     Yang Zhong <yang.zhong@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <bonzini@gnu.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220129173647.27981-2-chang.seok.bae@intel.com>
References: <20220129173647.27981-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Message-ID: <164807830122.389.15178914175068421091.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     063452fd94d153d4eb38ad58f210f3d37a09cca4
Gitweb:        https://git.kernel.org/tip/063452fd94d153d4eb38ad58f210f3d37a09cca4
Author:        Yang Zhong <yang.zhong@intel.com>
AuthorDate:    Sat, 29 Jan 2022 09:36:46 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 23 Mar 2022 21:28:34 +01:00

x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation

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

---
 arch/x86/kernel/fpu/xstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 7c7824a..dc6d5e9 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1639,7 +1639,7 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 
 	perm = guest ? &fpu->guest_perm : &fpu->perm;
 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
-	WRITE_ONCE(perm->__state_perm, requested);
+	WRITE_ONCE(perm->__state_perm, mask);
 	/* Protected by sighand lock */
 	perm->__state_size = ksize;
 	perm->__user_state_size = usize;
