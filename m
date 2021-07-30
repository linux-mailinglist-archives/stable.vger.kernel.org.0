Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7179D3DB335
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhG3GIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:08:40 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:59006 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhG3GIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:08:40 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 16U68Gmg024433; Fri, 30 Jul 2021 15:08:16 +0900
X-Iguazu-Qid: 2wHHmJkRoP8u0Z9BjB
X-Iguazu-QSIG: v=2; s=0; t=1627625295; q=2wHHmJkRoP8u0Z9BjB; m=KAcQ6cN7E0C6VRjfWOGS8NriD/OdaACRBwU0viVVSII=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1112) id 16U68EmS005284
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 15:08:15 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 5A90710011C;
        Fri, 30 Jul 2021 15:08:14 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 16U68DLW029282;
        Fri, 30 Jul 2021 15:08:14 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 2/2 for 4.4, 4.9] ARM: ensure the signal page contains defined contents
Date:   Fri, 30 Jul 2021 15:08:05 +0900
X-TSB-HOP: ON
Message-Id: <20210730060805.342577-3-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 9c698bff66ab4914bb3d71da7dc6112519bde23e upstream.

Ensure that the signal page contains our poison instruction to increase
the protection against ROP attacks and also contains well defined
contents.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reference: CVE-2021-21781
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/arm/kernel/signal.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 0a066f03b5ec9b..180c1782ad63d9 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -625,18 +625,20 @@ struct page *get_signal_page(void)
 
 	addr = page_address(page);
 
+	/* Poison the entire page */
+	memset32(addr, __opcode_to_mem_arm(0xe7fddef1),
+		 PAGE_SIZE / sizeof(u32));
+
 	/* Give the signal return code some randomness */
 	offset = 0x200 + (get_random_int() & 0x7fc);
 	signal_return_offset = offset;
 
-	/*
-	 * Copy signal return handlers into the vector page, and
-	 * set sigreturn to be a pointer to these.
-	 */
+	/* Copy signal return handlers into the page */
 	memcpy(addr + offset, sigreturn_codes, sizeof(sigreturn_codes));
 
-	ptr = (unsigned long)addr + offset;
-	flush_icache_range(ptr, ptr + sizeof(sigreturn_codes));
+	/* Flush out all instructions in this page */
+	ptr = (unsigned long)addr;
+	flush_icache_range(ptr, ptr + PAGE_SIZE);
 
 	return page;
 }
-- 
2.32.0


