Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE43359B09
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhDIKHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhDIKET (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:04:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CBF61284;
        Fri,  9 Apr 2021 10:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962459;
        bh=czFULzrX0pbg8fLjls/S30NW/0cabqVjxQNGwIYIuEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSUZ1BcRp3fM8stg3H/GKxaawYVy7l8RsJSnl3YnLeZ2GuvJj92ILvt9qdXh4H94/
         JvjyDhdBxYgM4dZpNc1S810/9dFiAlBGYUM1R2scWA6MYmQejV1ewTXa68EUP0FZZQ
         lnCPQYB0IyRJfUiG0yyT8mlQiU7uX396RFvXp5Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 23/45] x86/build: Turn off -fcf-protection for realmode targets
Date:   Fri,  9 Apr 2021 11:53:49 +0200
Message-Id: <20210409095306.162939565@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



