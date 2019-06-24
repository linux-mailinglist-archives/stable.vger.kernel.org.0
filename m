Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FEF506C1
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbfFXJ6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbfFXJ6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:21 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170A821537;
        Mon, 24 Jun 2019 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370301;
        bh=Ht+lqwGuGuk7NGpFlDLJDAPmiq8Fc7in8W3V2IbgdSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDPYU7hOtIy0PGy6ZAU69BVOKDOetGq8vUvkva/VEHoEfzMgBCp7Ijespqxp8xuId
         6kc8hLRqyxqyHkuMbFWcinbsZ1mltAgICdZSJxy3FIwzr1iJvDsDfmA+ZOPYnkzm9Y
         e5cMkmIErDCZsE2dVeZmNx0FY3OVjQKNZrHkroY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/51] xtensa: Fix section mismatch between memblock_reserve and mem_reserve
Date:   Mon, 24 Jun 2019 17:56:40 +0800
Message-Id: <20190624092308.879060954@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit adefd051a6707a6ca0ebad278d3c1c05c960fc3b ]

Since commit 9012d011660ea5cf2 ("compiler: allow all arches to enable
CONFIG_OPTIMIZE_INLINING"), xtensa:tinyconfig fails to build with section
mismatch errors.

WARNING: vmlinux.o(.text.unlikely+0x68): Section mismatch in reference
	from the function ___pa()
	to the function .meminit.text:memblock_reserve()
WARNING: vmlinux.o(.text.unlikely+0x74): Section mismatch in reference
	from the function mem_reserve()
	to the function .meminit.text:memblock_reserve()
FATAL: modpost: Section mismatches detected.

This was not seen prior to the above mentioned commit because mem_reserve()
was always inlined.

Mark mem_reserve(() as __init_memblock to have it reside in the same
section as memblock_reserve().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Message-Id: <1559220098-9955-1-git-send-email-linux@roeck-us.net>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 08175df7a69e..66eefe1919a4 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -310,7 +310,8 @@ extern char _SecondaryResetVector_text_start;
 extern char _SecondaryResetVector_text_end;
 #endif
 
-static inline int mem_reserve(unsigned long start, unsigned long end)
+static inline int __init_memblock mem_reserve(unsigned long start,
+					      unsigned long end)
 {
 	return memblock_reserve(start, end - start);
 }
-- 
2.20.1



