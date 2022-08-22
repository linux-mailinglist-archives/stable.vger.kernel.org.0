Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D65B59C279
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiHVPRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 11:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiHVPQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 11:16:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE353F325;
        Mon, 22 Aug 2022 08:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0510B8124B;
        Mon, 22 Aug 2022 15:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEC0C433D6;
        Mon, 22 Aug 2022 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661181051;
        bh=WbAyQSmaawQTfpmVxmcSrbTLBpjQz/zly35Y6WG1Kv4=;
        h=From:To:Cc:Subject:Date:From;
        b=bVMQyKnZLl/mblXyo+ZQicGqHCJ3mIX7nZWoxSqHu1VXcsBiPw35kCynoS2PiJ/P/
         JIUgO19HXG1o4j81JA4YsuoOwIa3lmiYPl+fyE3o4HYt2Js7olg/tI0aSJk2uN0s1l
         XnRe48GZvZUZKCKlNPQkXrOKlM87s9ab4PeBJmlXmL89mwrRofTfhH9epc4KOtsugb
         g/+IzWe8hyRJ+u5ma8AnNc6ZrNJo+89L7uZEnG+1LO8QXHsvirbUmJ25eGvjrESvbH
         7WUpS95bTl5bMvD9g2HfBk0gyKbsVDtr2qfiviwOo+UUCqR07ynPhwetyOrod2wq1P
         2B160rmV3brPA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oQ94i-00072A-Fj; Mon, 22 Aug 2022 17:10:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Date:   Mon, 22 Aug 2022 17:10:27 +0200
Message-Id: <20220822151027.27026-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

It's been two months and two completely ignored reminders so resending.

Can someone please pick this fix up and let me know when that has been
done?

Johan


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

