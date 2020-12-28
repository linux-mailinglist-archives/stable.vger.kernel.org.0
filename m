Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094C2E3FEA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502994AbgL1OYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502985AbgL1OYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA95206D4;
        Mon, 28 Dec 2020 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165429;
        bh=eVpHb/0Ha3yjUHnrzVdsEZklN0TL3XpxRz27BA1gRzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YK/z1N46gtHbF3MIN0rIbb4ipHLNV1i0QMMV7Sea34dRpGKfvFBtTtUV+gmrrrxch
         e9H2S+4pF4ECMvkIs+Ikf0PtkGHK9XGRzUM2t7EukhK8yVwQZHJPmyQgcGeNhjJ8Fh
         KHDdjIL+mT+uM2iVZ5pqU6snxtRXSTeFIUNSedbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 528/717] media: ipu3-cio2: Make the field on subdev format V4L2_FIELD_NONE
Date:   Mon, 28 Dec 2020 13:48:46 +0100
Message-Id: <20201228125046.264417667@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -1286,6 +1286,7 @@ static int cio2_subdev_set_fmt(struct v4
 	fmt->format.width = min_t(u32, fmt->format.width, CIO2_IMAGE_MAX_WIDTH);
 	fmt->format.height = min_t(u32, fmt->format.height,
 				   CIO2_IMAGE_MAX_LENGTH);
+	fmt->format.field = V4L2_FIELD_NONE;
 
 	mutex_lock(&q->subdev_lock);
 	*mbus = fmt->format;


