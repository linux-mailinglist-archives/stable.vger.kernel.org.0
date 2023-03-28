Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837C76CC453
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbjC1PDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjC1PDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B33BE3B1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 436EE6184D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52570C433EF;
        Tue, 28 Mar 2023 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015735;
        bh=UbuUN3KSzDuMN6TkFM0V/FPldvR4d6VQ/uFQrR0BVew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0488ah5maDANX3GtnXW12wvsiyS9eQ6rXAVL9+rSEjl+IXoiF1v/AKJ0y4KxR3AZ4
         LMYdMfd9kfijJUEpfgecaMa+q3sQpzmlR/aLl7Wd2/bDH54hY08vn2WbNv1eFsGU1X
         xfLx3sZ5+FhbDDXHAMGczeGlVCHldRVf+Je6sEj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mingwei Zhang <mizhang@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.1 157/224] x86/fpu/xstate: Prevent false-positive warning in __copy_xstate_uabi_buf()
Date:   Tue, 28 Mar 2023 16:42:33 +0200
Message-Id: <20230328142623.925787486@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chang S. Bae <chang.seok.bae@intel.com>

commit b15888840207c2bfe678dd1f68a32db54315e71f upstream.

__copy_xstate_to_uabi_buf() copies either from the tasks XSAVE buffer
or from init_fpstate into the ptrace buffer. Dynamic features, like
XTILEDATA, have an all zeroes init state and are not saved in
init_fpstate, which means the corresponding bit is not set in the
xfeatures bitmap of the init_fpstate header.

But __copy_xstate_to_uabi_buf() retrieves addresses for both the tasks
xstate and init_fpstate unconditionally via __raw_xsave_addr().

So if the tasks XSAVE buffer has a dynamic feature set, then the
address retrieval for init_fpstate triggers the warning in
__raw_xsave_addr() which checks the feature bit in the init_fpstate
header.

Remove the address retrieval from init_fpstate for extended features.
They have an all zeroes init state so init_fpstate has zeros for them.
Then zeroing the user buffer for the init state is the same as copying
them from init_fpstate.

Fixes: 2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")
Reported-by: Mingwei Zhang <mizhang@google.com>
Link: https://lore.kernel.org/kvm/20230221163655.920289-2-mizhang@google.com/
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Mingwei Zhang <mizhang@google.com>
Link: https://lore.kernel.org/all/20230227210504.18520-2-chang.seok.bae%40intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1118,21 +1118,20 @@ void __copy_xstate_to_uabi_buf(struct me
 	zerofrom = offsetof(struct xregs_state, extended_state_area);
 
 	/*
-	 * The ptrace buffer is in non-compacted XSAVE format.  In
-	 * non-compacted format disabled features still occupy state space,
-	 * but there is no state to copy from in the compacted
-	 * init_fpstate. The gap tracking will zero these states.
+	 * This 'mask' indicates which states to copy from fpstate.
+	 * Those extended states that are not present in fpstate are
+	 * either disabled or initialized:
+	 *
+	 * In non-compacted format, disabled features still occupy
+	 * state space but there is no state to copy from in the
+	 * compacted init_fpstate. The gap tracking will zero these
+	 * states.
+	 *
+	 * The extended features have an all zeroes init state. Thus,
+	 * remove them from 'mask' to zero those features in the user
+	 * buffer instead of retrieving them from init_fpstate.
 	 */
-	mask = fpstate->user_xfeatures;
-
-	/*
-	 * Dynamic features are not present in init_fpstate. When they are
-	 * in an all zeros init state, remove those from 'mask' to zero
-	 * those features in the user buffer instead of retrieving them
-	 * from init_fpstate.
-	 */
-	if (fpu_state_size_dynamic())
-		mask &= (header.xfeatures | xinit->header.xcomp_bv);
+	mask = header.xfeatures;
 
 	for_each_extended_xfeature(i, mask) {
 		/*
@@ -1151,9 +1150,8 @@ void __copy_xstate_to_uabi_buf(struct me
 			pkru.pkru = pkru_val;
 			membuf_write(&to, &pkru, sizeof(pkru));
 		} else {
-			copy_feature(header.xfeatures & BIT_ULL(i), &to,
+			membuf_write(&to,
 				     __raw_xsave_addr(xsave, i),
-				     __raw_xsave_addr(xinit, i),
 				     xstate_sizes[i]);
 		}
 		/*


