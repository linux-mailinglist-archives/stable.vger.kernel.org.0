Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926141571A
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhIWDqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239481AbhIWDoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E916961152;
        Thu, 23 Sep 2021 03:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368466;
        bh=xv9DuXWs5WL1PmyNHaQZJwzBB+tS7goqT7N4UKTv3vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6gWrqMHJp15Dbs0ZtBEY5nW+xsGFf3CJM5Ym8/1x6/3zNd/rizA+N8W/nC+o7Q1c
         TosJUPVLNz89k6Jr8PNWiCwTjuspIiveAlknbjT0AaS//Gj6+lzemoHsCy/od5stJ9
         qQpn18ndORxlkhmfZPGeUNGRv6T26PIqebHedEJoSDsrHg0c935GorWf6U3PAm1mc2
         xtg6Zr2ke9qyx+C/Ifr/Z0vmmHCLASSx4FMz49PGIvIqXH2ac6jmWj+6/XBs4FrMKg
         4ZICUtG/YCYYQUOc9NioEPWrAOI/lxYGcU/p3nbEvjmfJiTqasPhsN5a3ikXGCmb4z
         K1PDVvJFbLSOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/10] parisc: Use absolute_pointer() to define PAGE0
Date:   Wed, 22 Sep 2021 23:40:49 -0400
Message-Id: <20210923034055.1422059-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034055.1422059-1-sashal@kernel.org>
References: <20210923034055.1422059-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 90cc7bed1ed19f869ae7221a6b41887fe762a6a3 ]

Use absolute_pointer() wrapper for PAGE0 to avoid this compiler warning:

  arch/parisc/kernel/setup.c: In function 'start_parisc':
  error: '__builtin_memcmp_eq' specified bound 8 exceeds source size 0

Signed-off-by: Helge Deller <deller@gmx.de>
Co-Developed-by: Guenter Roeck <linux@roeck-us.net>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/page.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 80e742a1c162..088888fcf8df 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -174,7 +174,7 @@ extern int npmem_ranges;
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>
 
-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
+#define PAGE0   ((struct zeropage *)absolute_pointer(__PAGE_OFFSET))
 
 /* DEFINITION OF THE ZERO-PAGE (PAG0) */
 /* based on work by Jason Eckhardt (jason@equator.com) */
-- 
2.30.2

