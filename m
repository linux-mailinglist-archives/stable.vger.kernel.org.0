Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FED83CA7E1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhGOS4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241102AbhGOS4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60D49613D9;
        Thu, 15 Jul 2021 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375204;
        bh=g82bctk938ScfdJINpkIncGH+nIC5VosejmaIJZh80I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+POgEanI2wL4UUqtaUGb5GfXEN4gN6+IgplfD77LjI1l0u7j1MvgJhY1LQFPjVaw
         0qV/wc9W+7dLQDmTOgZ7wHZFknT9NIeMtmZQvnySS3lDT5PFEaiC1HGzHTo8R0v61N
         fJO53UKLrf++gbhQ7JbshD2VhgA57cnfxtXuTqcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 205/215] media: gspca/sunplus: fix zero-length control requests
Date:   Thu, 15 Jul 2021 20:39:37 +0200
Message-Id: <20210715182635.407274965@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b4bb4d425b7b02424afea2dfdcd77b3b4794175e upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

Fix the single zero-length control request which was using the
read-register helper, and update the helper so that zero-length reads
fail with an error message instead.

Fixes: 6a7eba24e4f0 ("V4L/DVB (8157): gspca: all subdrivers")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/sunplus.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -242,6 +242,10 @@ static void reg_r(struct gspca_dev *gspc
 		gspca_err(gspca_dev, "reg_r: buffer overflow\n");
 		return;
 	}
+	if (len == 0) {
+		gspca_err(gspca_dev, "reg_r: zero-length read\n");
+		return;
+	}
 	if (gspca_dev->usb_err < 0)
 		return;
 	ret = usb_control_msg(gspca_dev->dev,
@@ -250,7 +254,7 @@ static void reg_r(struct gspca_dev *gspc
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,		/* value */
 			index,
-			len ? gspca_dev->usb_buf : NULL, len,
+			gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
@@ -727,7 +731,7 @@ static int sd_start(struct gspca_dev *gs
 		case MegaImageVI:
 			reg_w_riv(gspca_dev, 0xf0, 0, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
-			reg_r(gspca_dev, 0xf0, 4, 0);
+			reg_w_riv(gspca_dev, 0xf0, 4, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
 			break;
 		default:


