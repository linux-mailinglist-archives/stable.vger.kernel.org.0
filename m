Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECEF50F772
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346896AbiDZJMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbiDZJGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F930151F32;
        Tue, 26 Apr 2022 01:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02EA61344;
        Tue, 26 Apr 2022 08:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016C1C385AF;
        Tue, 26 Apr 2022 08:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962876;
        bh=I7E4f3rFKZQ0HQraiuVyxk/qYySAiRYvtrWeIKvVc1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZMTo0fg+VL/hIDnqGc/LLtwKiM5qZll6JN7trq809j84M/gy1OC/ThE8uJb2UEy1
         UmNW0P5Z2zhCrux7JsLwGNV5lOwxgfPQDuOWQ3Y2lMRYaSTXGyqeu+xMHnYYRJAgwf
         +CZ2jg/Q/yVBDw2SDfP36xDTj7ioOpvyrZ2LEBnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.17 118/146] xtensa: fix a7 clobbering in coprocessor context load/store
Date:   Tue, 26 Apr 2022 10:21:53 +0200
Message-Id: <20220426081753.374086021@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 839769c35477d4acc2369e45000ca7b0b6af39a7 upstream.

Fast coprocessor exception handler saves a3..a6, but coprocessor context
load/store code uses a4..a7 as temporaries, potentially clobbering a7.
'Potentially' because coprocessor state load/store macros may not use
all four temporary registers (and neither FPU nor HiFi macros do).
Use a3..a6 as intended.

Cc: stable@vger.kernel.org
Fixes: c658eac628aa ("[XTENSA] Add support for configurable registers and coprocessors")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/coprocessor.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 


