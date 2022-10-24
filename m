Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0F160BAF6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiJXUn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbiJXUnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:43:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DE8249893;
        Mon, 24 Oct 2022 11:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D0BECE16DB;
        Mon, 24 Oct 2022 12:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A156C433C1;
        Mon, 24 Oct 2022 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615801;
        bh=KtGQp74GjUm4fjBDfc/e1bqaUuqJ4KqtnZ46BIA9LVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hToBVyC+X6u9zICjx6DIHjcc6nxKvEY8D5FUV9W4jgg3TWRW5tUGZ1oOJDIj/Bn64
         P+s6atLQpgpzDKMRxn9nX5V7/VSWLorTVzJkdq48QGtGpDdGlCRWisCeQ/p2Ltlflf
         gJPWdBaoTfZDz96Avik7LRM0T3UikBO1P+l1gAf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/530] mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg
Date:   Mon, 24 Oct 2022 13:31:45 +0200
Message-Id: <20221024113101.392155581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 6b207ce8a96a71e966831e3a13c38143ba9a73c1 ]

dma_map_sg return 0 on error, fix the error check, and return -EIO
to caller.

Fixes: dbc049eee730 ("mailbox: Add driver for Broadcom FlexRM ring manager")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm-flexrm-mailbox.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index 78073ad1f2f1..b7e9fd53d47d 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -632,15 +632,15 @@ static int flexrm_spu_dma_map(struct device *dev, struct brcm_message *msg)
 
 	rc = dma_map_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			DMA_TO_DEVICE);
-	if (rc < 0)
-		return rc;
+	if (!rc)
+		return -EIO;
 
 	rc = dma_map_sg(dev, msg->spu.dst, sg_nents(msg->spu.dst),
 			DMA_FROM_DEVICE);
-	if (rc < 0) {
+	if (!rc) {
 		dma_unmap_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			     DMA_TO_DEVICE);
-		return rc;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.35.1



