Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07E61475EC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgAXBNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729752AbgAXBNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:13:07 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B502087E;
        Fri, 24 Jan 2020 01:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828386;
        bh=JZiZj6CM0kY9lcelR5oriFf8LmulmZESGOYyueW9opE=;
        h=Date:From:To:Subject:From;
        b=qLGp3YaFz6HcXCGShcjGV29j+tWLTHP0f+RF//rA8cbH4p0MtRaw1NWZV7tZjJkGk
         tKNQpiUElfQjg5vV5SWQE5CrktFetrI+xvgsiGn9fGsvDkdFrReokMVWQnfbHIlEOo
         OEVCg/CZLPFAi6vMW9GlRsCr/xZpFHzc+bqQOT2c=
Date:   Thu, 23 Jan 2020 17:13:06 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, gustavo@embeddedor.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch added to
 -mm tree
Message-ID: <20200124011306.7Bu7OgvYd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
has been added to the -mm tree.  Its filename is
     lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

