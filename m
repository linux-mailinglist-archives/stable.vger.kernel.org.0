Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BC95F294F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJCHRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiJCHQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F6543323;
        Mon,  3 Oct 2022 00:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48EE7B80E6A;
        Mon,  3 Oct 2022 07:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E0C433C1;
        Mon,  3 Oct 2022 07:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781227;
        bh=yYXATCN3SG+QiRAjqsQcAqt+qY8BdCFgjFsX71kkt60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pPv1DBixm+m0D5n7/GcAmdSKMo+qO9gFzVliHmwy5Dy9u4iLI03ZTG/u6Q6TDCzW
         aqbEuYbMBDbjVDyE9wMOcSlM0A1Ijy791+M7aNcYgZzZ1/r1uhlVxUffwQbVy9niPt
         +uqb//gqjAZp7PY6qUB5aqEj3XsviLYxt1Q+wfUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        =?UTF-8?q?=E9=9F=A9=E5=A4=A9=C3=A7`=C2=95?= <hantianshuo@iie.ac.cn>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 043/101] mm: fix madivse_pageout mishandling on non-LRU page
Date:   Mon,  3 Oct 2022 09:10:39 +0200
Message-Id: <20221003070725.536167230@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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
@@ -451,8 +451,11 @@ regular_page:
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


