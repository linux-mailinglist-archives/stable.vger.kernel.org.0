Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC01D5096
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgEOOeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 10:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgEOOeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 10:34:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44FBC2076A;
        Fri, 15 May 2020 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589553239;
        bh=uDpqywmvJIYPg/eEk+BxYmug6ZkXbBwnQTMjQDruAnM=;
        h=Subject:To:From:Date:From;
        b=X7T3NPKwOFCbLU8+XRQULJmuSFi2zme8q8YFOTa4zY1PoM5hMGoU647EvfYkpb1Vy
         +MAJ5u9khRFDobXsmgshilEMjXCZIfMkWt4Vu8cxA6yxEJK/x90PleQR5WKYEVxdO8
         +IklV/xJ4C1NXS2JCtBJi12yuHscVekO4vcdGnaQ=
Subject: patch "ipack: tpci200: fix error return code in tpci200_register()" added to char-misc-linus
To:     weiyongjun1@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, siglesias@igalia.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 16:33:45 +0200
Message-ID: <158955322520465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ipack: tpci200: fix error return code in tpci200_register()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 133317479f0324f6faaf797c4f5f3e9b1b36ce35 Mon Sep 17 00:00:00 2001
From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Thu, 7 May 2020 09:42:37 +0000
Subject: ipack: tpci200: fix error return code in tpci200_register()

Fix to return negative error code -ENOMEM from the ioremap() error handling
case instead of 0, as done elsewhere in this function.

Fixes: 43986798fd50 ("ipack: add error handling for ioremap_nocache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Link: https://lore.kernel.org/r/20200507094237.13599-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/carriers/tpci200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 23445ebfda5c..ec71063fff76 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -306,6 +306,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to map driver user space!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
+		res = -ENOMEM;
 		goto out_release_mem8_space;
 	}
 
-- 
2.26.2


