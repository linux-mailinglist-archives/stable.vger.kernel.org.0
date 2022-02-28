Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057594C7471
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiB1RpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbiB1Rnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41399A99B;
        Mon, 28 Feb 2022 09:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6681EB815BA;
        Mon, 28 Feb 2022 17:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC50C340F1;
        Mon, 28 Feb 2022 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069721;
        bh=/IPjo5Im5eTlmflgA6jvO3M2vFnLOiss2A90CD++VY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4Oh6kv0+APDqSjGsLv9WZwKjTZUlDyxC9DPhkctNJPIicWoz1N4GMtmk1zE6yzWM
         OxAIyaNU/NAoaKLLGgua+Cnz8kFcvb2HYk8v45l/Te5gMcuhcQcOmlHfrv0BqpWzJ9
         MPkl0EqNTLnlXwFmCUbCjaddiNEq4M6hJkq+7/1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 69/80] xhci: Prevent futile URB re-submissions due to incorrect return value.
Date:   Mon, 28 Feb 2022 18:24:50 +0100
Message-Id: <20220228172320.092444120@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit 243a1dd7ba48c120986dd9e66fee74bcb7751034 upstream.

The -ENODEV return value from xhci_check_args() is incorrectly changed
to -EINVAL in a couple places before propagated further.

xhci_check_args() returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
the return value of xhci_check_args <= 0.
This causes problems for example r8152_submit_rx, calling usb_submit_urb
in drivers/net/usb/r8152.c.
r8152_submit_rx will never get -ENODEV after submiting an urb when xHC
is halted because xhci_urb_enqueue returns -EINVAL in the very beginning.

[commit message and header edit -Mathias]

Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
Cc: stable@vger.kernel.org
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220215123320.1253947-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1487,9 +1487,12 @@ static int xhci_urb_enqueue(struct usb_h
 	struct urb_priv	*urb_priv;
 	int num_tds;
 
-	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
-					true, true, __func__) <= 0)
+	if (!urb)
 		return -EINVAL;
+	ret = xhci_check_args(hcd, urb->dev, urb->ep,
+					true, true, __func__);
+	if (ret <= 0)
+		return ret ? ret : -EINVAL;
 
 	slot_id = urb->dev->slot_id;
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
@@ -3289,7 +3292,7 @@ static int xhci_check_streams_endpoint(s
 		return -EINVAL;
 	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
 	if (ret <= 0)
-		return -EINVAL;
+		return ret ? ret : -EINVAL;
 	if (usb_ss_max_streams(&ep->ss_ep_comp) == 0) {
 		xhci_warn(xhci, "WARN: SuperSpeed Endpoint Companion"
 				" descriptor for ep 0x%x does not support streams\n",


