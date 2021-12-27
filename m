Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE047FC26
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhL0LVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhL0LVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:21:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD6CC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 03:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A26D60F85
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D6CC36AEB;
        Mon, 27 Dec 2021 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640604112;
        bh=17ghpA9/m0B1TEjYOSSZC6Zaa2gDcqKU2nx3gpgPYak=;
        h=Subject:To:Cc:From:Date:From;
        b=Gc8nkrppwE1qylrrawHiGuzfI5KnahbidrhhAWN6SUh4CnH9mMucGqoQh8Qaqji4l
         hkbNLjhozQfgb7OnansITOI/GBTFi5oE9YOd9FBHz1XYF8MObJA65uTV4Vycs3p1zM
         LA7OLS4uZIIGB/r9/ZSuJVPDSTuo6Bgt+gPnnIrg=
Subject: FAILED: patch "[PATCH] tee: optee: Fix incorrect page free bug" failed to apply to 5.4-stable tree
To:     sumit.garg@linaro.org, jens.wiklander@linaro.org,
        patrik.lantz@axis.com, tyhicks@linux.microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 12:21:50 +0100
Message-ID: <164060411065224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 18549bf4b21c739a9def39f27dcac53e27286ab5 Mon Sep 17 00:00:00 2001
From: Sumit Garg <sumit.garg@linaro.org>
Date: Thu, 16 Dec 2021 11:17:25 +0530
Subject: [PATCH] tee: optee: Fix incorrect page free bug

Pointer to the allocated pages (struct page *page) has already
progressed towards the end of allocation. It is incorrect to perform
__free_pages(page, order) using this pointer as we would free any
arbitrary pages. Fix this by stop modifying the page pointer.

Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
Cc: stable@vger.kernel.org
Reported-by: Patrik Lantz <patrik.lantz@axis.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index ab2edfcc6c70..2a66a5203d2f 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -48,10 +48,8 @@ int optee_pool_op_alloc_helper(struct tee_shm_pool_mgr *poolm,
 			goto err;
 		}
 
-		for (i = 0; i < nr_pages; i++) {
-			pages[i] = page;
-			page++;
-		}
+		for (i = 0; i < nr_pages; i++)
+			pages[i] = page + i;
 
 		shm->flags |= TEE_SHM_REGISTER;
 		rc = shm_register(shm->ctx, shm, pages, nr_pages,

