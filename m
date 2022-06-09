Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3B0544E24
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243775AbiFINyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbiFINyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504E15D338;
        Thu,  9 Jun 2022 06:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D2061D1A;
        Thu,  9 Jun 2022 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F2C34114;
        Thu,  9 Jun 2022 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654782879;
        bh=1SGlG7uVS4l5HMwzT/iF1ArrEUNnHzSNr9UCtT1obes=;
        h=From:To:Cc:Subject:Date:From;
        b=RPGRfMsQZMxsihz/zDtg26P3+EICv184thpLmccZEYm9pdy0KfB+S0zi/bwimNDVM
         8/SasHupucNGRAb1U/OH1RRyWtsX3Vuw6I9FggPut05bNOymGstAdT8fuXPxwHxQUC
         WkOdBymM/zNGekg2aqmMdPrCGvZ4lV+uhatuHtBzB1h678HBRN1n092N3c7xBnFGUY
         Gaq0Tl0g5azbzv2HyV3Kpwontj6+Wg5r//Z5odYzw+HW5pIRKqw5LA0U+BVPDNCouo
         s3CLzm/1mo7jsUHQG07w9fYLlXkY2c/UcUV1ieKg3cVw5nDbBpsSlirH5hpnLC76Kl
         bk+CqmSIaexsA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nzIcN-0005CF-47; Thu, 09 Jun 2022 15:54:35 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] media: flexcop-usb: fix endpoint type check
Date:   Thu,  9 Jun 2022 15:53:41 +0200
Message-Id: <20220609135341.19941-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
type") tried to add an endpoint type sanity check for the single
isochronous endpoint but instead broke the driver by checking the wrong
descriptor or random data beyond the last endpoint descriptor.

Make sure to check the right endpoint descriptor.

Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
Cc: Oliver Neukum <oneukum@suse.com>
Cc: stable@vger.kernel.org	# 5.9
Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 7835bb0f32fc..e012b21c4fd7 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -511,7 +511,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
 		return -ENODEV;
-	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[1].desc))
+	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
 		return -ENODEV;
 
 	switch (fc_usb->udev->speed) {
-- 
2.35.1

