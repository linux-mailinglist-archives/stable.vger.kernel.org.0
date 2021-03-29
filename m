Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D8234DB3A
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhC2W0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhC2WYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D2B46196E;
        Mon, 29 Mar 2021 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056618;
        bh=lQJl6rrbIJuXU1hsl2A6f7ngtiTajgGem+smQczGEog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gd11dpuTfI5SD7Q9unYG9wEwK2hJbbuum0jF4ySn1wmrEACIgshd4nJQ4ASPrhq4e
         jXYMbuAgy3123n1yVNYDzi4r8GYuuNV7ad4MR85KRsvON3bEoYWeBA3dOu5pRkmaY/
         8ek/LZVyVMgrRaCEQaFSXFh0jpYLm7vCLbi8KlXivJWqkELkcVx2llrU3zG77Wzyde
         WNl6OpkR6bHmqEmBshFa6BHPkfJGaXqnmMiTJ5ASGLWQ03M/bEIxIj9cXPcELIKoMU
         4x+jJ6TEu0AikTdncf6HC5HpCobq8kMhcX1KfN7N8wCENBGSmc4GVs98/bKDBQWMLL
         UO7GFUNuCVzGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/15] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:23:21 -0400
Message-Id: <20210329222327.2383533-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index 75200b421f29..6ebdbad21fb2 100644
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

