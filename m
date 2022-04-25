Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF92A50DDF7
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiDYKgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiDYKgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BC664D0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ACDB60EA5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B55C385A4;
        Mon, 25 Apr 2022 10:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650882770;
        bh=pn0OF2W6T4+696QLumfSgjnlW2dUVCcXPjG3e7izCT0=;
        h=Subject:To:Cc:From:Date:From;
        b=jgWWpJq2ucQA8lOXfLSV2XiAvG32FQkaa2hAKjLIUAMFpM0HaBjEA56J+hKaXi3Bo
         /W99kF5l+rB1ojUoc8rBwNIDDunPMqIbHVJuy9M8OL2Mn6SILEKk2B4OCabwm7eKNc
         pX6+LnpHmh6EP8fh1Mf+2OTjcWL4IdDR9rCqfF3A=
Subject: FAILED: patch "[PATCH] xtensa: fix a7 clobbering in coprocessor context load/store" failed to apply to 4.19-stable tree
To:     jcmvbkbc@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:32:47 +0200
Message-ID: <165088276783167@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
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
 

