Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3952A582AA1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiG0QW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiG0QWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F49A31238;
        Wed, 27 Jul 2022 09:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDD5F617F2;
        Wed, 27 Jul 2022 16:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BB8C433D6;
        Wed, 27 Jul 2022 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938937;
        bh=W0lvLWRqYa1fiPWsJ4x6rwuPCznc0fHthtTnPYl25eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+IcPuRTzoL2N/qn4yPsjFaZQ5xic8erlMA9uXqPwT2xkWR8dfXooVYmFnjdVU04i
         fKCs2IZAs0nNpAiL0HgbSPFO8meLlLbxJ+BcBZTSUDZtQIMbWY4Nmf6E+ZgIfg5499
         uRpbSbIQkqBnJ9VR/rxPux8LeYMzaiadEdJn9co8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/26] misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
Date:   Wed, 27 Jul 2022 18:10:32 +0200
Message-Id: <20220727160959.266460602@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit eb7f8e28420372787933eec079735c35034bda7d ]

rtsx_usb driver allocates coherent dma buffer for urb transfers.
This buffer is passed to usb_bulk_msg() and usb core tries to
map already mapped buffer running into a dma mapping error.

xhci_hcd 0000:01:00.0: rejecting DMA map of vmalloc memory
WARNING: CPU: 1 PID: 279 at include/linux/dma-mapping.h:326 usb_ hcd_map_urb_for_dma+0x7d6/0x820

...

xhci_map_urb_for_dma+0x291/0x4e0
usb_hcd_submit_urb+0x199/0x12b0
...
usb_submit_urb+0x3b8/0x9e0
usb_start_wait_urb+0xe3/0x2d0
usb_bulk_msg+0x115/0x240
rtsx_usb_transfer_data+0x185/0x1a8 [rtsx_usb]
rtsx_usb_send_cmd+0xbb/0x123 [rtsx_usb]
rtsx_usb_write_register+0x12c/0x143 [rtsx_usb]
rtsx_usb_probe+0x226/0x4b2 [rtsx_usb]

Fix it to use kmalloc() to get DMA-able memory region instead.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/667d627d502e1ba9ff4f9b94966df3299d2d3c0d.1656642167.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rtsx_usb.c       | 13 +++++++------
 include/linux/mfd/rtsx_usb.h |  1 -
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index e94f855eac15..b0ebd2299599 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -642,8 +642,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
 	ucr->pusb_dev = usb_dev;
 
-	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
-			GFP_KERNEL, &ucr->iobuf_dma);
+	ucr->iobuf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
 	if (!ucr->iobuf)
 		return -ENOMEM;
 
@@ -679,8 +678,9 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
 out_init_fail:
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+	kfree(ucr->iobuf);
+	ucr->iobuf = NULL;
+	ucr->cmd_buf = ucr->rsp_buf = NULL;
 	return ret;
 }
 
@@ -693,8 +693,9 @@ static void rtsx_usb_disconnect(struct usb_interface *intf)
 	mfd_remove_devices(&intf->dev);
 
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+	kfree(ucr->iobuf);
+	ucr->iobuf = NULL;
+	ucr->cmd_buf = ucr->rsp_buf = NULL;
 }
 
 #ifdef CONFIG_PM
diff --git a/include/linux/mfd/rtsx_usb.h b/include/linux/mfd/rtsx_usb.h
index c446e4fd6b5c..d3d231afb17c 100644
--- a/include/linux/mfd/rtsx_usb.h
+++ b/include/linux/mfd/rtsx_usb.h
@@ -66,7 +66,6 @@ struct rtsx_ucr {
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
 	unsigned char		*iobuf;
-	dma_addr_t		iobuf_dma;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;
-- 
2.35.1



