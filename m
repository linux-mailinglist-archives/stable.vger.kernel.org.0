Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C316B949C
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjCNMr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjCNMqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB2759C8;
        Tue, 14 Mar 2023 05:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DFE6176D;
        Tue, 14 Mar 2023 12:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D34C433D2;
        Tue, 14 Mar 2023 12:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797830;
        bh=buCx7DgLLXAZXSLEG++4s4YjHOZteRL7W9HfjOAGJsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAQH0Oj4ynLWvd6MW59nPq1wohHLe81Ql6fLHjLsp0/PCEDQxAemg0J7+c1jDavIV
         kV0RT3biLUkF5Hs13wOl7NvPv2zRPheGOU+YcidR7YRt3aMliC/1sgN/cOb2YJkwQ+
         imP42F/oUFGIufwJG7BAZ+5vkvDYIQn8afePXnBGFC/zss/CHtoRDzLSLyAL2jDbkw
         C9nLk11c0Ih71RbKxD02avs4lHrPC+RIW4M9iloX0M7QRubUYH0/dGES712xvGeus/
         O3yI4FNipANZGeUzAbgJ6vXxYaT/KpOWtgnmnbNatLU5PpttdOMfQzOjx7oicBVvzq
         mz/1eARLZrMfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        =?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= 
        <sergio.collado@gmail.com>, Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH AUTOSEL 5.15 03/10] rust: arch/um: Disable FP/SIMD instruction to match x86
Date:   Tue, 14 Mar 2023 08:43:37 -0400
Message-Id: <20230314124344.471127-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124344.471127-1-sashal@kernel.org>
References: <20230314124344.471127-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 8849818679478933dd1d9718741f4daa3f4e8b86 ]

The kernel disables all SSE and similar FP/SIMD instructions on
x86-based architectures (partly because we shouldn't be using floats in
the kernel, and partly to avoid the need for stack alignment, see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383 )

UML does not do the same thing, which isn't in itself a problem, but
does add to the list of differences between UML and "normal" x86 builds.

In addition, there was a crash bug with LLVM < 15 / rustc < 1.65 when
building with SSE, so disabling it fixes rust builds with earlier
compiler versions, see:
https://github.com/Rust-for-Linux/linux/pull/881

Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Sergio González Collado <sergio.collado@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile.um | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index b3c1ae084180d..d2e95d1d4db77 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -1,6 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
 core-y += arch/x86/crypto/
 
+#
+# Disable SSE and other FP/SIMD instructions to match normal x86
+#
+KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
+KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
+
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
-- 
2.39.2

