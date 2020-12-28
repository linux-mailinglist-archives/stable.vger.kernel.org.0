Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CEB2E436A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407057AbgL1Pdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407277AbgL1NxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83CBA2072C;
        Mon, 28 Dec 2020 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163552;
        bh=+CvkO08wiDcRQXFR4yilABAA2C9YPLcojWICzMjdGdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZZX8rtgp2lT7DNBt5A0APBLLRhzwYB0X90Q2ARtXsx+pEgyS2WYrRNLmVyoYXsbV
         MI/Sxhzm2HH1cGPaPQYRakexz3fWejcNfnedHj5LEEyClcQVC1nm1gnQuBkDhb/Uwo
         1Q6QRoSge/nHh1E43Zxc9L9cYaFMceH9u86r5CtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 325/453] media: ipu3-cio2: Return actual subdev format
Date:   Mon, 28 Dec 2020 13:49:21 +0100
Message-Id: <20201228124952.849449166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 8160e86702e0807bd36d40f82648f9f9820b9d5a upstream.

Return actual subdev format on ipu3-cio2 subdev pads. The earlier
implementation was based on an infinite recursion that exhausted the
stack.

Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1244,29 +1244,11 @@ static int cio2_subdev_get_fmt(struct v4
 			       struct v4l2_subdev_format *fmt)
 {
 	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
-	struct v4l2_subdev_format format;
-	int ret;
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
-		return 0;
-	}
-
-	if (fmt->pad == CIO2_PAD_SINK) {
-		format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL,
-				       &format);
-
-		if (ret)
-			return ret;
-		/* update colorspace etc */
-		q->subdev_fmt.colorspace = format.format.colorspace;
-		q->subdev_fmt.ycbcr_enc = format.format.ycbcr_enc;
-		q->subdev_fmt.quantization = format.format.quantization;
-		q->subdev_fmt.xfer_func = format.format.xfer_func;
-	}
-
-	fmt->format = q->subdev_fmt;
+	else
+		fmt->format = q->subdev_fmt;
 
 	return 0;
 }


