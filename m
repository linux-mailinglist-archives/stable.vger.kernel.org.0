Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D774156E5
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbhIWDoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239354AbhIWDmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CA061261;
        Thu, 23 Sep 2021 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368417;
        bh=DLAdkWUqA/ayAanHCdiOA3nqV+CZxYuijdB8dphiLdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9/mzs8z6Qg2xTJLI2bgI1fMXhugz4snGGtt8PzZdkh16GUcGGfUB2c9MxmSc0xVP
         5NbVBunGYKGWMueqtbhfhZ8RG8roAQfrmVQk3N5a9Oj8saW//OM/JGMtzN8IWG2aN+
         bHspyWIeBaGI+K5FEh8413ROrFCu5y8yot1nZSe+Jl288M3A7atxkEl6ZE8AlX0r0x
         SCUT27gSi0+gOQKfCvr4bRdX+EBKQX3mbqYvfAsMJQxYlC124uDy3z2o5+ldd+7hG2
         RqNyXuYr5PkEzSzJJw1ZId8+FOuIqXHdPcveiqLxcLLA7ZW4bZWxWfdVN6xHic8k0c
         6zQ2J+aypJR+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/13] parisc: Use absolute_pointer() to define PAGE0
Date:   Wed, 22 Sep 2021 23:39:55 -0400
Message-Id: <20210923033959.1421662-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033959.1421662-1-sashal@kernel.org>
References: <20210923033959.1421662-1-sashal@kernel.org>
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
index af00fe9bf846..c631a8fd856a 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -179,7 +179,7 @@ extern int npmem_ranges;
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>
 
-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
+#define PAGE0   ((struct zeropage *)absolute_pointer(__PAGE_OFFSET))
 
 /* DEFINITION OF THE ZERO-PAGE (PAG0) */
 /* based on work by Jason Eckhardt (jason@equator.com) */
-- 
2.30.2

