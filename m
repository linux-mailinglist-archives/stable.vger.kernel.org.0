Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A9AE0F1
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392116AbfIIWSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406323AbfIIWRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:06 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E5521D79;
        Mon,  9 Sep 2019 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067425;
        bh=SD+/dPytZJTVINNwhSYESFDl7e+W+IhKtgomcj9nMj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvYhKFWS/2CAYw1F65A0jEayrUeC8/6KEol+azhi/a5K+0ldzNvOPukHGcZI/OS+b
         zWi+HYU8oOuCNSohsz+BpJOtK7HGPA65Occk3lphOx/3rtdRSdD8q59WUqORpGSQfC
         XW8ZNrXo/Mh0YHMiqm67sK10W6wTbyNUWDcH4hus=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Jong Hyun Park <park.jonghyun@yonsei.ac.kr>,
        Michael Kelley <mikelley@microsoft.com>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] x86/hyper-v: Fix overflow bug in fill_gva_list()
Date:   Mon,  9 Sep 2019 11:41:41 -0400
Message-Id: <20190909154145.31263-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154145.31263-1-sashal@kernel.org>
References: <20190909154145.31263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

[ Upstream commit 4030b4c585c41eeefec7bd20ce3d0e100a0f2e4d ]

When the 'start' parameter is >=  0xFF000000 on 32-bit
systems, or >= 0xFFFFFFFF'FF000000 on 64-bit systems,
fill_gva_list() gets into an infinite loop.

With such inputs, 'cur' overflows after adding HV_TLB_FLUSH_UNIT
and always compares as less than end.  Memory is filled with
guest virtual addresses until the system crashes.

Fix this by never incrementing 'cur' to be larger than 'end'.

Reported-by: Jong Hyun Park <park.jonghyun@yonsei.ac.kr>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 2ffd9e33ce4a ("x86/hyper-v: Use hypercall for remote TLB flush")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index 56c9ebac946fe..47718fff0b797 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -57,12 +57,14 @@ static inline int fill_gva_list(u64 gva_list[], int offset,
 		 * Lower 12 bits encode the number of additional
 		 * pages to flush (in addition to the 'cur' page).
 		 */
-		if (diff >= HV_TLB_FLUSH_UNIT)
+		if (diff >= HV_TLB_FLUSH_UNIT) {
 			gva_list[gva_n] |= ~PAGE_MASK;
-		else if (diff)
+			cur += HV_TLB_FLUSH_UNIT;
+		}  else if (diff) {
 			gva_list[gva_n] |= (diff - 1) >> PAGE_SHIFT;
+			cur = end;
+		}
 
-		cur += HV_TLB_FLUSH_UNIT;
 		gva_n++;
 
 	} while (cur < end);
-- 
2.20.1

