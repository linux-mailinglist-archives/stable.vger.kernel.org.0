Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0754B6280BA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiKNNIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiKNNIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3EC5FEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0E4CB80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4274C433D6;
        Mon, 14 Nov 2022 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431310;
        bh=qL8QyZBMdKYvqS3/ujRcEC/QUg20EACA3V2/uwAqNr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve66lLRsMcw1LwmO1YxVjmUFehvdjfyRSrS0tNHS3hunS5dXmJrdZWJ3h29bKnLIV
         So376PK2zEerGb+sHB6BIkdeXFw9OV+fxlGYWyXig6x20xnVs/4LmYfjqPVzAUpTnv
         QwWFmoO8EdPKJgk3tTOze0gFxtSFqJhjswMqhy2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Rosin <peda@axentia.se>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 179/190] dmaengine: at_hdmac: Protect atchan->status with the channel lock
Date:   Mon, 14 Nov 2022 13:46:43 +0100
Message-Id: <20221114124506.710170519@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 6e5ad28d16f082efeae3d0bd2e31f24bed218019 upstream.

Now that the complete callback call was removed from
device_terminate_all(), we can protect the atchan->status with the channel
lock. The atomic bitops on atchan->status do not substitute proper locking
on the status, as one could still modify the status after the lock was
dropped in atc_terminate_all() but before the atomic bitops were executed.

Fixes: 078a6506141a ("dmaengine: at_hdmac: Fix deadlocks")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-7-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1460,12 +1460,12 @@ static int atc_terminate_all(struct dma_
 	list_splice_tail_init(&atchan->queue, &atchan->free_list);
 	list_splice_tail_init(&atchan->active_list, &atchan->free_list);
 
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
 	clear_bit(ATC_IS_PAUSED, &atchan->status);
 	/* if channel dedicated to cyclic operations, free it */
 	clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	return 0;
 }
 


