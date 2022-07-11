Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2456FBD2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiGKJfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiGKJen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A00F5F70;
        Mon, 11 Jul 2022 02:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD0AC6111F;
        Mon, 11 Jul 2022 09:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB261C34115;
        Mon, 11 Jul 2022 09:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531114;
        bh=6P8CXs3MGbhhmsH5Oe+Hzg9axBWkQxRbYazFIsEe6KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9p2zf+OCh9enCny0gxnrL2CzNC80s6/oc1KuVwIaLGgpWtjqC7v/9r7DbJ5vNYCH
         SFDJwbnF2bdVwRyC/NCT+K67T9batzCyu842DlojDoO7iisEsw17RN3XKARf/iFANK
         UcHFlud3oazRtFl+ts+HO24vX5zC7IkvrtnhBoFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        stable <stable@kernel.org>
Subject: [PATCH 5.18 101/112] misc: rtsx_usb: use separate command and response buffers
Date:   Mon, 11 Jul 2022 11:07:41 +0200
Message-Id: <20220711090552.437486205@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

commit 3776c78559853fd151be7c41e369fd076fb679d5 upstream.

rtsx_usb uses same buffer for command and response. There could
be a potential conflict using the same buffer for both especially
if retries and timeouts are involved.

Use separate command and response buffers to avoid conflicts.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/07e3721804ff07aaab9ef5b39a5691d0718b9ade.1656642167.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |   26 +++++++++++++++++---------
 include/linux/rtsx_usb.h           |    1 -
 2 files changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -631,15 +631,18 @@ static int rtsx_usb_probe(struct usb_int
 
 	ucr->pusb_dev = usb_dev;
 
-	ucr->iobuf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
-	if (!ucr->iobuf)
+	ucr->cmd_buf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
+	if (!ucr->cmd_buf)
 		return -ENOMEM;
 
+	ucr->rsp_buf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
+	if (!ucr->rsp_buf)
+		goto out_free_cmd_buf;
+
 	usb_set_intfdata(intf, ucr);
 
 	ucr->vendor_id = id->idVendor;
 	ucr->product_id = id->idProduct;
-	ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
 
 	mutex_init(&ucr->dev_mutex);
 
@@ -667,9 +670,11 @@ static int rtsx_usb_probe(struct usb_int
 
 out_init_fail:
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	kfree(ucr->iobuf);
-	ucr->iobuf = NULL;
-	ucr->cmd_buf = ucr->rsp_buf = NULL;
+	kfree(ucr->rsp_buf);
+	ucr->rsp_buf = NULL;
+out_free_cmd_buf:
+	kfree(ucr->cmd_buf);
+	ucr->cmd_buf = NULL;
 	return ret;
 }
 
@@ -682,9 +687,12 @@ static void rtsx_usb_disconnect(struct u
 	mfd_remove_devices(&intf->dev);
 
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	kfree(ucr->iobuf);
-	ucr->iobuf = NULL;
-	ucr->cmd_buf = ucr->rsp_buf = NULL;
+
+	kfree(ucr->cmd_buf);
+	ucr->cmd_buf = NULL;
+
+	kfree(ucr->rsp_buf);
+	ucr->rsp_buf = NULL;
 }
 
 #ifdef CONFIG_PM
--- a/include/linux/rtsx_usb.h
+++ b/include/linux/rtsx_usb.h
@@ -54,7 +54,6 @@ struct rtsx_ucr {
 	struct usb_device	*pusb_dev;
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
-	unsigned char		*iobuf;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;


