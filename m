Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5FD47275E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhLMKAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44780 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236745AbhLMJ6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71D41B80E89;
        Mon, 13 Dec 2021 09:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F62C34601;
        Mon, 13 Dec 2021 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389500;
        bh=0/j9Uls9Pd+3PIPo1IwyMXgiKM5tFYm2ykiUwD8CqE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBrmLaTWnV1VGw90/4AAOg40njPK2RJ6GqtlhVKhU3GjyhyL2qCdr8+rqBPiYuZZ/
         YwTWUisbScqk0Gjp5ZFEE9brABvIaud7WmvNOUlWyBURPhcdM8B2BIzYLlvM/8JiDU
         gQYjvXU5Dmvd2m5G6aF3QxfR2Am19zFyLgm5Sp+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 113/171] RDMA/hns: Do not halt commands during reset until later
Date:   Mon, 13 Dec 2021 10:30:28 +0100
Message-Id: <20211213092948.860745781@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

commit 52414e27d6b568120b087d1fbafbb4482b0ccaab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6397,10 +6397,8 @@ static int hns_roce_hw_v2_reset_notify_d
 	if (!hr_dev)
 		return 0;
 
-	hr_dev->is_reset = true;
 	hr_dev->active = false;
 	hr_dev->dis_db = true;
-
 	hr_dev->state = HNS_ROCE_DEVICE_STATE_RST_DOWN;
 
 	return 0;


