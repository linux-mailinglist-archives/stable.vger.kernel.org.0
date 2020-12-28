Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF82E3EF2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505178AbgL1Oej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505182AbgL1Oei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:34:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40522063A;
        Mon, 28 Dec 2020 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166037;
        bh=ndQMN8q9lGQe5NGlIRy9i1XSVAaFtciJrsSFtAEzQLc=;
        h=Subject:To:From:Date:From;
        b=dxcHotWbB1AUPmUyFAgnX2KRMNTKd3fpPp7bRgdnsNNr40hR9rxWmkps1zltvFPSZ
         sACUDIKqylLD5lgEbgnKASKSVXb5CbHGJKx337fGiWDjM3j+9PNnVUfzeRaYcaIssz
         r6PLgvCivdg0+md3DdjepT3B7JhR+kZG6B3wAgVQ=
Subject: patch "staging: mt7621-dma: Fix a resource leak in an error handling path" added to staging-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:15:10 +0100
Message-ID: <1609164910202203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: mt7621-dma: Fix a resource leak in an error handling path

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d887d6104adeb94d1b926936ea21f07367f0ff9f Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 13 Dec 2020 16:35:13 +0100
Subject: staging: mt7621-dma: Fix a resource leak in an error handling path

If an error occurs after calling 'mtk_hsdma_init()', it must be undone by
a corresponding call to 'mtk_hsdma_uninit()' as already done in the
remove function.

Fixes: 0853c7a53eb3 ("staging: mt7621-dma: ralink: add rt2880 dma engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201213153513.138723-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-dma/mtk-hsdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-dma/mtk-hsdma.c b/drivers/staging/mt7621-dma/mtk-hsdma.c
index d241349214e7..bc4bb4374313 100644
--- a/drivers/staging/mt7621-dma/mtk-hsdma.c
+++ b/drivers/staging/mt7621-dma/mtk-hsdma.c
@@ -712,7 +712,7 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(dd);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register dma device\n");
-		return ret;
+		goto err_uninit_hsdma;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node,
@@ -728,6 +728,8 @@ static int mtk_hsdma_probe(struct platform_device *pdev)
 
 err_unregister:
 	dma_async_device_unregister(dd);
+err_uninit_hsdma:
+	mtk_hsdma_uninit(hsdma);
 	return ret;
 }
 
-- 
2.29.2


