Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D184E431375
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhJRJ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhJRJ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:29:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B181D6126A;
        Mon, 18 Oct 2021 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634549209;
        bh=pF9b1HGzjn+dD2HCPU/L8MNqnHbaNubtJhugSG6exLY=;
        h=Subject:To:Cc:From:Date:From;
        b=jL3+2tKPvfScMCbjfW5LgFE/b9fsnUw7hDguzPTEqtwUlEfqdMNOzK1DXkpX2jBU2
         YG9grpO1lCtSRWAIrM8ZqAVZD1P/NrXxmoev2zxFRYwS3A0bR0aMpPsF7BGiONkbML
         HcAgiis7+q1EjDbaBqAVObqKdsC3KfaloQSwj6IE=
Subject: FAILED: patch "[PATCH] staging: vc04_services: shut up out-of-range warning" failed to apply to 4.9-stable tree
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 11:26:46 +0200
Message-ID: <1634549206143144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

