Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451CF6AEB01
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjCGRjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjCGRir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1479B986
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 797F361518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4FCC4339B;
        Tue,  7 Mar 2023 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210500;
        bh=NH54hv3iwQNECLigkRrdI6BUWBil8AGko9bsK4/J+Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18il3eD150+12RChsnCVVF+l3NDv7fMStaE+L595R/WxYd9XQFnUekmTaRMaOoY0t
         dMUdIpAg0SyvqMiUV00C+DTo5GwE/yF9nAKvR5dsMmg5dc10X9JIS91H+/LHWY7A99
         95UWeaEcQwn1QjIYmHyb1TIMFgJPHfoGQK8yMxlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabian Vogt <fabian@ritter-vogt.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0531/1001] fotg210-udc: Add missing completion handler
Date:   Tue,  7 Mar 2023 17:55:03 +0100
Message-Id: <20230307170044.504857912@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit e55f67391fa986f7357edba0ca59e668d99c3a5f ]

This is used when responding to GET_STATUS requests. Without this, it
crashes on completion.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230123073508.2350402-2-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/fotg210/fotg210-udc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/fotg210/fotg210-udc.c b/drivers/usb/fotg210/fotg210-udc.c
index eb076746f0320..7ba7fb52ddaac 100644
--- a/drivers/usb/fotg210/fotg210-udc.c
+++ b/drivers/usb/fotg210/fotg210-udc.c
@@ -710,6 +710,20 @@ static int fotg210_is_epnstall(struct fotg210_ep *ep)
 	return value & INOUTEPMPSR_STL_EP ? 1 : 0;
 }
 
+/* For EP0 requests triggered by this driver (currently GET_STATUS response) */
+static void fotg210_ep0_complete(struct usb_ep *_ep, struct usb_request *req)
+{
+	struct fotg210_ep *ep;
+	struct fotg210_udc *fotg210;
+
+	ep = container_of(_ep, struct fotg210_ep, ep);
+	fotg210 = ep->fotg210;
+
+	if (req->status || req->actual != req->length) {
+		dev_warn(&fotg210->gadget.dev, "EP0 request failed: %d\n", req->status);
+	}
+}
+
 static void fotg210_get_status(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
@@ -1261,6 +1275,8 @@ int fotg210_udc_probe(struct platform_device *pdev)
 	if (fotg210->ep0_req == NULL)
 		goto err_map;
 
+	fotg210->ep0_req->complete = fotg210_ep0_complete;
+
 	fotg210_init(fotg210);
 
 	fotg210_disable_unplug(fotg210);
-- 
2.39.2



