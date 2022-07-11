Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD256FA0D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiGKJM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiGKJLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:11:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1D313F8D;
        Mon, 11 Jul 2022 02:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C0CCB80E79;
        Mon, 11 Jul 2022 09:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE04C34115;
        Mon, 11 Jul 2022 09:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530547;
        bh=ZhQFFpqOzrp5tNcwgIlKbIO90e6rRqoCkAD4zr6R61A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPSqjJtZSIOWb+0ws2C69OEWKSvgM3sPVcXnhaYhxiP0nActrMbGInmQ0JIKjLH99
         z7Gq/fZKOzNMk9kWPUEjX/mbxc64moi8qtdmMiUVKbeE0jWuisy29q8pCSR2u9Ryxn
         Z8ktsERFS4n8SylmohL1KVWHHUFm0yKKGt0fdeI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 24/31] misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
Date:   Mon, 11 Jul 2022 11:07:03 +0200
Message-Id: <20220711090538.561194382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit eb7f8e28420372787933eec079735c35034bda7d upstream.

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
---
 drivers/misc/cardreader/rtsx_usb.c |   13 +++++++------
 include/linux/rtsx_usb.h           |    1 -
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -642,8 +642,7 @@ static int rtsx_usb_probe(struct usb_int
 
 	ucr->pusb_dev = usb_dev;
 
-	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
-			GFP_KERNEL, &ucr->iobuf_dma);
+	ucr->iobuf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
 	if (!ucr->iobuf)
 		return -ENOMEM;
 
@@ -679,8 +678,9 @@ static int rtsx_usb_probe(struct usb_int
 
 out_init_fail:
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+	kfree(ucr->iobuf);
+	ucr->iobuf = NULL;
+	ucr->cmd_buf = ucr->rsp_buf = NULL;
 	return ret;
 }
 
@@ -693,8 +693,9 @@ static void rtsx_usb_disconnect(struct u
 	mfd_remove_devices(&intf->dev);
 
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+	kfree(ucr->iobuf);
+	ucr->iobuf = NULL;
+	ucr->cmd_buf = ucr->rsp_buf = NULL;
 }
 
 #ifdef CONFIG_PM
--- a/include/linux/rtsx_usb.h
+++ b/include/linux/rtsx_usb.h
@@ -66,7 +66,6 @@ struct rtsx_ucr {
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
 	unsigned char		*iobuf;
-	dma_addr_t		iobuf_dma;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;


