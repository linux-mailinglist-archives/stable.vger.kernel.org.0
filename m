Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C31F2C05E0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgKWMZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:25:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbgKWMZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4032B20728;
        Mon, 23 Nov 2020 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134306;
        bh=WeYy9fuvJ9LpbzTwBeMlFziLQMDzl1r1zC/bHgwzFEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUhmAGVpo9TffNz796GMCH0PVeUP1PintfAx/bGtRjNb5dX5HsJ3sYpGTnlJLUs6f
         cj5OOPTHy9k8elnZQVlBqnAtT9mtC0zgVSlVaX4mcitE++f3jBJOBQkM5Wfz86MNkI
         TA6LbqHZQER8RRPNLkK0+fn1FS31yobmBdpqhhJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 06/47] net: b44: fix error return code in b44_init_one()
Date:   Mon, 23 Nov 2020 13:21:52 +0100
Message-Id: <20201123121805.858893655@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
@@ -2390,7 +2390,8 @@ static int b44_init_one(struct ssb_devic
 		goto err_out_free_dev;
 	}
 
-	if (dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30))) {
+	err = dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30));
+	if (err) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system\n");
 		goto err_out_powerdown;


