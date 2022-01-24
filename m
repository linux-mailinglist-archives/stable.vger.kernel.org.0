Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72D49938F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385895AbiAXUen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383657AbiAXU1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F799C08254D;
        Mon, 24 Jan 2022 11:41:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FAF261551;
        Mon, 24 Jan 2022 19:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C37C340E5;
        Mon, 24 Jan 2022 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053306;
        bh=lDnMZdm1qIoBNi8zGpb9L19ogrWHp8r6Rf4WFn0gvus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kb4XDSzvDrg9iabil5PzGCxkFqC7UxkzNGEKZ3HqgV2AqNdqhuhUotTKhLKr3WUVK
         sQoh6e6PDfn3IMVKxJ21W0PNANn2h97V+OkiZiK1eg5qRCjXKUFMxyqMzeOc1IyY3G
         OOi9U2OWEztgYbItzuMmBJbnScZD4nCie1hcEjWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 022/563] media: em28xx: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:36:27 +0100
Message-Id: <20220124184025.187005090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -89,7 +89,7 @@ int em28xx_read_reg_req_len(struct em28x
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	if (ret < 0) {
 		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed with error %i\n",
 			      pipe,
@@ -158,7 +158,7 @@ int em28xx_write_regs_req(struct em28xx
 	memcpy(dev->urb_buf, buf, len);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
 	if (ret < 0) {


