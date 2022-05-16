Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11675291AA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347218AbiEPUGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348972AbiEPT7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72FB3F884;
        Mon, 16 May 2022 12:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3877C60A50;
        Mon, 16 May 2022 19:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2EFC385AA;
        Mon, 16 May 2022 19:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730788;
        bh=XClndHM4mSOpn/rg2RQmerQfwqK3Wvfp5PXXIXjpmio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGpx2SlTRm5ZsNBAqyGi9f80gAvL7WUbpJJR9G/dpdqFbBMoKI9vvxsYxmdwdnzzw
         aahKT/3/JhxYDHsDiq20KTdYZqa2IKUuXIPIKFouQMkeU15r/pht+muwiv2Y00yvI6
         jzktW6eFU0TnB5PscIAn1+cIf3UoidYtNvLud+Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 5.15 101/102] usb: gadget: uvc: rename function to be more consistent
Date:   Mon, 16 May 2022 21:37:15 +0200
Message-Id: <20220516193626.901310288@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>

commit e6bab2b66329b40462fb1bed6f98bc3fcf543a1c upstream.

When enabling info debugging for the uvc gadget, the bind and unbind
infos use different formats. Change the unbind to visually match the
bind.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20211017215017.18392-3-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -884,12 +884,13 @@ static void uvc_free(struct usb_function
 	kfree(uvc);
 }
 
-static void uvc_unbind(struct usb_configuration *c, struct usb_function *f)
+static void uvc_function_unbind(struct usb_configuration *c,
+				struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
 	struct uvc_device *uvc = to_uvc(f);
 
-	uvcg_info(f, "%s\n", __func__);
+	uvcg_info(f, "%s()\n", __func__);
 
 	device_remove_file(&uvc->vdev.dev, &dev_attr_function_name);
 	video_unregister_device(&uvc->vdev);
@@ -943,7 +944,7 @@ static struct usb_function *uvc_alloc(st
 	/* Register the function. */
 	uvc->func.name = "uvc";
 	uvc->func.bind = uvc_function_bind;
-	uvc->func.unbind = uvc_unbind;
+	uvc->func.unbind = uvc_function_unbind;
 	uvc->func.get_alt = uvc_function_get_alt;
 	uvc->func.set_alt = uvc_function_set_alt;
 	uvc->func.disable = uvc_function_disable;


