Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015F059A21B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352992AbiHSQcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353040AbiHSQa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2107611C94A;
        Fri, 19 Aug 2022 09:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3378B82804;
        Fri, 19 Aug 2022 16:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA08C433D6;
        Fri, 19 Aug 2022 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925081;
        bh=DFWKUL2x4OK1bnz/EwXH+qz3gUjVVbfy6M+QYMxk5NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbYMiuPe4NMAFYhavjwinHyqxvEnMFn4hRZ06ycyRDfExr6HTLWOie3hSrKpVaWfq
         zl+z52Io5OEHWvml2YXsybtHZIO+Ncdyngi8z67izb9iUzd6RmiZhGdiIc8pRBsvfv
         TGfBxsVrR0d+xQF0XP+65+7rX4dqbQflpHucV7JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Andrey Strachuk <strochuk@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/545] usb: cdns3: change place of priv_ep assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()
Date:   Fri, 19 Aug 2022 17:41:58 +0200
Message-Id: <20220819153844.956919472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Andrey Strachuk <strochuk@ispras.ru>

[ Upstream commit c3ffc9c4ca44bfe9562166793d133e1fb0630ea6 ]

If 'ep' is NULL, result of ep_to_cdns3_ep(ep) is invalid pointer
and its dereference with priv_ep->cdns3_dev may cause panic.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Andrey Strachuk <strochuk@ispras.ru>
Link: https://lore.kernel.org/r/20220718160052.4188-1-strochuk@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index d5056cc34974..c1b39a7acabc 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2294,14 +2294,15 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
 	int val;
 
 	priv_ep = ep_to_cdns3_ep(ep);
-	priv_dev = priv_ep->cdns3_dev;
-	comp_desc = priv_ep->endpoint.comp_desc;
 
 	if (!ep || !desc || desc->bDescriptorType != USB_DT_ENDPOINT) {
 		dev_dbg(priv_dev->dev, "usbss: invalid parameters\n");
 		return -EINVAL;
 	}
 
+	comp_desc = priv_ep->endpoint.comp_desc;
+	priv_dev = priv_ep->cdns3_dev;
+
 	if (!desc->wMaxPacketSize) {
 		dev_err(priv_dev->dev, "usbss: missing wMaxPacketSize\n");
 		return -EINVAL;
@@ -2609,7 +2610,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 			    struct usb_request *request)
 {
 	struct cdns3_endpoint *priv_ep = ep_to_cdns3_ep(ep);
-	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
+	struct cdns3_device *priv_dev;
 	struct usb_request *req, *req_temp;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *link_trb;
@@ -2620,6 +2621,8 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
 
+	priv_dev = priv_ep->cdns3_dev;
+
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	priv_req = to_cdns3_request(request);
-- 
2.35.1



