Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C734176B64
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgCCCt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgCCCt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79D17246E6;
        Tue,  3 Mar 2020 02:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203797;
        bh=bMmVpf9tlllvIKkN11/OfHHoDlDHa128LFrYRoxxYGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqYlp/GnexpA/fg4xvMfzly0aifviUx/+ovG6FyOIY1xaYBadomMcsHQxmgrGbb0q
         WFTLE7cwXBF1ObW53lTZGrFCI5QNnCWNfqNzIzadOqIo51TMkX8uxYAHA14zxzBDVU
         cfkIjPUUAIFrdRNq9yglve7NKiTPO2OKYTWg1MnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H.J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 18/22] x86/boot/compressed: Don't declare __force_order in kaslr_64.c
Date:   Mon,  2 Mar 2020 21:49:29 -0500
Message-Id: <20200303024933.10371-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024933.10371-1-sashal@kernel.org>
References: <20200303024933.10371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

[ Upstream commit df6d4f9db79c1a5d6f48b59db35ccd1e9ff9adfc ]

GCC 10 changed the default to -fno-common, which leads to

    LD      arch/x86/boot/compressed/vmlinux
  ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order'; \
    arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
  make[2]: *** [arch/x86/boot/compressed/Makefile:119: arch/x86/boot/compressed/vmlinux] Error 1

Since __force_order is already provided in pgtable_64.c, there is no
need to declare __force_order in kaslr_64.c.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200124181811.4780-1-hjl.tools@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/pagetable.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
index e691ff734cb5a..46573842d8c3e 100644
--- a/arch/x86/boot/compressed/pagetable.c
+++ b/arch/x86/boot/compressed/pagetable.c
@@ -36,9 +36,6 @@
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
-/* Used by pgtable.h asm code to force instruction serialization. */
-unsigned long __force_order;
-
 /* Used to track our page table allocation area. */
 struct alloc_pgt_data {
 	unsigned char *pgt_buf;
-- 
2.20.1

