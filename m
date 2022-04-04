Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B354F100F
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiDDHmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 03:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377704AbiDDHmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 03:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B931C237D4
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 00:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27BD6B80EF0
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 07:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47861C2BBE4;
        Mon,  4 Apr 2022 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649058022;
        bh=8pNViFchbvMofwAM/rj7LA8ZRQ6iGp/dbqVhzGeCXoc=;
        h=Subject:To:Cc:From:Date:From;
        b=C0t56JneXLbFPeRmGU+Bi1+px2Ma3kJUpT/kZ9iCciYX+jZvSn0fxNBpbEMYwdrCP
         QIVMoD2qma8XBToEus9DcVXw2ncUrlNdkGxdUKSWwW+N5U2SazgbxOLorhgSR5s9Qq
         jxphfsVkmh4v8zU/BqzdoKj+maOjqTNRArRnqt2s=
Subject: FAILED: patch "[PATCH] x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation" failed to apply to 5.16-stable tree
To:     yang.zhong@intel.com, bonzini@gnu.org, chang.seok.bae@intel.com,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 09:40:19 +0200
Message-ID: <164905801910825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 063452fd94d153d4eb38ad58f210f3d37a09cca4 Mon Sep 17 00:00:00 2001
From: Yang Zhong <yang.zhong@intel.com>
Date: Sat, 29 Jan 2022 09:36:46 -0800
Subject: [PATCH] x86/fpu/xstate: Fix the ARCH_REQ_XCOMP_PERM implementation

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

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 7c7824ae7862..dc6d5e98d296 100644
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

