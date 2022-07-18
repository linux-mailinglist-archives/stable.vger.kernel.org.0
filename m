Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CA75786A4
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiGRPqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiGRPqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:46:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3B818E03
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11661613FB
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 15:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6289C341C0;
        Mon, 18 Jul 2022 15:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658159177;
        bh=+mGpXX9MobppWZbJHXUYdlAX3DTCnZh/b7euHodG4AI=;
        h=Subject:To:Cc:From:Date:From;
        b=xyhRXnKjFtRVFiS2qHbM7zAcq1NNawx8Srf0lIrZy1+i3ldeCaizLGWfJ7eMDwFkN
         s98IzAktYeBbrxfHklJMLvjSG72C1BMbYI3Guv87WMuH/YC0hXXeznTr7ou9M8VQHE
         Ma/EQxqWu0/wYSWwABDKWvUG6Q84izbuWOSjtFnY=
Subject: FAILED: patch "[PATCH] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE" failed to apply to 5.4-stable tree
To:     demi@invisiblethingslab.com, jgross@suse.com,
        oleksandr_tyshchenko@epam.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 17:46:11 +0200
Message-ID: <165815917112998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 166d3863231667c4f64dee72b77d1102cdfad11f Mon Sep 17 00:00:00 2001
From: Demi Marie Obenour <demi@invisiblethingslab.com>
Date: Sun, 10 Jul 2022 19:05:22 -0400
Subject: [PATCH] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not INVALID_GRANT_HANDLE.  The handle field of any
page that was not successfully mapped will be INVALID_GRANT_HANDLE, so
this catches all cases where unmapping can legitimately fail.

Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
Cc: stable@vger.kernel.org
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220710230522.1563-1-demi@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d..84b143eef395 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,15 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset + i].status != GNTST_okay &&
+			map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
+				map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);

