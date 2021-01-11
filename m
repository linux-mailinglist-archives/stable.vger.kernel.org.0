Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49192F14B9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbhAKN2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732339AbhAKNQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3CA22CE3;
        Mon, 11 Jan 2021 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370953;
        bh=k44yOELk82V0efnsAJV8ELPD8Sj4e/nJz2bKZ7w7u/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvTx0BzW4XywY7Ca8k2ulzE5qbv0Y6c4PLoTPmohW0s+12ShIEhcbW+uBSRBUQzmq
         grq0f0IVt+HrBy0Li35fxXWlFVBztmpTqIRPP7oJadFzZ/RApj0ImF+UJmIwdfuZ3j
         1dL1hr5cf+5gzw+qdwUA9eGXbWSPJL0ZDDUJ8clM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 5.10 077/145] staging: mt7621-dma: Fix a resource leak in an error handling path
Date:   Mon, 11 Jan 2021 14:01:41 +0100
Message-Id: <20210111130052.229076605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit d887d6104adeb94d1b926936ea21f07367f0ff9f upstream.

If an error occurs after calling 'mtk_hsdma_init()', it must be undone by
a corresponding call to 'mtk_hsdma_uninit()' as already done in the
remove function.

Fixes: 0853c7a53eb3 ("staging: mt7621-dma: ralink: add rt2880 dma engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201213153513.138723-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/mt7621-dma/mtk-hsdma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/mt7621-dma/mtk-hsdma.c
+++ b/drivers/staging/mt7621-dma/mtk-hsdma.c
@@ -712,7 +712,7 @@ static int mtk_hsdma_probe(struct platfo
 	ret = dma_async_device_register(dd);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register dma device\n");
-		return ret;
+		goto err_uninit_hsdma;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node,
@@ -728,6 +728,8 @@ static int mtk_hsdma_probe(struct platfo
 
 err_unregister:
 	dma_async_device_unregister(dd);
+err_uninit_hsdma:
+	mtk_hsdma_uninit(hsdma);
 	return ret;
 }
 


