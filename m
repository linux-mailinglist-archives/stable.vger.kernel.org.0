Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5513DD78B
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhHBNqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhHBNqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10DB560555;
        Mon,  2 Aug 2021 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627911961;
        bh=TLuHBacfy6zJyeCibSLTST2gSrfB2psfKd7bI6DsLCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeMOrsrFm62Y0jJ7Ku/U+4tFMuvXzput08Dj6hGL0GxvfR+XOILIdqikftR2V4Hia
         SY010Wp65eTXv+0wneOl+gkleA/MbEyvQGbR2jahta1VIcPsihmVs7eI/iotx78kXE
         /oi+I1H7Chb+KGMhCe8q3xZ4LQo7bMqgT/dZXsIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 12/26] ARM: ensure the signal page contains defined contents
Date:   Mon,  2 Aug 2021 15:44:22 +0200
Message-Id: <20210802134332.437696492@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/signal.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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


