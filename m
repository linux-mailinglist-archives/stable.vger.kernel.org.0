Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02822289A1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbfEWTko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390146AbfEWTU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20645217D9;
        Thu, 23 May 2019 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639255;
        bh=mbmgRkQiwuLf6DbY/gT5XIYsFmE75IZy8W8zEZ8AzcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8/QuhbfUjEN3xFo+w0+EqEx4WdSOaTvugtvpQT6QX8PIKvuh/jMUmT1GqZS7YuH9
         iWl0ckoQ7lPj/ZovPP2GjJCpDyrUkQbeZ38KZb4W+boZZOsTklVg7AxegxOEPjzgFe
         Sj1JEyMESuadIm0I0zAV11KQp207xTX5PamOWC4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>
Subject: [PATCH 5.0 019/139] mm/gup: Remove the write parameter from gup_fast_permitted()
Date:   Thu, 23 May 2019 21:05:07 +0200
Message-Id: <20190523181723.124661314@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

commit ad8cfb9c42ef83ecf4079bc7d77e6557648e952b upstream.

The 'write' parameter is unused in gup_fast_permitted() so remove it.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/20190210223424.13934-1-ira.weiny@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable_64.h |    3 +--
 mm/gup.c                          |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -259,8 +259,7 @@ extern void init_extra_mapping_uc(unsign
 extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
 
 #define gup_fast_permitted gup_fast_permitted
-static inline bool gup_fast_permitted(unsigned long start, int nr_pages,
-		int write)
+static inline bool gup_fast_permitted(unsigned long start, int nr_pages)
 {
 	unsigned long len, end;
 
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1811,7 +1811,7 @@ static void gup_pgd_range(unsigned long
  * Check if it's allowed to use __get_user_pages_fast() for the range, or
  * we need to fall back to the slow version:
  */
-bool gup_fast_permitted(unsigned long start, int nr_pages, int write)
+bool gup_fast_permitted(unsigned long start, int nr_pages)
 {
 	unsigned long len, end;
 
@@ -1853,7 +1853,7 @@ int __get_user_pages_fast(unsigned long
 	 * block IPIs that come from THPs splitting.
 	 */
 
-	if (gup_fast_permitted(start, nr_pages, write)) {
+	if (gup_fast_permitted(start, nr_pages)) {
 		local_irq_save(flags);
 		gup_pgd_range(start, end, write, pages, &nr);
 		local_irq_restore(flags);
@@ -1895,7 +1895,7 @@ int get_user_pages_fast(unsigned long st
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
-	if (gup_fast_permitted(start, nr_pages, write)) {
+	if (gup_fast_permitted(start, nr_pages)) {
 		local_irq_disable();
 		gup_pgd_range(addr, end, write, pages, &nr);
 		local_irq_enable();


