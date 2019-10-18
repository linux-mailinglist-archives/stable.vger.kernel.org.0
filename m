Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA11DD449
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfJRWXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729360AbfJRWFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D591222D2;
        Fri, 18 Oct 2019 22:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436314;
        bh=jSBSivH/u/IsPoQL2DioWtRFhPnTgBDj9HejaCxueSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRzyBF5Wmntsl6/8c1O3oX7WCTZuXI004YrjcHQGNJuXcuo2qTX4sRIMRnuTUzk0U
         2vdrtFo/uiLqWpEI1U6K6sMGMUOQQW5LqJMZcfDeg2WpcoAg/BxHmdQcb16rlZ+Y5K
         II1W2J9IwDBAmgC+ogS3b0m2+UePuNQlcr5uwguY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 83/89] USB: usb-skeleton: fix use-after-free after driver unbind
Date:   Fri, 18 Oct 2019 18:03:18 -0400
Message-Id: <20191018220324.8165-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]

The driver failed to stop its read URB on disconnect, something which
could lead to a use-after-free in the completion handler after driver
unbind in case the character device has been closed.

Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usb-skeleton.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index f101347e3ea35..a14dc5003a294 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -574,6 +574,7 @@ static void skel_disconnect(struct usb_interface *interface)
 	dev->interface = NULL;
 	mutex_unlock(&dev->io_mutex);
 
+	usb_kill_urb(dev->bulk_in_urb);
 	usb_kill_anchored_urbs(&dev->submitted);
 
 	/* decrement our usage count */
-- 
2.20.1

