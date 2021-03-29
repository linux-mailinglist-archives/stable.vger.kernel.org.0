Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084D234DA5B
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhC2WWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhC2WWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A43BB6196E;
        Mon, 29 Mar 2021 22:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056525;
        bh=+T8FEamT9Gn8wjrz9hkC84ssDLSQeiVkPxxIYPnKryU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8aeoZJwdb5riPmUckNOAa8WTQSBIU3XpLSV70ZnennVYpfnhk31fJL9PON4SDvn7
         PKrKpgcPCUJgA4BI3b07TxKq/wN6uEZ2L6xeZO6t/2kFmhRTFIR20Hax4V0ogrjTD6
         lkS+7hM43ZHDPpn7LF2BUo6OO+LZbUhXBrxdD9pJW5nThBl4p00V/jY/0LeBHVa2jy
         j5TsJm6BK2OkEcdTUaEpRx+DVRTu1LXRXNNO7FJkanob7NHhCzS7OG0/BuFzwAbZhh
         JILoXbZavm97VAZeHWIakLUhFyOh/9+UZh2AzzTDBU7QiVIuleRtUsjAo18C803zbx
         Typ94cuPMiMvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 25/38] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:21:20 -0400
Message-Id: <20210329222133.2382393-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
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
index 30920d70b48b..828f24d547b2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -27,7 +27,7 @@ endif
 REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse
+		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
 
 REALMODE_CFLAGS += -ffreestanding
 REALMODE_CFLAGS += -fno-stack-protector
-- 
2.30.1

