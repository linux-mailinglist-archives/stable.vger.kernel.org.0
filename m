Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5B239CF7
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 01:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHBX2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Aug 2020 19:28:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:7963 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgHBX2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Aug 2020 19:28:13 -0400
IronPort-SDR: OuMQsCLubhmGu+wWT3bZIdA3BTzSp6XtzUpgI0hvqZ2zMrDToAP+vJQs/FmVyLUIZluXrN4z1p
 dPTtMjs6QVoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9701"; a="139979729"
X-IronPort-AV: E=Sophos;i="5.75,428,1589266800"; 
   d="scan'208";a="139979729"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2020 16:28:12 -0700
IronPort-SDR: YArqj2r6TsK68EyZcgFirnswYf/9TaBEBQOGQTx92NhjLYvYoXJQ40t6BmustXKC+3ghxS5hoo
 EAqfwWsyl1Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,428,1589266800"; 
   d="scan'208";a="273763970"
Received: from orsosgc001.ra.intel.com ([10.23.184.150])
  by fmsmga007.fm.intel.com with ESMTP; 02 Aug 2020 16:28:12 -0700
From:   Ashutosh Dixit <ashutosh.dixit@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mst@redhat.com,
        sudeep.dutt@intel.com, arnd@arndb.de, vincent.whitchurch@axis.com,
        stable@vger.kernel.org
Subject: [PATCH] vop: Add missing __iomem annotation in vop_dc_to_vdev()
Date:   Sun,  2 Aug 2020 16:28:12 -0700
Message-Id: <20200802232812.16794-1-ashutosh.dixit@intel.com>
X-Mailer: git-send-email 2.26.2.108.g048abe1751
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the following sparse warnings in drivers/misc/mic/vop//vop_main.c:

551:58: warning: incorrect type in argument 1 (different address spaces)
551:58:    expected void const volatile [noderef] __iomem *addr
551:58:    got restricted __le64 *
560:49: warning: incorrect type in argument 1 (different address spaces)
560:49:    expected struct mic_device_ctrl *dc
560:49:    got struct mic_device_ctrl [noderef] __iomem *dc
579:49: warning: incorrect type in argument 1 (different address spaces)
579:49:    expected struct mic_device_ctrl *dc
579:49:    got struct mic_device_ctrl [noderef] __iomem *dc

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 drivers/misc/mic/vop/vop_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mic/vop/vop_main.c b/drivers/misc/mic/vop/vop_main.c
index 85942f6717c5..25ed7d731701 100644
--- a/drivers/misc/mic/vop/vop_main.c
+++ b/drivers/misc/mic/vop/vop_main.c
@@ -546,7 +546,7 @@ static int vop_match_desc(struct device *dev, void *data)
 	return vdev->desc == (void __iomem *)data;
 }
 
-static struct _vop_vdev *vop_dc_to_vdev(struct mic_device_ctrl *dc)
+static struct _vop_vdev *vop_dc_to_vdev(struct mic_device_ctrl __iomem *dc)
 {
 	return (struct _vop_vdev *)(unsigned long)readq(&dc->vdev);
 }
-- 
2.26.2.108.g048abe1751

