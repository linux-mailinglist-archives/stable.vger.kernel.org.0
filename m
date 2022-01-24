Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D164988BD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiAXSuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbiAXSt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6B6B8121A;
        Mon, 24 Jan 2022 18:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D552DC340E8;
        Mon, 24 Jan 2022 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050167;
        bh=MH0E6NCxT8S0JirUSBlxUe9H0Emh2ArelTUEIROEmLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/qFVMPpL+T9rEI8FjSFew5b4iyA56JOFoDk56L7JCrfIBqqYB1odrWw/NB3LeCxq
         zMDhj0Zy2uxmWmYix5IcM2Usi486bk8k3B3z14Xk9Yi2hjbVxAJJdq44Ygg5/C43cl
         ZoNKitaYmWv8fv6q4AVRRUbrixkbRJdyZ6kbPCto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 014/114] media: em28xx: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:41:49 +0100
Message-Id: <20220124183927.552845234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d9b7e8df3aa9b8c10708aab60e72e79ac08237e4 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: a6c2ba283565 ("[PATCH] v4l: 716: support for em28xx board family")
Cc: stable@vger.kernel.org      # 2.6.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -99,7 +99,7 @@ int em28xx_read_reg_req_len(struct em28x
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(dev->udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	if (ret < 0) {
 		if (reg_debug)
 			printk(" failed!\n");
@@ -182,7 +182,7 @@ int em28xx_write_regs_req(struct em28xx
 	memcpy(dev->urb_buf, buf, len);
 	ret = usb_control_msg(dev->udev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
 	if (ret < 0)


