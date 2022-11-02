Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC56158CA
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiKBC6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiKBC6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:58:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C96412617
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0FE617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EC9C433C1;
        Wed,  2 Nov 2022 02:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357918;
        bh=AE8yzqlp5M2NcaifG2895S8Nj52iptWOJtFT1PLVtMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGbKSKGltISt656E1A0V4V3gEXaX/+KajRhrKp8dDVubZafsPKjWdX8hOgETFkQey
         4FpsVANK/I8R/hqjI2F2E0ExyktLhYehGOk+d2Tgeu9N4y0tVZPSc/m2XzQ1eiIhyQ
         SauyFBUV3pQZ71MgQgk9+cpmYT+j+Y8I295/8gMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Vanhoof <qjv001@motorola.com>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 011/132] usb: gadget: uvc: fix sg handling during video encode
Date:   Wed,  2 Nov 2022 03:31:57 +0100
Message-Id: <20221102022059.920389149@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Vanhoof <qjv001@motorola.com>

commit b57b08e6f431348363adffa5b6643fe3ec9dc7fe upstream.

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
 drivers/usb/gadget/function/uvc_video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -128,10 +128,10 @@ uvc_video_encode_isoc_sg(struct usb_requ
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg || !sg_dma_len(buf->sg))
+		if (!len || !buf->sg || !buf->sg->length)
 			break;
 
-		sg_left = sg_dma_len(buf->sg) - buf->offset;
+		sg_left = buf->sg->length - buf->offset;
 		part = min_t(unsigned int, len, sg_left);
 
 		sg_set_page(iter, sg_page(buf->sg), part, buf->offset);


