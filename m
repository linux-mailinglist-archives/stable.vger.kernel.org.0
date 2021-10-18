Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9305D431378
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhJRJ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhJRJ3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9856D60FC3;
        Mon, 18 Oct 2021 09:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634549223;
        bh=GPGhSJ1LyFN05bL9mRkkIboysd8C+tOjfHTAyREeyNM=;
        h=Subject:To:Cc:From:Date:From;
        b=gL08Yxj2QgHgKCIqOPKzWqJFJ/RDW5VUimeM5411wJ0sVPO4ERYVFnfF8jFyepP1i
         Vlpdk8cGtgeVjyQcKuma8uzRTrmlT+MnMpsuyrFPZXzZJR7ipSmxUl+2nE8QZB/Du4
         fcDpP/x386t1Mwymhl38bWxSp2oU2nztXC7s1IXc=
Subject: FAILED: patch "[PATCH] staging: vc04_services: shut up out-of-range warning" failed to apply to 4.19-stable tree
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 11:26:47 +0200
Message-ID: <1634549207162105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ff4034e910fe00a90d985f0d05bacf60c162f02 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Sep 2021 13:36:56 +0200
Subject: [PATCH] staging: vc04_services: shut up out-of-range warning

The comparison against SIZE_MAX produces a harmless warning on 64-bit
architectures:

drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:185:16: error: result of comparison of constant 419244183493398898 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (num_pages > (SIZE_MAX - sizeof(struct pagelist) -
            ~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Shut up that warning by adding a cast to a longer type.

Fixes: ca641bae6da9 ("staging: vc04_services: prevent integer overflow in create_pagelist()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210927113702.3866843-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index b25369a13452..967f10b9582a 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -182,7 +182,7 @@ create_pagelist(char *buf, char __user *ubuf,
 		offset = (uintptr_t)ubuf & (PAGE_SIZE - 1);
 	num_pages = DIV_ROUND_UP(count + offset, PAGE_SIZE);
 
-	if (num_pages > (SIZE_MAX - sizeof(struct pagelist) -
+	if ((size_t)num_pages > (SIZE_MAX - sizeof(struct pagelist) -
 			 sizeof(struct vchiq_pagelist_info)) /
 			(sizeof(u32) + sizeof(pages[0]) +
 			 sizeof(struct scatterlist)))

