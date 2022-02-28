Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025474C72D3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiB1R3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiB1R2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:28:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3C117E3D;
        Mon, 28 Feb 2022 09:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84CA061362;
        Mon, 28 Feb 2022 17:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF1DC340E7;
        Mon, 28 Feb 2022 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069274;
        bh=/qxJZRIDq9NYVZooC34vVb1sF2Rt52/aik8Fo/ZPXsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aln1y1hLYDY2kxCVQtydNSLYWA8IVIaReYq4b4kERDqid1og3wRswdCgnWt4jjDol
         +xLdbIW6uJWbd0kRLBdAlsMTk45I9a8k1tHY37ApMoFrT2MQ0CM+qJCd9MzGUPHa6o
         975tjmfbGyChWkEzt5VJOuoD6g+K8+DpG18a9XgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongyu Xie <xiehongyu1@kylinos.cn>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 26/31] xhci: Prevent futile URB re-submissions due to incorrect return value.
Date:   Mon, 28 Feb 2022 18:24:22 +0100
Message-Id: <20220228172202.357336349@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
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
@@ -1397,9 +1397,12 @@ static int xhci_urb_enqueue(struct usb_h
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
@@ -3026,7 +3029,7 @@ static int xhci_check_streams_endpoint(s
 		return -EINVAL;
 	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
 	if (ret <= 0)
-		return -EINVAL;
+		return ret ? ret : -EINVAL;
 	if (usb_ss_max_streams(&ep->ss_ep_comp) == 0) {
 		xhci_warn(xhci, "WARN: SuperSpeed Endpoint Companion"
 				" descriptor for ep 0x%x does not support streams\n",


