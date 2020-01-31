Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC82714F52D
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 00:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAaXSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 18:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:24 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B59924688;
        Fri, 31 Jan 2020 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512703;
        bh=vGmd8A3xTHIq9oNFNfQUAolAWQcz8eNiZgGnCQNal90=;
        h=Date:From:To:Subject:From;
        b=sWthhF8Cbuzs/ZriDZlm2CEeCDF2K43Nk3fs7+a7zhMt8Px4Z3J5mkSKIIpVEFEkv
         WtSHIP4uXYoPIoHgOjEQ1+ji3hD7fn3cT3PTopG+8avdaAn2tsrZstnQSH+/+BYpvi
         +kV0AwHoF3Pq52gcf+2RiPwg9qzviZIO7Wqq0sEE=
Date:   Fri, 31 Jan 2020 15:18:23 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, gustavo@embeddedor.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch removed
 from -mm tree
Message-ID: <20200131231823.oEAlTU_hV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
has been removed from the -mm tree.  Its filename was
     lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

In case memory resources for _ptr2_ were allocated, release them before
return.

Notice that in case _ptr1_ happens to be NULL, krealloc() behaves exactly
like kmalloc().

Addresses-Coverity-ID: 1490594 ("Resource leak")
Link: http://lkml.kernel.org/r/20200123160115.GA4202@embeddedor
Fixes: 3f15801cdc23 ("lib: add kasan test module")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_kasan.c~lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more
+++ a/lib/test_kasan.c
@@ -158,6 +158,7 @@ static noinline void __init kmalloc_oob_
 	if (!ptr1 || !ptr2) {
 		pr_err("Allocation failed\n");
 		kfree(ptr1);
+		kfree(ptr2);
 		return;
 	}
 
_

Patches currently in -mm which might be from gustavo@embeddedor.com are


