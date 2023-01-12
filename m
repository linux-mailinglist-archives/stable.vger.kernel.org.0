Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E0B6673C4
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjALN5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjALN5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:57:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89F0517C3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:57:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42BF16202A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCB7C433D2;
        Thu, 12 Jan 2023 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531854;
        bh=vW1oJVo+2y6fr34fPRzOm9gsCuR9xrq4mH9jEIv8ylc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTOOMBKlsecn226pq043jxud6dh4PTU3YKL2diMpnh1w+PbZiZ7gMRo/4xlBE6r3j
         JSfKH77AsBiW4mRSWNRtOhya7HX6oBOq5FvyWd3hcDjdNig17HlkKCrWWG8ty9Pk/e
         rP8Ti8OL29BERNZDwpPTM1pEGIpUe/SCASgHs9uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 04/10] x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
Date:   Thu, 12 Jan 2023 14:56:41 +0100
Message-Id: <20230112135326.849086713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 2c87767c35ee9744f666ccec869d5fe742c3de0a upstream

In preparation for adding PKRU handling code into copy_uabi_to_xstate(),
add an argument that copy_uabi_from_kernel_to_xstate() can use to pass the
canonical location of the PKRU value. For
copy_sigframe_from_user_to_xstate() the kernel will actually restore the
PKRU value from the fpstate, but pass in the thread_struct's pkru location
anyways for consistency.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-4-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1092,7 +1092,7 @@ static int copy_from_buffer(void *dst, u
 
 
 static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	unsigned int offset, size;
 	struct xstate_header hdr;
@@ -1161,7 +1161,7 @@ static int copy_uabi_to_xstate(struct xr
  */
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru)
 {
-	return copy_uabi_to_xstate(xsave, kbuf, NULL);
+	return copy_uabi_to_xstate(xsave, kbuf, NULL, pkru);
 }
 
 /*
@@ -1172,7 +1172,7 @@ int copy_uabi_from_kernel_to_xstate(stru
 int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf, &tsk->thread.pkru);
 }
 
 static bool validate_xsaves_xrstors(u64 mask)


