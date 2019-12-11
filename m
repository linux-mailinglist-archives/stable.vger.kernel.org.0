Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37EF11B5E3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfLKP5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbfLKPPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DD220663;
        Wed, 11 Dec 2019 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077313;
        bh=Xc0eyKlXnbwXsBZJnAPM3DHLQ9UKo918HSZqaDGVZZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x548kTV/OGwYiojk9CaQs36BgA13OQX7PACV+Bbn5yjWnDW8eykeEzupQZYcuHIPM
         CP7jYkBIGVOk2H6ieRnYJIwEitNkueMJZQ/yzWr4k5fWANIql5gSx1nz/Vc8vEZijC
         z2yQMF8/5Xr5RFvsWUTPr14uVSG0Y7c+xCwUDcC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.3 098/105] can: ucan: fix non-atomic allocation in completion handler
Date:   Wed, 11 Dec 2019 16:06:27 +0100
Message-Id: <20191211150303.001640688@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 870db5d1015c8bd63e93b579e857223c96249ff7 upstream.

USB completion handlers are called in atomic context and must
specifically not allocate memory using GFP_KERNEL.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable <stable@vger.kernel.org>     # 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Cc: Martin Elshuber <martin.elshuber@theobroma-systems.com>
Cc: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -792,7 +792,7 @@ resubmit:
 			  up);
 
 	usb_anchor_urb(urb, &up->rx_urbs);
-	ret = usb_submit_urb(urb, GFP_KERNEL);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
 		netdev_err(up->netdev,


