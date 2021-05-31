Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC95395B72
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhEaNUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhEaNTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C119761376;
        Mon, 31 May 2021 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467076;
        bh=pgZ2CMmgdSfi7hwcQaR3X6G3luSLViZGApZz7TBRRgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICtKRvxOYtc2DpmWcnKPy6zMKu1amgyoWU3WlSml/LW83hj5NYj9N1CfErPOoMrpI
         lSYWjwgX8Olw/WLeyQZHtnR5Bnp1qfTQdrvoP8z34pDapslcKFG1/+86pQFQ8CAMIb
         fVvxkq4TSEdflP8JevNQZlhMLA5kh7C8SrM9K0as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 14/54] USB: trancevibrator: fix control-request direction
Date:   Mon, 31 May 2021 15:13:40 +0200
Message-Id: <20210531130635.537159539@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 746e4acf87bcacf1406e05ef24a0b7139147c63e upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the set-speed request which erroneously used USB_DIR_IN and update
the default timeout argument to match (same value).

Fixes: 5638e4d92e77 ("USB: add PlayStation 2 Trance Vibrator driver")
Cc: stable@vger.kernel.org      # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210521133109.17396-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/trancevibrator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -74,9 +74,9 @@ static ssize_t set_speed(struct device *
 	/* Set speed */
 	retval = usb_control_msg(tv->udev, usb_sndctrlpipe(tv->udev, 0),
 				 0x01, /* vendor request: set speed */
-				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
+				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 				 tv->speed, /* speed value */
-				 0, NULL, 0, USB_CTRL_GET_TIMEOUT);
+				 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		tv->speed = old;
 		dev_dbg(&tv->udev->dev, "retval = %d\n", retval);


