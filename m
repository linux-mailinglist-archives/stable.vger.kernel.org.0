Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAB37CD23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhELQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243692AbhELQlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BECCB61987;
        Wed, 12 May 2021 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835550;
        bh=PyFGvfhk7xya12f2/RRkWnHF24kuyTZC0Bo5HEho3v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3/zfKj4Mr5p5MWN6ztJIXxi8W9ckYXfL94Ol9kcMfuq3wGsEzAF7j+Wr3SAe7o1o
         K+vyRT08NPDgrPPVNsNyNEaqksIu3xbzxeAARARM/Mnhz+a522WhG+AzjN2zlFP8ye
         kMsx8KjSXtNgRpgiIuAlHqgFpPcSYHzKs+picxhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 390/677] media: ipu3-cio2: Fix pixel-rate derived link frequency
Date:   Wed, 12 May 2021 16:47:16 +0200
Message-Id: <20210512144850.282971428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit a7de6eac6f6f73d48d97a6c93032107775f4593b ]

The driver uses v4l2_get_link_freq() helper to obtain the link frequency
using the LINK_FREQ but also the PIXEL_RATE control. The divisor for the
pixel rate derived link frequency was wrong, missing the bus uses double
data rate. Fix this.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: 4b6c129e87a3 ("media: ipu3-cio2: Use v4l2_get_link_freq helper")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
index 6e8c0c230e11..fecef85bd62e 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
@@ -302,7 +302,7 @@ static int cio2_csi2_calc_timing(struct cio2_device *cio2, struct cio2_queue *q,
 	if (!q->sensor)
 		return -ENODEV;
 
-	freq = v4l2_get_link_freq(q->sensor->ctrl_handler, bpp, lanes);
+	freq = v4l2_get_link_freq(q->sensor->ctrl_handler, bpp, lanes * 2);
 	if (freq < 0) {
 		dev_err(dev, "error %lld, invalid link_freq\n", freq);
 		return freq;
-- 
2.30.2



