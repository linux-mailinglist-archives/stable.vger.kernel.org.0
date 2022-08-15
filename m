Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A954594CE0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbiHPAcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352429AbiHPAau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7213183E3E;
        Mon, 15 Aug 2022 13:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9425A611CE;
        Mon, 15 Aug 2022 20:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B0DC433D6;
        Mon, 15 Aug 2022 20:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595717;
        bh=XUCBoqy/uTSxKk8lyeaJp5h4JhLfQfFOGiNsDrAIbus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuIPAFANbi+0OOJDACH6aLT60uECPW4G+Nog4OQXWyTsTEMqZu1ULSL+lAl0M++aF
         SoD5KCX1wdUHfdxeQDj6Zj/gyiZIi/JL9CPv0+LTLtbHN+Y3nGs8ro+1sjt0jfbnMt
         jNJEaaUl7xAipWfZ/VBJNKbQIWvqhab/R6zyFo7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Andrey Strachuk <strochuk@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0852/1157] usb: cdns3: change place of priv_ep assignment in cdns3_gadget_ep_dequeue(), cdns3_gadget_ep_enable()
Date:   Mon, 15 Aug 2022 20:03:28 +0200
Message-Id: <20220815180513.573739042@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 drivers/usb/cdns3/cdns3-gadget.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index f5f5fbbefec0..1f38ccd637d0 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2285,14 +2285,15 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
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
@@ -2600,7 +2601,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 			    struct usb_request *request)
 {
 	struct cdns3_endpoint *priv_ep = ep_to_cdns3_ep(ep);
-	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
+	struct cdns3_device *priv_dev;
 	struct usb_request *req, *req_temp;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *link_trb;
@@ -2611,6 +2612,8 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
 
+	priv_dev = priv_ep->cdns3_dev;
+
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	priv_req = to_cdns3_request(request);
-- 
2.35.1



