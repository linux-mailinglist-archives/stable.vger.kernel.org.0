Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A736A608C56
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJVLLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiJVLLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742AB2E89FE
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 03:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5923660BC8
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 10:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B8C433C1;
        Sat, 22 Oct 2022 10:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666434657;
        bh=eqCH35i+Fq9HibPQsfbv1aARhL+j2fE43pZwZv+TNXM=;
        h=Subject:To:From:Date:From;
        b=dL1i9xJ8OqnWbDLV+xaL9xay4KXvd2C8TN57PR5MXzpIyKhgFap2DtFgTSJf7FeuZ
         nQKqybSuyQAAuFV6nLyUA18rnU5ybXa3e32nOS+ryCOl0xyDdfTQnZ/ao5JSjxpjT3
         MkpwjHFFb66iVcXabjlFl4DIEv4W3vMKY9Mnhmxs=
Subject: patch "usb: gadget: uvc: fix sg handling during video encode" added to usb-linus
To:     qjv001@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, w36195@motorola.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Oct 2022 12:30:47 +0200
Message-ID: <166643464719032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: uvc: fix sg handling during video encode

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b57b08e6f431348363adffa5b6643fe3ec9dc7fe Mon Sep 17 00:00:00 2001
From: Jeff Vanhoof <qjv001@motorola.com>
Date: Tue, 18 Oct 2022 16:50:40 -0500
Subject: usb: gadget: uvc: fix sg handling during video encode

In uvc_video_encode_isoc_sg, the uvc_request's sg list is
incorrectly being populated leading to corrupt video being
received by the remote end. When building the sg list the
usage of buf->sg's 'dma_length' field is not correct and
instead its 'length' field should be used.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jeff Vanhoof <qjv001@motorola.com>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20221018215044.765044-5-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 5993e083819c..dd1c6b2ca7c6 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -157,10 +157,10 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg || !sg_dma_len(buf->sg))
+		if (!len || !buf->sg || !buf->sg->length)
 			break;
 
-		sg_left = sg_dma_len(buf->sg) - buf->offset;
+		sg_left = buf->sg->length - buf->offset;
 		part = min_t(unsigned int, len, sg_left);
 
 		sg_set_page(iter, sg_page(buf->sg), part, buf->offset);
-- 
2.38.1


