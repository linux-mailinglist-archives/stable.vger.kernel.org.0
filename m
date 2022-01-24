Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ECC4995E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443552AbiAXU5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441926AbiAXUwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:52:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE7CFB8121C;
        Mon, 24 Jan 2022 20:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AE7C340E8;
        Mon, 24 Jan 2022 20:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057541;
        bh=MHmC5G+aOd3jIodOwStGtnsuWl6x1s8Ye8y6waVER78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPIQU1NQNbZYo0euk24REjy4JSTabrv6SzwAQ05SFOSNjfZeyorCMNxoZB3pErxfN
         KtTN83A/KHn9DRzzgMOkM8D7jPLrYsjR6YvSSQ1cOia1tgB3bJ7xyuZqIEaXhNMAkw
         VB/lHb1CiMUJpbT6P6gtlEbwgq4XupNVBLbjQebo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 846/846] lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test
Date:   Mon, 24 Jan 2022 19:46:03 +0100
Message-Id: <20220124184130.082412033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit e073e5ef90298d2d6e5e7f04b545a0815e92110c upstream.

Make do_kmem_cache_size_bulk() destroy the cache it creates.

Link: https://lkml.kernel.org/r/aced20a94bf04159a139f0846e41d38a1537debb.1640018297.git.andreyknvl@google.com
Fixes: 03a9349ac0e0 ("lib/test_meminit: add a kmem_cache_alloc_bulk() test")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_meminit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -337,6 +337,7 @@ static int __init do_kmem_cache_size_bul
 		if (num)
 			kmem_cache_free_bulk(c, num, objects);
 	}
+	kmem_cache_destroy(c);
 	*total_failures += fail;
 	return 1;
 }


