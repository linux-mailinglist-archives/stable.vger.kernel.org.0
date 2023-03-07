Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F8B6AF47E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbjCGTRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbjCGTQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1E5B860D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B3CE61518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E1EC4339B;
        Tue,  7 Mar 2023 18:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215595;
        bh=r7HxLKp8gB57cfM23srg7AcsEKM0tGfwTnQxZwk08FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdM5FDeCBVYExTYEOzw1iIOk7r80ZiPNh6bc49/wfjAqNH4KyUYNAmIvraIvhhhD9
         kqHVp5DpFgCeq+9KrbEH9oZ9FogBXC38KAMgMSPhySuoAur+ENssZMChwlDh7Wt7/O
         dHkLo/yV9+n4tdiVyXDG+AGiUD2cDngGWA6MjZCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabian Vogt <fabian@ritter-vogt.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/567] fotg210-udc: Add missing completion handler
Date:   Tue,  7 Mar 2023 18:00:48 +0100
Message-Id: <20230307165919.382683200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 drivers/usb/gadget/udc/fotg210-udc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index d0e051beb3af9..6f7ade156437a 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -706,6 +706,20 @@ static int fotg210_is_epnstall(struct fotg210_ep *ep)
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
@@ -1172,6 +1186,8 @@ static int fotg210_udc_probe(struct platform_device *pdev)
 	if (fotg210->ep0_req == NULL)
 		goto err_map;
 
+	fotg210->ep0_req->complete = fotg210_ep0_complete;
+
 	fotg210_init(fotg210);
 
 	fotg210_disable_unplug(fotg210);
-- 
2.39.2



