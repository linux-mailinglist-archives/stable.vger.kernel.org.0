Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3234DB8D
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhC2W2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhC2W0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6926619CF;
        Mon, 29 Mar 2021 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056649;
        bh=eU5otijuqopcfE1TXkzJJgtJO0nlHCB2jp82CmpMONo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACZg5RDEzA6xvJG5TyVVXN+VY2VdbJb8RODnOneUFj1mlqLBJRsv2lrMzH4/FI8u9
         NuAqNWkllTcAgQ6w5Q9MMHc8HmjyZMbkEJ7NAQTmK3CEeF/GazYvTd75H6hy74+MMQ
         DDkecOjbr266qU2TW1b3y0V9JjIK94Sc+fpLOBXElS2prd3wSk385CBzVWzrmTaAD/
         skMjBhZ9MNh7EUUHSfRYS+YhK1eKlU5yAMvGxwWlMd7k8sNmsudT/AeARbUHwuvuas
         G0sAvgaRDl8UPsAq8ZfxePlMEQ5S57AxgEpBL1nPYSVv0WQAvtqUT0JUyQLWgcdrkx
         loEFArOIxApOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 06/10] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:23:57 -0400
Message-Id: <20210329222401.2383930-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222401.2383930-1-sashal@kernel.org>
References: <20210329222401.2383930-1-sashal@kernel.org>
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
index 9f0099c46c88..9ebbd4892557 100644
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

