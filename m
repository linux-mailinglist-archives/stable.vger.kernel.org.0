Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95885FCFE1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiJMAXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiJMAWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99278104D3F;
        Wed, 12 Oct 2022 17:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0636CB81CBD;
        Thu, 13 Oct 2022 00:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DF6C433C1;
        Thu, 13 Oct 2022 00:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620289;
        bh=2ZxUg/1wAsgJI7Aj9gDfm/S13ITpUsPEtiIhR3IIIoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+XSCEOgWzTfQmZ/usL4LHnz6sMHLQ45PLOY3i1rPKwLjWVtJlkQkGSQspyh5vSmd
         dUc89/m6tfljnaLrHqI1HhieQulPvahXBefNN89xG6Ki9FxR9kgb7/kID+VDUQ2Pj/
         ZnAQpKMegRsWkaBDsxUK6k5bS1tnIgbYUtTC7NCWgG0JVMns865KbMVPyw852ld9UC
         RJkc3TbQgCx9jMqLozVOyqoZMEGYMzhqg2na26tOV2F4mvnT/YnCcJlr8c8Y2QhX3+
         8WP0ytmdhQSiImXe5CswQF2DghVsGHIhQ2+BPQTf114RcMpLvl5fTEu7rQPaEOItPm
         jv5ANp1GArDQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+79832d33eb89fb3cd092@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 55/67] usb: idmouse: fix an uninit-value in idmouse_open
Date:   Wed, 12 Oct 2022 20:15:36 -0400
Message-Id: <20221013001554.1892206-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit bce2b0539933e485d22d6f6f076c0fcd6f185c4c ]

In idmouse_create_image, if any ftip_command fails, it will
go to the reset label. However, this leads to the data in
bulk_in_buffer[HEADER..IMGSIZE] uninitialized. And the check
for valid image incurs an uninitialized dereference.

Fix this by moving the check before reset label since this
check only be valid if the data after bulk_in_buffer[HEADER]
has concrete data.

Note that this is found by KMSAN, so only kernel compilation
is tested.

Reported-by: syzbot+79832d33eb89fb3cd092@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20220922134847.1101921-1-dzm91@hust.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/idmouse.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index e9437a176518..ea39243efee3 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -177,10 +177,6 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		bytes_read += bulk_read;
 	}
 
-	/* reset the device */
-reset:
-	ftip_command(dev, FTIP_RELEASE, 0, 0);
-
 	/* check for valid image */
 	/* right border should be black (0x00) */
 	for (bytes_read = sizeof(HEADER)-1 + WIDTH-1; bytes_read < IMGSIZE; bytes_read += WIDTH)
@@ -192,6 +188,10 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		if (dev->bulk_in_buffer[bytes_read] != 0xFF)
 			return -EAGAIN;
 
+	/* reset the device */
+reset:
+	ftip_command(dev, FTIP_RELEASE, 0, 0);
+
 	/* should be IMGSIZE == 65040 */
 	dev_dbg(&dev->interface->dev, "read %d bytes fingerprint data\n",
 		bytes_read);
-- 
2.35.1

