Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7BDD49A
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfJRW0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJRWEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846E8222C5;
        Fri, 18 Oct 2019 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436264;
        bh=OPQh/w0HN7ptn6tENX2+5V6kRqT+2oS1MekYamXmnGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZskRA1csfKJ5xKxjFP5cTTgkZB75xSTdoYB4jXAO81fGmuSXTOKEF/NgKCWOGCep3
         B1Cril9d8nqP0cA/KuC1CxhoyC67HP2/pMD4vAvcdLFYj1Uqw5oGk8WD3poSSAhtiH
         PrdqH8mg/bc2qJyJbNa9x+uGZnHuwgN4OhtvSmDk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 46/89] arm64: Default to building compat vDSO with clang when CONFIG_CC_IS_CLANG
Date:   Fri, 18 Oct 2019 18:02:41 -0400
Message-Id: <20191018220324.8165-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 24ee01a927bfe56c66429ec4b1df6955a814adc8 ]

Rather than force the use of GCC for the compat cross-compiler, instead
extract the target from CROSS_COMPILE_COMPAT and pass it to clang if the
main compiler is clang.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 9743b50bdee7d..5858d6e449268 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -47,7 +47,11 @@ $(warning Detected assembler with broken .inst; disassembly will be unreliable)
   endif
 endif
 
+ifeq ($(CONFIG_CC_IS_CLANG), y)
+COMPATCC ?= $(CC) --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
+else
 COMPATCC ?= $(CROSS_COMPILE_COMPAT)gcc
+endif
 export COMPATCC
 
 ifeq ($(CONFIG_GENERIC_COMPAT_VDSO), y)
-- 
2.20.1

