Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE134DBC6
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhC2Wao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhC2W16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EAC2619E7;
        Mon, 29 Mar 2021 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056661;
        bh=CQIn908qh2svdxn9QEvTZ/Weq2RS+PhRq9G0DujlHLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVbbqv3TchjujXggFQGjlqM0q0qjCIAUNYpTdW1hUFUjE+MH9VV2Ea/ljhlZ6lbUT
         PrgWnE/1ToHDPtbmbL4bh0RZKAnx0R+cZmJci4Ywzkh25Ig31Zfq0OwfRrT4OPOWdP
         qB3QPYOg22VUry3vTR5a5jLdpOdNu4za6SUCDRuMw75z598e1PuwVG000F7ypUUbTu
         gtSyeTGpEJj4nMxTiEQR7Z2MOM8sEjWe4tNHOcqnjYhrsPxEwwkjKcS1K29sa9wxND
         BSiACLWuc6T4/f7ThDNYDetMpOqofwNmeBIRlf8thTXH9Xt5zuWYfMgi6aKeoFnuuV
         b/7eXQvMGxeLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 5/8] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:24:11 -0400
Message-Id: <20210329222415.2384075-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222415.2384075-1-sashal@kernel.org>
References: <20210329222415.2384075-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9fcb51c14da2953de585c5c6e50697b8a6e91a7b ]

The new Ubuntu GCC packages turn on -fcf-protection globally,
which causes a build failure in the x86 realmode code:

  cc1: error: ‘-fcf-protection’ is not compatible with this target

Turn it off explicitly on compilers that understand this option.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210323124846.1584944-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5fece9334f12..2b3adb3008c3 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -34,7 +34,7 @@ REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse
+		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
-- 
2.30.1

