Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D832B4C6521
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 09:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiB1I7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 03:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiB1I7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 03:59:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5578E3D1C8
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 00:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B292ACE10FC
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 08:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0C4C340E7;
        Mon, 28 Feb 2022 08:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646038740;
        bh=iZFrXVSQfxBmZdvfdHTiBgEOnKfIHxcTJ9McyRUmVts=;
        h=Subject:To:Cc:From:Date:From;
        b=bUk2V/l1XIVhRtg25qw60mgmAsXCCP+sUvNppdMoLJAZAJc5+sX0j2VpvW5vAk/V8
         bNSyrC3lgPyRGHs3QRmdyqecK+E3anV9QQv1TsFKfjkK4hQJxUnR0kcaTLCIahp41m
         ZT/yena4y0gpDe24tPkqZnzpAr0bJJo0XOTBPvT0=
Subject: FAILED: patch "[PATCH] memblock: use kfree() to release kmalloced memblock regions" failed to apply to 5.10-stable tree
To:     linmiaohe@huawei.com, rppt@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 09:58:44 +0100
Message-ID: <164603872438252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c94afc46cae7ad41b2ad6a99368147879f4b0e56 Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 17 Feb 2022 22:53:27 +0800
Subject: [PATCH] memblock: use kfree() to release kmalloced memblock regions

memblock.{reserved,memory}.regions may be allocated using kmalloc() in
memblock_double_array(). Use kfree() to release these kmalloced regions
indicated by memblock_{reserved,memory}_in_slab.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 3010f876500f ("mm: discard memblock data later")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

diff --git a/mm/memblock.c b/mm/memblock.c
index 1018e50566f3..b12a364f2766 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -366,14 +366,20 @@ void __init memblock_discard(void)
 		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
-		memblock_free_late(addr, size);
+		if (memblock_reserved_in_slab)
+			kfree(memblock.reserved.regions);
+		else
+			memblock_free_late(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
-		memblock_free_late(addr, size);
+		if (memblock_memory_in_slab)
+			kfree(memblock.memory.regions);
+		else
+			memblock_free_late(addr, size);
 	}
 
 	memblock_memory = NULL;

