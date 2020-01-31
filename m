Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02B114E8AA
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgAaGNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:52 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 101182082E;
        Fri, 31 Jan 2020 06:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451232;
        bh=fr9tDQ0xqorpoK5kYfukQYn0bNldKOrfILV8YE1G7NE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o3xTh24ajL13JHdSeHpbsiu3Kuz0QGPqqkeVguvVKQ+DCwiPXRkhkwAk5iVd8shX2
         oCxVnuMjsmsw0jhPusAOX0JCZDByuQ60ccP9Ao8Cpu8+VGZlD4L+UqCYDCs0tfVkfv
         cWLo+z0lc1THSrIAd6w1e+5nJa6Uld16L3uU21G0=
Date:   Thu, 30 Jan 2020 22:13:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com,
        gustavo@embeddedor.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 050/118] lib/test_kasan.c: fix memory leak in
 kmalloc_oob_krealloc_more()
Message-ID: <20200131061351.6LNl0SkTH%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
