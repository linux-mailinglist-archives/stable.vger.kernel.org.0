Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A939585E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhEaJrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhEaJra (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 05:47:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 143EB6023C;
        Mon, 31 May 2021 09:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622454351;
        bh=MfFj2A1+plW7C8UGXf3GwEVFhMD2e02UkVEb+mKDLeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj+Q7Gg6C6ei6AznJpPJGiG3L5mspDxkEnNr1JBJX0NL8x6/k6MAuMAiBcrLkeaNV
         gcuh7ctErMOV/CNXUE8j0pPf3jqj7cmXS4QOIbGalo6AOfsQY8KDKSHrFQBAcyGQCC
         AqXuDwo9CZwZTIRWXTTsn/0MKgkMTpAT9oghOeYPLX2I8/2vPdNbhzrYe3MkecBE09
         LzpmeXazgYsZcvPnggTCZDj/jwk/yXP+X3AuocBSy4W+RlhvooQSzcbVA7SvVqJ0lp
         /Yi9eDcGxs+tXdpM4cJKeC4F5QDLkoL45tNB6U8F722+4Me98xURfpfn6vX4eufi9K
         RzZHGR120903A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lneUU-0003JN-B9; Mon, 31 May 2021 11:45:46 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eero Lehtinen <debiangamer2@gmail.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] media: gspca/sunplus: fix zero-length control requests
Date:   Mon, 31 May 2021 11:44:33 +0200
Message-Id: <20210531094434.12651-3-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531094434.12651-1-johan@kernel.org>
References: <20210531094434.12651-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/media/usb/gspca/sunplus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index ace3da40006e..971dee0a56da 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -242,6 +242,10 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
@@ -250,7 +254,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,		/* value */
 			index,
-			len ? gspca_dev->usb_buf : NULL, len,
+			gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
@@ -727,7 +731,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		case MegaImageVI:
 			reg_w_riv(gspca_dev, 0xf0, 0, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
-			reg_r(gspca_dev, 0xf0, 4, 0);
+			reg_w_riv(gspca_dev, 0xf0, 4, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
 			break;
 		default:
-- 
2.31.1

