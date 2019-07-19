Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15A6DE45
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbfGSEGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732403AbfGSEGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC53721873;
        Fri, 19 Jul 2019 04:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509213;
        bh=CHUtUjcoZCmdIpRrpFG+/0VQUcEan2l3QkxxlFRqon0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwI8doY6BUeacgHioVlGSNw5ZLKGRjmfT3rwprqv11m70iCRU9N7Lb1kbkDMdfH7N
         EkqHrjrAF4Kicy+A9LxAMsrYrlyBaEq2aVceABwUFJyMuLoTzoXY9hQaFQGG2mqw68
         QRiTR54s/VuWMW2xIKkttJbRNM4mkBw4orDzXXak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.1 130/141] mm/gup.c: remove some BUG_ONs from get_gate_page()
Date:   Fri, 19 Jul 2019 00:02:35 -0400
Message-Id: <20190719040246.15945-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit b5d1c39f34d1c9bca0c4b9ae2e339fbbe264a9c7 ]

If we end up without a PGD or PUD entry backing the gate area, don't BUG
-- just fail gracefully.

It's not entirely implausible that this could happen some day on x86.  It
doesn't right now even with an execute-only emulated vsyscall page because
the fixmap shares the PUD, but the core mm code shouldn't rely on that
particular detail to avoid OOPSing.

Link: http://lkml.kernel.org/r/a1d9f4efb75b9d464e59fd6af00104b21c58f6f7.1561610798.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 60d759f4e4b5..de2e506d4aae 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -479,11 +479,14 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 		pgd = pgd_offset_k(address);
 	else
 		pgd = pgd_offset_gate(mm, address);
-	BUG_ON(pgd_none(*pgd));
+	if (pgd_none(*pgd))
+		return -EFAULT;
 	p4d = p4d_offset(pgd, address);
-	BUG_ON(p4d_none(*p4d));
+	if (p4d_none(*p4d))
+		return -EFAULT;
 	pud = pud_offset(p4d, address);
-	BUG_ON(pud_none(*pud));
+	if (pud_none(*pud))
+		return -EFAULT;
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return -EFAULT;
-- 
2.20.1

