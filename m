Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4A4232D30
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgG3IHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729506AbgG3IHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC444206C0;
        Thu, 30 Jul 2020 08:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096464;
        bh=8je/VXTUbTj7wWw5DJkWCZC8gN/APZOy2RV5kYfjlFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6Powl9hDvJuEb74tVNG2E8tmR/z+VIalQ1Gy9zjFpeTXEO0R/S5IZJRql9iFEqiY
         xAxpI4FCfwwFapvQGsLHnSS1ZbBkM57KKyNzK93iJoF3XsNFIbBGFcZjDIbqVUD+71
         n+J814+njhoBLeaDeTFYW1LvrsgKgoYmqQFAwFnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oscar Salvador <osalvador@techadventures.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Ayush Mittal <ayush.m@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.14 12/14] mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages
Date:   Thu, 30 Jul 2020 10:04:55 +0200
Message-Id: <20200730074419.503737903@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074418.882736401@linuxfoundation.org>
References: <20200730074418.882736401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@techadventures.net>

commit 6bec6ad77fac3d29aed0d8e0b7526daedc964970 upstream.

When setting page_owner = on, the following warning can be seen in the
boot log:

  WARNING: CPU: 0 PID: 0 at mm/page_alloc.c:2537 drain_all_pages+0x171/0x1a0
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.15.0-rc7-next-20180109-1-default+ #7
  Hardware name: Dell Inc. Latitude E7470/0T6HHJ, BIOS 1.11.3 11/09/2016
  RIP: 0010:drain_all_pages+0x171/0x1a0
  Call Trace:
    init_page_owner+0x4e/0x260
    start_kernel+0x3e6/0x4a6
    ? set_init_arg+0x55/0x55
    secondary_startup_64+0xa5/0xb0
  Code: c5 ed ff 89 df 48 c7 c6 20 3b 71 82 e8 f9 4b 52 00 3b 05 d7 0b f8 00 89 c3 72 d5 5b 5d 41 5

This warning is shown because we are calling drain_all_pages() in
init_early_allocated_pages(), but mm_percpu_wq is not up yet, it is being
set up later on in kernel_init_freeable() -> init_mm_internals().

Link: http://lkml.kernel.org/r/20180109153921.GA13070@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ayush Mittal <ayush.m@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_owner.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -617,7 +617,6 @@ static void init_early_allocated_pages(v
 {
 	pg_data_t *pgdat;
 
-	drain_all_pages(NULL);
 	for_each_online_pgdat(pgdat)
 		init_zones_in_node(pgdat);
 }


