Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F48420C3F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhJDND7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234115AbhJDNCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:02:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72DD96140A;
        Mon,  4 Oct 2021 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352366;
        bh=Ph40bzWZ+VYDS03XR1nO7k7kHctxU69Bi/ZMKB5DkMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhnCThdFQj5VpyhnRhj8O/D9dUdtQikiv36IpDF47y02I4eKVCYukdFdckMiXz2hU
         rHOpI+1UHtg3WO+gzmOg0LZoXYGjoqh0LozY3fKFgUiy2Oq6+sIhvKoKjcbW6//Faz
         9pqLrzIUYDy5tMB6dabA62sQ3XykmaNL0h//zMeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 32/75] parisc: Use absolute_pointer() to define PAGE0
Date:   Mon,  4 Oct 2021 14:52:07 +0200
Message-Id: <20211004125032.594286145@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



