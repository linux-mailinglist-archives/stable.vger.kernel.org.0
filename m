Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EABB304B74
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbhAZEp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbhAYSnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59721221E7;
        Mon, 25 Jan 2021 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600147;
        bh=IvC8Y5xINbI2xrQg1uy9+MeeYbIZw42VCzYgpTN/ilA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hElHLJuyo8MXE6ilLddW64ZLhraYu23E0Jy1Eo9pqsqK4kNGYITjIRSmgjynQMJ4+
         ov9yzwuxpfGX9L+GA6LHQdTQ1AdP0HWujEvWlxOSXkXvslQomnjQrEo8Jv8ZQ91k2G
         /f+D4vwk2K8++QS5oZhA77JMzdaVtaCZmUo/Q6bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        YJ Chiang <yj.chiang@mediatek.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 49/58] kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
Date:   Mon, 25 Jan 2021 19:39:50 +0100
Message-Id: <20210125183158.814212724@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lecopzer Chen <lecopzer@gmail.com>

commit a11a496ee6e2ab6ed850233c96b94caf042af0b9 upstream.

During testing kasan_populate_early_shadow and kasan_remove_zero_shadow,
if the shadow start and end address in kasan_remove_zero_shadow() is not
aligned to PMD_SIZE, the remain unaligned PTE won't be removed.

In the test case for kasan_remove_zero_shadow():

    shadow_start: 0xffffffb802000000, shadow end: 0xffffffbfbe000000

    3-level page table:
      PUD_SIZE: 0x40000000 PMD_SIZE: 0x200000 PAGE_SIZE: 4K

0xffffffbf80000000 ~ 0xffffffbfbdf80000 will not be removed because in
kasan_remove_pud_table(), kasan_pmd_table(*pud) is true but the next
address is 0xffffffbfbdf80000 which is not aligned to PUD_SIZE.

In the correct condition, this should fallback to the next level
kasan_remove_pmd_table() but the condition flow always continue to skip
the unaligned part.

Fix by correcting the condition when next and addr are neither aligned.

Link: https://lkml.kernel.org/r/20210103135621.83129-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/kasan/kasan_init.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/kasan/kasan_init.c
+++ b/mm/kasan/kasan_init.c
@@ -372,9 +372,10 @@ static void kasan_remove_pmd_table(pmd_t
 
 		if (kasan_pte_table(*pmd)) {
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
-			    IS_ALIGNED(next, PMD_SIZE))
+			    IS_ALIGNED(next, PMD_SIZE)) {
 				pmd_clear(pmd);
-			continue;
+				continue;
+			}
 		}
 		pte = pte_offset_kernel(pmd, addr);
 		kasan_remove_pte_table(pte, addr, next);
@@ -397,9 +398,10 @@ static void kasan_remove_pud_table(pud_t
 
 		if (kasan_pmd_table(*pud)) {
 			if (IS_ALIGNED(addr, PUD_SIZE) &&
-			    IS_ALIGNED(next, PUD_SIZE))
+			    IS_ALIGNED(next, PUD_SIZE)) {
 				pud_clear(pud);
-			continue;
+				continue;
+			}
 		}
 		pmd = pmd_offset(pud, addr);
 		pmd_base = pmd_offset(pud, 0);
@@ -423,9 +425,10 @@ static void kasan_remove_p4d_table(p4d_t
 
 		if (kasan_pud_table(*p4d)) {
 			if (IS_ALIGNED(addr, P4D_SIZE) &&
-			    IS_ALIGNED(next, P4D_SIZE))
+			    IS_ALIGNED(next, P4D_SIZE)) {
 				p4d_clear(p4d);
-			continue;
+				continue;
+			}
 		}
 		pud = pud_offset(p4d, addr);
 		kasan_remove_pud_table(pud, addr, next);
@@ -457,9 +460,10 @@ void kasan_remove_zero_shadow(void *star
 
 		if (kasan_p4d_table(*pgd)) {
 			if (IS_ALIGNED(addr, PGDIR_SIZE) &&
-			    IS_ALIGNED(next, PGDIR_SIZE))
+			    IS_ALIGNED(next, PGDIR_SIZE)) {
 				pgd_clear(pgd);
-			continue;
+				continue;
+			}
 		}
 
 		p4d = p4d_offset(pgd, addr);


