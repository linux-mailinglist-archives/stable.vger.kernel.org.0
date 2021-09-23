Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D6941568E
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbhIWDmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239065AbhIWDky (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B279D6124A;
        Thu, 23 Sep 2021 03:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368360;
        bh=aZ7QOpDethf1OwakF5XFCsnRdydSbHiJYLJiGSG0lgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K93AEYa0qf6klCg7+rwPjx9ADoq3f2O8YsHG9sQG2rO8f7Dtg7a4jfLsrPuVI+Hay
         gw/sFNoU6qYRT/Ei+TwFqM+37j2JcfDcM8xKLqKLj9MgS2lfNWxXgt0aXaX08vNWfy
         gPOGQKqNsERDMCfeFdOmMKzbWb+ob0wkoFXV0nQV2DlyZ6WVFanEf3z7SGPX5y1CRD
         H9Cc6LI9ukQ8k+pGCSviUdJ8eVuRFw1qwVCC2681/+7hbhDQwNOqosnsHfZgbBRI41
         BZxUddMFBc4Y+b2TWjBYWTxTUJliCVRcQ3bJ0gZuG2P7j1sCbk9ipWsJ7olcRfXibz
         Q6aWSHkI764Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/19] parisc: Use absolute_pointer() to define PAGE0
Date:   Wed, 22 Sep 2021 23:38:49 -0400
Message-Id: <20210923033853.1421193-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 93caf17ac5e2..9ebf3b0413d5 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -181,7 +181,7 @@ extern int npmem_ranges;
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>
 
-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
+#define PAGE0   ((struct zeropage *)absolute_pointer(__PAGE_OFFSET))
 
 /* DEFINITION OF THE ZERO-PAGE (PAG0) */
 /* based on work by Jason Eckhardt (jason@equator.com) */
-- 
2.30.2

