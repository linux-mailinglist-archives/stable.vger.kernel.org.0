Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697C6457604
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhKSRn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237318AbhKSRn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C8060D42;
        Fri, 19 Nov 2021 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343624;
        bh=yrNzflCWHqUAkqWRo1XjvTJJqhniUTUuDvU59rLR8uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzWBtSo0+cLaXd29tCHspNmFMzbtz1fmjD3E+mvoz7lba7y+o9tb2tf/2NX8m0Hvt
         yQH8DccEGBTO7ZZstDuKcxFlAUvG776qTcQqXfAWFsqjt7qWUi64GG7YzWqjVzKHZi
         bXbREQEmFt+xoHV0A2G7OmyRFsPYVmran5zcR7eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 18/20] perf/core: Avoid put_page() when GUP fails
Date:   Fri, 19 Nov 2021 18:39:36 +0100
Message-Id: <20211119171445.245331723@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

commit 4716023a8f6a0f4a28047f14dd7ebdc319606b84 upstream.

PEBS PERF_SAMPLE_PHYS_ADDR events use perf_virt_to_phys() to convert PMU
sampled virtual addresses to physical using get_user_page_fast_only()
and page_to_phys().

Some get_user_page_fast_only() error cases return false, indicating no
page reference, but still initialize the output page pointer with an
unreferenced page. In these error cases perf_virt_to_phys() calls
put_page(). This causes page reference count underflow, which can lead
to unintentional page sharing.

Fix perf_virt_to_phys() to only put_page() if get_user_page_fast_only()
returns a referenced page.

Fixes: fc7ce9c74c3ad ("perf/core, x86: Add PERF_SAMPLE_PHYS_ADDR")
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211111021814.757086-1-gthelen@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7154,7 +7154,6 @@ void perf_output_sample(struct perf_outp
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -7173,14 +7172,15 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * If failed, leave phys_addr as 0.
 		 */
 		if (current->mm != NULL) {
+			struct page *p;
+
 			pagefault_disable();
-			if (get_user_page_fast_only(virt, 0, &p))
+			if (get_user_page_fast_only(virt, 0, &p)) {
 				phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
+				put_page(p);
+			}
 			pagefault_enable();
 		}
-
-		if (p)
-			put_page(p);
 	}
 
 	return phys_addr;


