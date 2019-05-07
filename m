Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82EF15BE6
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfEGF62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbfEGFhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBEC214AE;
        Tue,  7 May 2019 05:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207430;
        bh=FIxnxYUSeq0LwFRlBniKtK8bipW2JmLI0dZz7/OXqjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCHBMqod4CyJsKAv6r4YVuJ/FTYaV3IZUqq5R5Wwq9uMsn/5qz1lPId9UFnK6iCMP
         N724BNs+CUccnm8REbqbnrNq0eupIrjYVUSSYiuuZ1aq/vVNRNiISa02yqszsJ/gZs
         rA8TsuTOgKU3QFwb5rNAWxBTpXfIK54sI+amyAs0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@suse.de>,
        Thomas Garnier <thgarnie@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, frank.ramsay@hpe.com,
        herbert@gondor.apana.org.au, kirill@shutemov.name,
        mike.travis@hpe.com, x86-ml <x86@kernel.org>,
        yamada.masahiro@socionext.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 39/81] x86/mm/KASLR: Fix the size of the direct mapping section
Date:   Tue,  7 May 2019 01:35:10 -0400
Message-Id: <20190507053554.30848-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

[ Upstream commit ec3937107ab43f3e8b2bc9dad95710043c462ff7 ]

kernel_randomize_memory() uses __PHYSICAL_MASK_SHIFT to calculate
the maximum amount of system RAM supported. The size of the direct
mapping section is obtained from the smaller one of the below two
values:

  (actual system RAM size + padding size) vs (max system RAM size supported)

This calculation is wrong since commit

  b83ce5ee9147 ("x86/mm/64: Make __PHYSICAL_MASK_SHIFT always 52").

In it, __PHYSICAL_MASK_SHIFT was changed to be 52, regardless of whether
the kernel is using 4-level or 5-level page tables. Thus, it will always
use 4 PB as the maximum amount of system RAM, even in 4-level paging
mode where it should actually be 64 TB.

Thus, the size of the direct mapping section will always
be the sum of the actual system RAM size plus the padding size.

Even when the amount of system RAM is 64 TB, the following layout will
still be used. Obviously KALSR will be weakened significantly.

   |____|_______actual RAM_______|_padding_|______the rest_______|
   0            64TB                                            ~120TB

Instead, it should be like this:

   |____|_______actual RAM_______|_________the rest______________|
   0            64TB                                            ~120TB

The size of padding region is controlled by
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING, which is 10 TB by default.

The above issue only exists when
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING is set to a non-zero value,
which is the case when CONFIG_MEMORY_HOTPLUG is enabled. Otherwise,
using __PHYSICAL_MASK_SHIFT doesn't affect KASLR.

Fix it by replacing __PHYSICAL_MASK_SHIFT with MAX_PHYSMEM_BITS.

 [ bp: Massage commit message. ]

Fixes: b83ce5ee9147 ("x86/mm/64: Make __PHYSICAL_MASK_SHIFT always 52")
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Garnier <thgarnie@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: frank.ramsay@hpe.com
Cc: herbert@gondor.apana.org.au
Cc: kirill@shutemov.name
Cc: mike.travis@hpe.com
Cc: thgarnie@google.com
Cc: x86-ml <x86@kernel.org>
Cc: yamada.masahiro@socionext.com
Link: https://lkml.kernel.org/r/20190417083536.GE7065@MiWiFi-R3L-srv
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/kaslr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 61db77b0eda9..0988971069c9 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -93,7 +93,7 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_memory_enabled())
 		return;
 
-	kaslr_regions[0].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
+	kaslr_regions[0].size_tb = 1 << (MAX_PHYSMEM_BITS - TB_SHIFT);
 	kaslr_regions[1].size_tb = VMALLOC_SIZE_TB;
 
 	/*
-- 
2.20.1

