Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2856D5F2AB1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiJCHjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiJCHih (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:38:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009D342AFC;
        Mon,  3 Oct 2022 00:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2FD960FA6;
        Mon,  3 Oct 2022 07:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6008C433C1;
        Mon,  3 Oct 2022 07:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781686;
        bh=yw7+OtI94m8hyHcJFdaLU/JamZCCm/vObY8mWVjErGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1dKgExOoer5bYO71hx40va/jMYeP8YlqRH87t0XtGMd7UwnVef+h/n/NMWqW/XEv
         JMPhbAYOQ/J1AhdcCjxQtb7ncXZAHItxFO6+MOMRj35dW9TcokwfDUOXhXXZoci0ZY
         zNJp9qrDH4bdOfT1/I1HGv+lAw5st9SHiPBhsPcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        =?UTF-8?q?=E9=9F=A9=E5=A4=A9=C3=A7`=C2=95?= <hantianshuo@iie.ac.cn>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 26/52] mm: fix madivse_pageout mishandling on non-LRU page
Date:   Mon,  3 Oct 2022 09:11:33 +0200
Message-Id: <20221003070719.508539234@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit 58d426a7ba92870d489686dfdb9d06b66815a2ab upstream.

MADV_PAGEOUT tries to isolate non-LRU pages and gets a warning from
isolate_lru_page below.

Fix it by checking PageLRU in advance.

------------[ cut here ]------------
trying to isolate tail page
WARNING: CPU: 0 PID: 6175 at mm/folio-compat.c:158 isolate_lru_page+0x130/0x140
Modules linked in:
CPU: 0 PID: 6175 Comm: syz-executor.0 Not tainted 5.18.12 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:isolate_lru_page+0x130/0x140

Link: https://lore.kernel.org/linux-mm/485f8c33.2471b.182d5726afb.Coremail.hantianshuo@iie.ac.cn/
Link: https://lkml.kernel.org/r/20220908151204.762596-1-minchan@kernel.org
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: 韩天ç` <hantianshuo@iie.ac.cn>
Suggested-by: Yang Shi <shy828301@gmail.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -434,8 +434,11 @@ regular_page:
 			continue;
 		}
 
-		/* Do not interfere with other mappings of this page */
-		if (page_mapcount(page) != 1)
+		/*
+		 * Do not interfere with other mappings of this page and
+		 * non-LRU page.
+		 */
+		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);


