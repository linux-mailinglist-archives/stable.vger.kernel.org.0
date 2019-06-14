Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8673469C6
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfFNUfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfFNU37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:59 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46DC21841;
        Fri, 14 Jun 2019 20:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544198;
        bh=FPYvZGYlugqCpCeTuSTIgp2NKs/nlGzneHEZlYCdQHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+F4h7xbqDyurMhbv2tCTtlITgSo/hKwHhJVO1qbYBQ0a7h50EaaT5eOATMWTzkgN
         UVWmbrhy90Eg/pnEUuWg0c049bx1CCvriL826Yl+CbSLSdkRfRhCh+ge1AphtZA8q3
         l7Dd4RQ/qiKIa4gIe6J7u5X3/YGUe6QfXC2wW1ws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.19 16/39] xtensa: Fix section mismatch between memblock_reserve and mem_reserve
Date:   Fri, 14 Jun 2019 16:29:21 -0400
Message-Id: <20190614202946.27385-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

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
index 351283b60df6..a285fbd0fd9b 100644
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

