Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085C555D1EB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiF0L1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiF0L0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:26:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E6665BE;
        Mon, 27 Jun 2022 04:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3021061460;
        Mon, 27 Jun 2022 11:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40315C3411D;
        Mon, 27 Jun 2022 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329163;
        bh=MyDSI5RUebNDIc5u5vx4kaFMCJtuhYAwDkFKp5L7JuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5JJdAIE7YA8JUFj/zsMsk1gpGN/i74G6uMLF0GUEkTxE4WpPmfzy16V4jA7+LV7f
         35p7/aJK62ClvScaqqXfOlJrewNm6PTX4ZQsUByLGs6pZLmh0XNJqBsd5zAvlh2Cp1
         InM4Pognj6urpRgvlZkPmpUNRPg5gMMSO0NU8+k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 070/102] USB: gadget: Fix double-free bug in raw_gadget driver
Date:   Mon, 27 Jun 2022 13:21:21 +0200
Message-Id: <20220627111935.546709684@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 90bc2af24638659da56397ff835f3c95a948f991 upstream.

Re-reading a recently merged fix to the raw_gadget driver showed that
it inadvertently introduced a double-free bug in a failure pathway.
If raw_ioctl_init() encounters an error after the driver ID number has
been allocated, it deallocates the ID number before returning.  But
when dev_free() runs later on, it will then try to deallocate the ID
number a second time.

Closely related to this issue is another error in the recent fix: The
ID number is stored in the raw_dev structure before the code checks to
see whether the structure has already been initialized, in which case
the new ID number would overwrite the earlier value.

The solution to both bugs is to keep the new ID number in a local
variable, and store it in the raw_dev structure only after the check
for prior initialization.  No errors can occur after that point, so
the double-free will never happen.

Fixes: f2d8c2606825 ("usb: gadget: Fix non-unique driver names in raw-gadget driver")
CC: Andrey Konovalov <andreyknvl@gmail.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YrMrRw5AyIZghN0v@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -429,6 +429,7 @@ out_put:
 static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 {
 	int ret = 0;
+	int driver_id_number;
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
@@ -451,10 +452,9 @@ static int raw_ioctl_init(struct raw_dev
 		return -EINVAL;
 	}
 
-	ret = ida_alloc(&driver_id_numbers, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-	dev->driver_id_number = ret;
+	driver_id_number = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (driver_id_number < 0)
+		return driver_id_number;
 
 	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!driver_driver_name) {
@@ -462,7 +462,7 @@ static int raw_ioctl_init(struct raw_dev
 		goto out_free_driver_id_number;
 	}
 	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
-				DRIVER_NAME ".%d", dev->driver_id_number);
+				DRIVER_NAME ".%d", driver_id_number);
 
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_driver_name) {
@@ -506,6 +506,7 @@ static int raw_ioctl_init(struct raw_dev
 	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
+	dev->driver_id_number = driver_id_number;
 
 	dev->state = STATE_DEV_INITIALIZED;
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -520,7 +521,7 @@ out_free_udc_driver_name:
 out_free_driver_driver_name:
 	kfree(driver_driver_name);
 out_free_driver_id_number:
-	ida_free(&driver_id_numbers, dev->driver_id_number);
+	ida_free(&driver_id_numbers, driver_id_number);
 	return ret;
 }
 


