Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE90757ABF1
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbiGTBRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241272AbiGTBRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:17:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321CA6B27D;
        Tue, 19 Jul 2022 18:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07617B81DE2;
        Wed, 20 Jul 2022 01:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803CDC341CA;
        Wed, 20 Jul 2022 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279646;
        bh=hkb1+h6mYCHA06BuFWT4pmqFqndTQpvrGQ6vTfHFoZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkgICT62jM9BvgQFWehQytmSfzWBlPRSgTZA1gL/bWekU7rKp+jQubUlJW3DSecGZ
         jCiKOX8ZjSbAuJq7N2cs8gCuURtuXrk97C2n3LwbTCDwJ0drBy3cKH6CDe/yzNP1za
         4sA7al8EE8Vnrh95fTsE6hKs4zYFCHSufE/PCbnaWrEtGGbsdjQnhH2BKsH2I7uTMw
         Olf70fanfl3HfVVZWu1yejbnxM3G+i22wHUKzPeAV35WhMttCMs68WxmMuSMdY//fJ
         GsasfLca6I5dQAS2iZyFKTRJtAVTm3LsB2Z64z5iDOw3yPybr/f2mD5cWxrmWZdQ2q
         9RicbfzyXOMzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, luto@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Subject: [PATCH AUTOSEL 5.15 06/42] x86/vsyscall_emu/64: Don't use RET in vsyscall emulation
Date:   Tue, 19 Jul 2022 21:13:14 -0400
Message-Id: <20220720011350.1024134-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 15583e514eb16744b80be85dea0774ece153177d ]

This is userspace code and doesn't play by the normal kernel rules.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vsyscall/vsyscall_emu_64.S | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_emu_64.S b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
index 15e35159ebb6..ef2dd1827243 100644
--- a/arch/x86/entry/vsyscall/vsyscall_emu_64.S
+++ b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
@@ -19,17 +19,20 @@ __vsyscall_page:
 
 	mov $__NR_gettimeofday, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_time, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_getcpu, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 4096, 0xcc
 
-- 
2.35.1

