Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD250DDF5
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiDYKgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiDYKgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B944DF16
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F7160F0C
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CE1C385A7;
        Mon, 25 Apr 2022 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650882774;
        bh=g7PsMoWBlvjE6kOA+Pm1PRKZt71XK4IJCFADOaa4ec8=;
        h=Subject:To:Cc:From:Date:From;
        b=EkTZp+AxzvAqMDlFMZREqNo6X4KG+/VZ7mm217WNHjcauvPNkAboh6/iiPkAWPoke
         IDXUZs/Ct0ZifzEBYZyjJsOjTjk44YtjvRMPfJyomixbGIH9IOnT3e7182GI2AKEzA
         OVJNDrInftLZptsFv3T2s0YtiXavUp7Y8Hxy7KLQ=
Subject: FAILED: patch "[PATCH] xtensa: fix a7 clobbering in coprocessor context load/store" failed to apply to 4.14-stable tree
To:     jcmvbkbc@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:32:49 +0200
Message-ID: <1650882769255173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 839769c35477d4acc2369e45000ca7b0b6af39a7 Mon Sep 17 00:00:00 2001
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Wed, 13 Apr 2022 22:44:36 -0700
Subject: [PATCH] xtensa: fix a7 clobbering in coprocessor context load/store

Fast coprocessor exception handler saves a3..a6, but coprocessor context
load/store code uses a4..a7 as temporaries, potentially clobbering a7.
'Potentially' because coprocessor state load/store macros may not use
all four temporary registers (and neither FPU nor HiFi macros do).
Use a3..a6 as intended.

Cc: stable@vger.kernel.org
Fixes: c658eac628aa ("[XTENSA] Add support for configurable registers and coprocessors")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>

diff --git a/arch/xtensa/kernel/coprocessor.S b/arch/xtensa/kernel/coprocessor.S
index 45cc0ae0af6f..c7b9f12896f2 100644
--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -29,7 +29,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lsave_cp_regs_cp##x:						\
-		xchal_cp##x##_store a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_store a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 
@@ -46,7 +46,7 @@
 	.if XTENSA_HAVE_COPROCESSOR(x);					\
 		.align 4;						\
 	.Lload_cp_regs_cp##x:						\
-		xchal_cp##x##_load a2 a4 a5 a6 a7;			\
+		xchal_cp##x##_load a2 a3 a4 a5 a6;			\
 		jx	a0;						\
 	.endif
 

