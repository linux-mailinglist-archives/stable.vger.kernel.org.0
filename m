Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7FC60A61C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiJXMbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiJXM3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF2A3334D;
        Mon, 24 Oct 2022 05:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B700EB81195;
        Mon, 24 Oct 2022 11:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3F2C433D6;
        Mon, 24 Oct 2022 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611925;
        bh=Mj21hyBrDjmSdd2jWfMhrCp60Lexb3CWLmw3cQrt69Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJUtFvGJwGS8BLBZUndiGOpb1Y1LF/b4v5yXFm7yN8gjvAA5SdgEX+qbtp0VGVczX
         +BShqVyllmwPuPKp+ya/u+vbTNfZagAtdHOOpeJ8or+OhRfibzAZVqdV9NwuQ1vIxg
         92H5jydW5wHEBTuqikJJvsqcqy6sV12TlXQ+1tmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+79832d33eb89fb3cd092@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 152/159] usb: idmouse: fix an uninit-value in idmouse_open
Date:   Mon, 24 Oct 2022 13:31:46 +0200
Message-Id: <20221024112954.968123565@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
index 9cf8a9b16336..51f5cee880b2 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -183,10 +183,6 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		bytes_read += bulk_read;
 	}
 
-	/* reset the device */
-reset:
-	ftip_command(dev, FTIP_RELEASE, 0, 0);
-
 	/* check for valid image */
 	/* right border should be black (0x00) */
 	for (bytes_read = sizeof(HEADER)-1 + WIDTH-1; bytes_read < IMGSIZE; bytes_read += WIDTH)
@@ -198,6 +194,10 @@ static int idmouse_create_image(struct usb_idmouse *dev)
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



