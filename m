Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C9471AAA
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhLLOW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:22:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40252 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhLLOW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0738CE0B6A
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDFEC341C5;
        Sun, 12 Dec 2021 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639318973;
        bh=aD3WOb9efGec0kaFYHsvhD3xPu86V/b/9Cgk1OJg9dQ=;
        h=Subject:To:Cc:From:Date:From;
        b=b2grx9DPqWrKIRktkl6pqcNylpmxNeYBbVrq0a66+EYaNrTzOEsenJ3sQOHDzh09k
         Sh///6C2s9QoPto9d6RrQLWhfPr9Yl5EHdxafkTpsLCbXfpsHqvAJbTD6wJl6nW6A4
         xyYEUuKvMz8+SQAkIYirUvizo/4a6gY4B61CAT/g=
Subject: FAILED: patch "[PATCH] RDMA/hns: Do not halt commands during reset until later" failed to apply to 5.4-stable tree
To:     liyangyang20@huawei.com, jgg@nvidia.com, liangwenpeng@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:22:50 +0100
Message-ID: <16393189704367@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52414e27d6b568120b087d1fbafbb4482b0ccaab Mon Sep 17 00:00:00 2001
From: Yangyang Li <liyangyang20@huawei.com>
Date: Tue, 23 Nov 2021 16:48:09 +0800
Subject: [PATCH] RDMA/hns: Do not halt commands during reset until later

is_reset is used to indicate whether the hardware starts to reset. When
hns_roce_hw_v2_reset_notify_down() is called, the hardware has not yet
started to reset. If is_reset is set at this time, all mailbox operations
of resource destroy actions will be intercepted by driver. When the driver
cleans up resources, but the hardware is still accessed, the following
errors will appear:

  arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000350100000010
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x000002088000003f
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x00000000a50e0800
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000000000000000
  arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000350100000010
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x000002088000043e
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x00000000a50a0800
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000000000000000
  arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000350100000010
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000020880000436
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x00000000a50a0880
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000000000000000
  arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000350100000010
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x000002088000043a
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x00000000a50e0840
  hns3 0000:35:00.0: INT status: CMDQ(0x0) HW errors(0x0) other(0x0)
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000000000000000
  hns3 0000:35:00.0: received unknown or unhandled event of vector0
  arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.2.auto: 	0x0000350100000010
  {34}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 7

is_reset will be set correctly in check_aedev_reset_status(), so the
setting in hns_roce_hw_v2_reset_notify_down() should be deleted.

Fixes: 726be12f5ca0 ("RDMA/hns: Set reset flag when hw resetting")
Link: https://lore.kernel.org/r/20211123084809.37318-1-liangwenpeng@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9bfbaddd1763..ae14329c619c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6387,10 +6387,8 @@ static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 	if (!hr_dev)
 		return 0;
 
-	hr_dev->is_reset = true;
 	hr_dev->active = false;
 	hr_dev->dis_db = true;
-
 	hr_dev->state = HNS_ROCE_DEVICE_STATE_RST_DOWN;
 
 	return 0;

