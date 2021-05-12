Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B8B37C921
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhELQPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhELQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D246961D23;
        Wed, 12 May 2021 15:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833935;
        bh=pe8+u171SzCXlCWdt2jXuTZZIToV50G34qRkXOQg/qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMoctMzYoptRj9gZ17Fmuxhgmkp1+uBVW9qRJ0R1d6dHgp08ykf1KgeMjRhSWuhmg
         50XFx3fR8DtdJ2EVCW/A8bjkgvA8VVMOYN0NFi4ynZJbufF0dy/lUWct3ZxNTkLlmj
         k1XUz2iageDjd5blZpN2kMrMfUr1nTOkWaVcZOLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 346/601] media: ipu3-cio2: Fix pixel-rate derived link frequency
Date:   Wed, 12 May 2021 16:47:03 +0200
Message-Id: <20210512144839.189351843@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 143ba9d90342..325c1483f42b 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
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



