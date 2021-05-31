Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2017395C9A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhEaNfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhEaNdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677B6613F0;
        Mon, 31 May 2021 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467462;
        bh=wLTcEg0Z9vVBFyBZ+RfAbUKqhMeJpZDMSjpBxZ40i/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iM6wzOQ6QfWJCXz0PEQha9491SJNo7nLDT9smu1/dCban0g9EOqlBYoN3mQ9mE1LX
         J97VVE4R5aigIwdUVqHtvNFweVUkfse9n6eTvGqZiPzRtm9Z2jqdadwzxrxx7NDUHS
         dZTwU0kwHayrU3JTAJCPIm3ORwQPmKY1+jpcKAVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 029/116] USB: trancevibrator: fix control-request direction
Date:   Mon, 31 May 2021 15:13:25 +0200
Message-Id: <20210531130641.153387826@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -59,9 +59,9 @@ static ssize_t speed_store(struct device
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


