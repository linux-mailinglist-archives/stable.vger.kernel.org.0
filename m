Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C339E60AA95
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiJXNfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiJXNeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:34:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977B02CE09;
        Mon, 24 Oct 2022 05:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A624B81147;
        Mon, 24 Oct 2022 12:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936ADC433C1;
        Mon, 24 Oct 2022 12:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613079;
        bh=9IwWBpBPAy1XPz+qmN4K1594agSedGaY6AGFztpHjGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiaERIhJoIIZem7Cw4OyLlbUIvsnYq/jMpJupzOGZXgjT2JTjVLEP79uZ9zRRO/41
         jBgDT+lTBE9la1CSlp/efoImQJmvvNYEpp3uiYa1Ye+LrpcZW52kZfNYI8Veg1D9yv
         ONpiwFJFPAfJlF7xRkFu1bF6yuE62p4E7V0htJwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+79832d33eb89fb3cd092@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/229] usb: idmouse: fix an uninit-value in idmouse_open
Date:   Mon, 24 Oct 2022 13:32:18 +0200
Message-Id: <20221024113006.330019597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index bb24527f3c70..ba2b6fbab9b8 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -178,10 +178,6 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		bytes_read += bulk_read;
 	}
 
-	/* reset the device */
-reset:
-	ftip_command(dev, FTIP_RELEASE, 0, 0);
-
 	/* check for valid image */
 	/* right border should be black (0x00) */
 	for (bytes_read = sizeof(HEADER)-1 + WIDTH-1; bytes_read < IMGSIZE; bytes_read += WIDTH)
@@ -193,6 +189,10 @@ static int idmouse_create_image(struct usb_idmouse *dev)
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



