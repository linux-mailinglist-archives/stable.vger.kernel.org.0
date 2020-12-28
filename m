Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C42E436C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407045AbgL1Pdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407295AbgL1NxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B6622B37;
        Mon, 28 Dec 2020 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163560;
        bh=hi5aIWuUTk/lV2HCHbNEAoPGuYjf9GREJYAYDau+TLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnh4uReCNbgUMQAIb+B4ziKFwh3hBocHByvbwEm7Q7uvT/Ruf/OQ8aD2WcmLRkoti
         jcgR/lpQDdX2t+LDRyT2EKqTHL8uUsmaXWw860WAoPc25DELLF0yygdsVcCQFg2Us3
         fFke3z1chfvfpVfBcXO6t7eJQ2osVpiWwyet41hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 328/453] media: ipu3-cio2: Make the field on subdev format V4L2_FIELD_NONE
Date:   Mon, 28 Dec 2020 13:49:24 +0100
Message-Id: <20201228124952.996379688@linuxfoundation.org>
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

commit 219a8b9c04e54872f9a4d566633fb42f08bcbe2a upstream.

The ipu3-cio2 doesn't make use of the field and this is reflected in V4L2
buffers as well as the try format. Do this in active format, too.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1297,6 +1297,7 @@ static int cio2_subdev_set_fmt(struct v4
 	fmt->format.width = min_t(u32, fmt->format.width, CIO2_IMAGE_MAX_WIDTH);
 	fmt->format.height = min_t(u32, fmt->format.height,
 				   CIO2_IMAGE_MAX_LENGTH);
+	fmt->format.field = V4L2_FIELD_NONE;
 
 	mutex_lock(&q->subdev_lock);
 	*mbus = fmt->format;


