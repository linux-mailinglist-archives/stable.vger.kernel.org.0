Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52E9176B24
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgCCCsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:48:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728527AbgCCCso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8598246D5;
        Tue,  3 Mar 2020 02:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203723;
        bh=wy9W+fQwofwFUAdAK7CWRsY2cm5mGzcAMji3HmIrySs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTltTELmIXG/BObiEvMTL6CZ6fVorX0lDOXbL88UMJly3TfoXjfl2MNubqKqBRCk1
         qE2A92JJJPXeWS7SVGXbqxbNCxLFzSOBrN11hPJpXTnT1/aEYCzpUygkSIo+1usqIR
         jI5rbOJZHUNHSiky32uh65oKMmLxGLiTdN17skuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Mo Qihui <qihui.mo@verisilicon.com>,
        Zhange Jian <zhang_jian5@dahuatech.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 52/58] csky/mm: Fixup export invalid_pte_table symbol
Date:   Mon,  2 Mar 2020 21:47:34 -0500
Message-Id: <20200303024740.9511-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 7f4a567332f035ab16b29010fbd04a0f10183c77 ]

There is no present bit in csky pmd hardware, so we need to prepare invalid_pte_table
for empty pmd entry and the functions (pmd_none & pmd_present) in pgtable.h need
invalid_pte_talbe to get result. If a module use these functions, we need export the
symbol for it.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Mo Qihui <qihui.mo@verisilicon.com>
Cc: Zhange Jian <zhang_jian5@dahuatech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/mm/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/csky/mm/init.c b/arch/csky/mm/init.c
index d4c2292ea46bc..00e96278b3776 100644
--- a/arch/csky/mm/init.c
+++ b/arch/csky/mm/init.c
@@ -31,6 +31,7 @@
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
+EXPORT_SYMBOL(invalid_pte_table);
 unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
 						__page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
-- 
2.20.1

