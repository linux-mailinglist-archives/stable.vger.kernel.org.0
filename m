Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2C169CDC7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjBTNwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjBTNwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CA51E5F7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1922160E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7ACC433D2;
        Mon, 20 Feb 2023 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901160;
        bh=vgy5oU3+h77YqTg1ayFV7Ea5Yo/Hwm4RhcAkVLx5vRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wB9SzDWUixUjdcFRZu6cBkRYmYYDX4Yp+RdILd0P+wIxJ1WM7zgBJO62SJFdprKaw
         Q5CFNFlaZwm+4WHxtyid/zTt/+pmWHzx1eShAVITVJtWnIDS6wQvIO2uD3EVM+vhkL
         asEjP3TasPfmLA7RqZ7GEafd8+pZaqdyFDbgCPZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaron Thompson <dev@aaront.org>,
        "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: [PATCH 5.15 52/83] Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."
Date:   Mon, 20 Feb 2023 14:36:25 +0100
Message-Id: <20230220133555.484897914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Thompson <dev@aaront.org>

commit 647037adcad00f2bab8828d3d41cd0553d41f3bd upstream.

This reverts commit 115d9d77bb0f9152c60b6e8646369fa7f6167593.

The pages being freed by memblock_free_late() have already been
initialized, but if they are in the deferred init range,
__free_one_page() might access nearby uninitialized pages when trying to
coalesce buddies. This can, for example, trigger this BUG:

  BUG: unable to handle page fault for address: ffffe964c02580c8
  RIP: 0010:__list_del_entry_valid+0x3f/0x70
   <TASK>
   __free_one_page+0x139/0x410
   __free_pages_ok+0x21d/0x450
   memblock_free_late+0x8c/0xb9
   efi_free_boot_services+0x16b/0x25c
   efi_enter_virtual_mode+0x403/0x446
   start_kernel+0x678/0x714
   secondary_startup_64_no_verify+0xd2/0xdb
   </TASK>

A proper fix will be more involved so revert this change for the time
being.

Fixes: 115d9d77bb0f ("mm: Always release pages to the buddy allocator in memblock_free_late().")
Signed-off-by: Aaron Thompson <dev@aaront.org>
Link: https://lore.kernel.org/r/20230207082151.1303-1-dev@aaront.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1615,13 +1615,7 @@ void __init __memblock_free_late(phys_ad
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		/*
-		 * Reserved pages are always initialized by the end of
-		 * memblock_free_all() (by memmap_init() and, if deferred
-		 * initialization is enabled, memmap_init_reserved_pages()), so
-		 * these pages can be released directly to the buddy allocator.
-		 */
-		__free_pages_core(pfn_to_page(cursor), 0);
+		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
 		totalram_pages_inc();
 	}
 }


