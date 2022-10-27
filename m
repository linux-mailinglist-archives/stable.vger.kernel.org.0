Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F39B60FE11
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiJ0RBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiJ0RBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9BC18C954
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC50623EB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73C2C433C1;
        Thu, 27 Oct 2022 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890104;
        bh=QAc7h+YKUtD1LN/63AHfgxO6AmP6rhRryHH76UHn17c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr8nxpxuf/JQiOExcmFlJqIn1f1qES8iOUF1CvziLdow/fa9Xc7hB3gAzTGyR0zBv
         jjkFqTfmagULlpMz55NJb6o9CQUikVAFd8etwldkrYBLOEnK+QlphA/HON+tgE88KY
         n48kHEXix10CHbSA+bgyTd3BEcjAToUaIwNrq3uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 04/79] usb: gadget: uvc: use on returned header len in video_encode_isoc_sg
Date:   Thu, 27 Oct 2022 18:55:02 +0200
Message-Id: <20221027165055.066967081@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit f262ce66d40cc6858d1fcb11e7b7f960448a4f38 upstream.

The function uvc_video_encode_header function returns the number of
bytes used for the header. We change the video_encode_isoc_sg function
to use the returned header_len rather than UVCG_REQUEST_HEADER_LEN and
make the encode function more flexible.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20211022093223.26493-1-m.grzeschik@pengutronix.de
Cc: Dan Vacura <w36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -104,22 +104,22 @@ uvc_video_encode_isoc_sg(struct usb_requ
 	unsigned int len = video->req_size;
 	unsigned int sg_left, part = 0;
 	unsigned int i;
-	int ret;
+	int header_len;
 
 	sg = ureq->sgt.sgl;
 	sg_init_table(sg, ureq->sgt.nents);
 
 	/* Init the header. */
-	ret = uvc_video_encode_header(video, buf, ureq->header,
+	header_len = uvc_video_encode_header(video, buf, ureq->header,
 				      video->req_size);
-	sg_set_buf(sg, ureq->header, UVCG_REQUEST_HEADER_LEN);
-	len -= ret;
+	sg_set_buf(sg, ureq->header, header_len);
+	len -= header_len;
 
 	if (pending <= len)
 		len = pending;
 
 	req->length = (len == pending) ?
-		len + UVCG_REQUEST_HEADER_LEN : video->req_size;
+		len + header_len : video->req_size;
 
 	/* Init the pending sgs with payload */
 	sg = sg_next(sg);
@@ -148,7 +148,7 @@ uvc_video_encode_isoc_sg(struct usb_requ
 	req->num_sgs = i + 1;
 
 	req->length -= len;
-	video->queue.buf_used += req->length - UVCG_REQUEST_HEADER_LEN;
+	video->queue.buf_used += req->length - header_len;
 
 	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
 		video->queue.buf_used = 0;


