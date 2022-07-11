Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64FD56FA46
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiGKJPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiGKJOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F92A414;
        Mon, 11 Jul 2022 02:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B896B80E5E;
        Mon, 11 Jul 2022 09:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967A4C34115;
        Mon, 11 Jul 2022 09:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530633;
        bh=dChCWsb+4khBPPsnfWD9LiN8uRlrpm1uvS/5ig3Xag0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdMtt6zrQZUWo6vieh+38fmd/fbGSELQ5CWWO6S5c1his4JO59urTa79/GSd/nPoi
         F+132Zeq5hZ8Rnbnfa80Q75AvRwo+kWkEB1hsBDXyySDnW4k7XfDFEmpId0NQCbZaZ
         +ETFWu0kdDlZD7gKyKUx6Qvr0oCyF+s5OWMwfod4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 06/38] usbnet: fix memory leak in error case
Date:   Mon, 11 Jul 2022 11:06:48 +0200
Message-Id: <20220711090538.916851659@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit b55a21b764c1e182014630fa5486d717484ac58f upstream.

usbnet_write_cmd_async() mixed up which buffers
need to be freed in which error case.

v2: add Fixes tag
v3: fix uninitialized buf pointer

Fixes: 877bd862f32b8 ("usbnet: introduce usbnet 3 command helpers")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220705125351.17309-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2120,7 +2120,7 @@ static void usbnet_async_cmd_cb(struct u
 int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 			   u16 value, u16 index, const void *data, u16 size)
 {
-	struct usb_ctrlrequest *req = NULL;
+	struct usb_ctrlrequest *req;
 	struct urb *urb;
 	int err = -ENOMEM;
 	void *buf = NULL;
@@ -2138,7 +2138,7 @@ int usbnet_write_cmd_async(struct usbnet
 		if (!buf) {
 			netdev_err(dev->net, "Error allocating buffer"
 				   " in %s!\n", __func__);
-			goto fail_free;
+			goto fail_free_urb;
 		}
 	}
 
@@ -2162,14 +2162,21 @@ int usbnet_write_cmd_async(struct usbnet
 	if (err < 0) {
 		netdev_err(dev->net, "Error submitting the control"
 			   " message: status=%d\n", err);
-		goto fail_free;
+		goto fail_free_all;
 	}
 	return 0;
 
+fail_free_all:
+	kfree(req);
 fail_free_buf:
 	kfree(buf);
-fail_free:
-	kfree(req);
+	/*
+	 * avoid a double free
+	 * needed because the flag can be set only
+	 * after filling the URB
+	 */
+	urb->transfer_flags = 0;
+fail_free_urb:
 	usb_free_urb(urb);
 fail:
 	return err;


