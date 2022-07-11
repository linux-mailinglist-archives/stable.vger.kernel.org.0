Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E056FA0E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiGKJMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiGKJLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8348237CF;
        Mon, 11 Jul 2022 02:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCCC61148;
        Mon, 11 Jul 2022 09:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AEFC34115;
        Mon, 11 Jul 2022 09:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530549;
        bh=3yFvYkvFhSA5opWMSNYj1tkEXOgzdE7ISodinZieUPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEGYLpyN9Cq5XFrS2EznHJ8lM7qLX5NPaYZXWKzTSjcHLqbEwyoIxF/qdcvBCe8VJ
         dogWzL6F4murkZde5hhlFITRozUEbs85V8WeAiKDPWqI93jibPhB6XNhUr7oPZvX9k
         xYDHkfmDDWiP6Iz3NICTqGkB5BTorKcsqUwhSSFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 25/31] misc: rtsx_usb: use separate command and response buffers
Date:   Mon, 11 Jul 2022 11:07:04 +0200
Message-Id: <20220711090538.589749386@linuxfoundation.org>
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
@@ -642,15 +642,18 @@ static int rtsx_usb_probe(struct usb_int
 
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
 
@@ -678,9 +681,11 @@ static int rtsx_usb_probe(struct usb_int
 
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
 
@@ -693,9 +698,12 @@ static void rtsx_usb_disconnect(struct u
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
@@ -65,7 +65,6 @@ struct rtsx_ucr {
 	struct usb_device	*pusb_dev;
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
-	unsigned char		*iobuf;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;


