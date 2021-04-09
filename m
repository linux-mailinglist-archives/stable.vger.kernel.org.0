Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D73F359A76
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhDIJ7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233440AbhDIJ6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B330161221;
        Fri,  9 Apr 2021 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962255;
        bh=6ZGOqPJK9NlLnjRB08jhmZBf6echVbUhN2/g6d51iB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4lELQr8jArDwR3R8wE/iTExZOZsjRcZGzrQf9Vn+aCNeiydB84GqPERFIQ1Rfe5+
         QFl/GDgzlvS3FgBi5lxSL68/5HKUdmuyJ41W/qyK5xYII2J/0Qz/FxuBxxfyYZHBlp
         PvG50w57OBjzdKd1MBsU+8ZUDXU2jju3+9yWcSTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/23] x86/build: Turn off -fcf-protection for realmode targets
Date:   Fri,  9 Apr 2021 11:53:43 +0200
Message-Id: <20210409095303.318804236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
References: <20210409095302.894568462@linuxfoundation.org>
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
2.30.2



