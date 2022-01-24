Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551BB4997D8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352526AbiAXVQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377757AbiAXVMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83E1C02B778;
        Mon, 24 Jan 2022 12:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB19B8122A;
        Mon, 24 Jan 2022 20:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AEFC340E5;
        Mon, 24 Jan 2022 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054969;
        bh=MHmC5G+aOd3jIodOwStGtnsuWl6x1s8Ye8y6waVER78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCD6vIK2Eet5qPPwbEeM0MqCLkidvtXIoxgtQNpUPtP6DlBPXBzcvXlxbjv9g6qTV
         WjU4Xn3U9q6VhoYy+rFeyWpy3Kr1NSRT3JmT1MBD7OfspeC/QTVEKW/82AqLhxlq7I
         FfM9AjmnPPZjJbOiTwCwd5VQj7Mf4d5+kMzPPcwU=
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
Subject: [PATCH 5.10 561/563] lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test
Date:   Mon, 24 Jan 2022 19:45:26 +0100
Message-Id: <20220124184043.856005308@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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


