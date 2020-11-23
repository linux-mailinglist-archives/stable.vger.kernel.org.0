Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE082C057A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgKWMWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgKWMWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:22:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDF420888;
        Mon, 23 Nov 2020 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134169;
        bh=BP5ULJ9WWU7txYIAxbcNH4z4JHuzLtFR9L0zXZHmtWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sC23BbYvvBolkfUZp0oTehyESdwOdJbwRoyP+RVs0lRNw7rb+OEFcuccWpVKJ4Bn7
         jmRue5kk6FT/wQX+f+ZeV0T/QmOmOeCtZHyF3N3WpRXtcWgeVJauiNhzv41UXxB4eD
         Ti6DUg3BdXvKUDBZ37JT+wx4zTR3HJlqGNsFZGC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 03/38] net: b44: fix error return code in b44_init_one()
Date:   Mon, 23 Nov 2020 13:21:49 +0100
Message-Id: <20201123121804.481761527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 7b027c249da54f492699c43e26cba486cfd48035 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 39a6f4bce6b4 ("b44: replace the ssb_dma API with the generic DMA API")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1605582131-36735-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/b44.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2393,7 +2393,8 @@ static int b44_init_one(struct ssb_devic
 		goto err_out_free_dev;
 	}
 
-	if (dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30))) {
+	err = dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30));
+	if (err) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system\n");
 		goto err_out_powerdown;


