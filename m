Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37684223A5
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhJEKh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 06:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233290AbhJEKh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 06:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C06D6124F;
        Tue,  5 Oct 2021 10:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633430138;
        bh=DwnqtOJ7C3yZ+MfIoe/KV5KQE2q7PDm1HwGbAXO52JA=;
        h=Subject:To:From:Date:From;
        b=rj20p3WwY7L2AQJFbAUWntoKkUZUAnXukNTfFawOrLPL+BeBB7WBBuM2f42b8wJ5H
         rAtgKpAXsvxGJAEXTQeoVf+B/JC8PdAMLU5JLqYt2P6Lu+1STNjrRHj3e8VrcjL4pS
         IZQQfK2cA3U+8RrYnWeDYiU0dPmOb81dxiC9cEr4=
Subject: patch "staging: vc04_services: shut up out-of-range warning" added to staging-linus
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 12:35:36 +0200
Message-ID: <1633430136100147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vc04_services: shut up out-of-range warning

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7ff4034e910fe00a90d985f0d05bacf60c162f02 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Sep 2021 13:36:56 +0200
Subject: staging: vc04_services: shut up out-of-range warning

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
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.33.0


