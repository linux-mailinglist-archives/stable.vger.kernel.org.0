Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B618472835
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhLMKI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241832AbhLMKFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:05:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982CC08E84A;
        Mon, 13 Dec 2021 01:50:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FEC5B80CAB;
        Mon, 13 Dec 2021 09:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F687C341C5;
        Mon, 13 Dec 2021 09:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389056;
        bh=H7Qak2Uu8GQGaaJfU4DC3QJww0IaBikf2/9RwFQyyQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+rjKmrPNLIgst9X/yVetx5DqwKEow0yVMhJr+OMrSWLLO1gzBt6iV5bgIeLI20Qm
         BjSXcg/svXj7CF80Ix7ujLV2hrouSnSDytitaT8faP6sQ3rMZlhGq2EIOMQVqOc1WG
         6x/S1yfr1zVcn+RghhupuDt93uZQd7WrHhkbIUZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 5.10 102/132] usb: core: config: fix validation of wMaxPacketValue entries
Date:   Mon, 13 Dec 2021 10:30:43 +0100
Message-Id: <20211213092942.596664677@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit 1a3910c80966e4a76b25ce812f6bea0ef1b1d530 upstream.

The checks performed by commit aed9d65ac327 ("USB: validate
wMaxPacketValue entries in endpoint descriptors") require that initial
value of the maxp variable contains both maximum packet size bits
(10..0) and multiple-transactions bits (12..11). However, the existing
code assings only the maximum packet size bits. This patch assigns all
bits of wMaxPacketSize to the variable.

Fixes: aed9d65ac327 ("USB: validate wMaxPacketValue entries in endpoint descriptors")
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20211210085219.16796-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -406,7 +406,7 @@ static int usb_parse_endpoint(struct dev
 	 * the USB-2 spec requires such endpoints to have wMaxPacketSize = 0
 	 * (see the end of section 5.6.3), so don't warn about them.
 	 */
-	maxp = usb_endpoint_maxp(&endpoint->desc);
+	maxp = le16_to_cpu(endpoint->desc.wMaxPacketSize);
 	if (maxp == 0 && !(usb_endpoint_xfer_isoc(d) && asnum == 0)) {
 		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has invalid wMaxPacketSize 0\n",
 		    cfgno, inum, asnum, d->bEndpointAddress);


