Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB634DB17
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhC2WZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232597AbhC2WXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4E1619D3;
        Mon, 29 Mar 2021 22:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056600;
        bh=Axxe7NPevMqW1GJ0sazAA+74mjHbvPUktiS7HTasWGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3UsEY8JTBX+ZuGbQhilM91kQZCyw33+iRo4xU5ixOSS8Re3XpwIja3yxXpGENk7w
         rqCVJr2y5MfPVXfC8k+ggeDjQ5DmaLEavLsyWVXhztyxbE6E+uUc3GLSMe1DSXSTGv
         BW28bTqgn5lac8EHrnEb9Uv7AFvcofjOxRM7UoEUE495tF1WW6gb/T3rovum3W+ueT
         pshhbSbTFM5uJxHM9E55DbNxJC/0TKQWtwUqgFvK+RGXyhdahtVZxMhpbnPD1gAM/D
         1DTWipdYsbdxPkHvn2M1I/k/iqEwB1SkaPIdoz3o0DQu89LNQtCCbuIssKbkixOTzI
         cbJPZuAVVXicw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 14/19] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:22:57 -0400
Message-Id: <20210329222303.2383319-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
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
index 8ca3cf7c5ec9..59942e349e5f 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -34,7 +34,7 @@ M16_CFLAGS	 := $(call cc-option, -m16, $(CODE16GCC_CFLAGS))
 REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse
+		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
-- 
2.30.1

