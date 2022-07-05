Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD8566CD7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiGEMUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237558AbiGEMTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E41D311;
        Tue,  5 Jul 2022 05:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B940EB817C7;
        Tue,  5 Jul 2022 12:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FAAC341C8;
        Tue,  5 Jul 2022 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023308;
        bh=c5GIsAphQBPWHjOKu+r1cRRV00Ect1dMJ5oXCTCjbHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP3PlPFIaWhAJOItjroBpb8yCa8iYA1YmlTIiueMIEDhXqI2b1061UrLEqDlUmjZe
         +pjvLVuSH6StkwfYiOrJQY/k/uNyGbwXnEzrztKgRYx/6Mz2jVXa1Dm8Lcdl1GkBc5
         l34GUI57IwRO2VtzD/CsARTltBy488dlUsmHmSyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 014/102] parisc: Fix vDSO signal breakage on 32-bit kernel
Date:   Tue,  5 Jul 2022 13:57:40 +0200
Message-Id: <20220705115618.819772939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit aa78fa905b4431c432071a878da99c2b37fc0e79 upstream.

Addition of vDSO support for parisc in kernel v5.18 suddenly broke glibc
signal testcases on a 32-bit kernel.

The trampoline code (sigtramp.S) which is mapped into userspace includes
an offset to the context data on the stack, which is used by gdb and
glibc to get access to registers.

In a 32-bit kernel we used by mistake the offset into the compat context
(which is valid on a 64-bit kernel only) instead of the offset into the
"native" 32-bit context.

Reported-by: John David Anglin <dave.anglin@bell.net>
Tested-by: John David Anglin <dave.anglin@bell.net>
Fixes: 	df24e1783e6e ("parisc: Add vDSO support")
CC: stable@vger.kernel.org # 5.18
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/asm-offsets.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/parisc/kernel/asm-offsets.c b/arch/parisc/kernel/asm-offsets.c
index 2673d57eeb00..94652e13c260 100644
--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -224,8 +224,13 @@ int main(void)
 	BLANK();
 	DEFINE(ASM_SIGFRAME_SIZE, PARISC_RT_SIGFRAME_SIZE);
 	DEFINE(SIGFRAME_CONTEXT_REGS, offsetof(struct rt_sigframe, uc.uc_mcontext) - PARISC_RT_SIGFRAME_SIZE);
+#ifdef CONFIG_64BIT
 	DEFINE(ASM_SIGFRAME_SIZE32, PARISC_RT_SIGFRAME_SIZE32);
 	DEFINE(SIGFRAME_CONTEXT_REGS32, offsetof(struct compat_rt_sigframe, uc.uc_mcontext) - PARISC_RT_SIGFRAME_SIZE32);
+#else
+	DEFINE(ASM_SIGFRAME_SIZE32, PARISC_RT_SIGFRAME_SIZE);
+	DEFINE(SIGFRAME_CONTEXT_REGS32, offsetof(struct rt_sigframe, uc.uc_mcontext) - PARISC_RT_SIGFRAME_SIZE);
+#endif
 	BLANK();
 	DEFINE(ICACHE_BASE, offsetof(struct pdc_cache_info, ic_base));
 	DEFINE(ICACHE_STRIDE, offsetof(struct pdc_cache_info, ic_stride));
-- 
2.37.0



