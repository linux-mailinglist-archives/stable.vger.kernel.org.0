Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC18651303
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiLST0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiLSTZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:25:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED05DB2
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7301DB80F97
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA24C433D2;
        Mon, 19 Dec 2022 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477944;
        bh=5ZDOjbYUGFtDrhJfNexYvt7IYoYLQn0v7tEJh8v3gi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFxtRXF69WyPUD24XxFbDXg/1Nx8uIeaYvRwsPXDUZFQq6Bwu7JSRq2orCfrXfIIw
         dQ4Aoett3ZxNzUdZ9xTXA7jaPKLShLnCOT3RebukiFPQ3L67YYLrwd4B/CKryDBx/j
         rDJk+iRkBsrABDpj9obE0wcztKLrPFGaHxRsuPCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Szymon Heidrich <szymon.heidrich@gmail.com>
Subject: [PATCH 6.0 14/28] usb: gadget: uvc: Prevent buffer overflow in setup handler
Date:   Mon, 19 Dec 2022 20:23:01 +0100
Message-Id: <20221219182944.794460009@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

commit 4c92670b16727365699fe4b19ed32013bab2c107 upstream.

Setup function uvc_function_setup permits control transfer
requests with up to 64 bytes of payload (UVC_MAX_REQUEST_SIZE),
data stage handler for OUT transfer uses memcpy to copy req->actual
bytes to uvc_event->data.data array of size 60. This may result
in an overflow of 4 bytes.

Fixes: cdda479f15cd ("USB gadget: video class function driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20221206141301.51305-1-szymon.heidrich@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -216,8 +216,9 @@ uvc_function_ep0_complete(struct usb_ep
 
 		memset(&v4l2_event, 0, sizeof(v4l2_event));
 		v4l2_event.type = UVC_EVENT_DATA;
-		uvc_event->data.length = req->actual;
-		memcpy(&uvc_event->data.data, req->buf, req->actual);
+		uvc_event->data.length = min_t(unsigned int, req->actual,
+			sizeof(uvc_event->data.data));
+		memcpy(&uvc_event->data.data, req->buf, uvc_event->data.length);
 		v4l2_event_queue(&uvc->vdev, &v4l2_event);
 	}
 }


