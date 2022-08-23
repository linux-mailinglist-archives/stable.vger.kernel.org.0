Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8FA59E311
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358800AbiHWL5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359208AbiHWL4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:56:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CEFA2856;
        Tue, 23 Aug 2022 02:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD43B81C89;
        Tue, 23 Aug 2022 09:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50410C433D6;
        Tue, 23 Aug 2022 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247205;
        bh=SXrx+DlaLHzX4I2b5Q7/9xvnCK8Sl1fsEV9Ilr6BdHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKuFK7T17Z7lAtYP7+dHkWWh7bQl+E14hUEFOsp+7hSbyQ0l6/RANJuUQRXKiplSh
         HPuroHShlSI+WUYNJ+KHmbGCuExU2tf01wYwl46KEpsu8Od8X9aLVSRqZs/uBINBl9
         drQRAqzCOvC360isGEr4OX+YAaAZlRXDlgjmHI40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 351/389] usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info
Date:   Tue, 23 Aug 2022 10:27:09 +0200
Message-Id: <20220823080130.204809747@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit a725d0f6dfc5d3739d6499f30ec865305ba3544d ]

Likewise to the uvcvideo hostside driver, this patch is changing the
usb_request message of an non zero completion handler call from dev_info
to dev_warn.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220529223848.105914-4-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 5c042f380708..f9fad639a489 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -191,7 +191,7 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 		goto requeue;
 
 	default:
-		uvcg_info(&video->uvc->func,
+		uvcg_warn(&video->uvc->func,
 			  "VS request completed with status %d.\n",
 			  req->status);
 		uvcg_queue_cancel(queue, 0);
-- 
2.35.1



