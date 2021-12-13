Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C07F472763
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbhLMKAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:00:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45920 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237552AbhLMJ61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:58:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EEEA9CE0F55;
        Mon, 13 Dec 2021 09:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C78C34602;
        Mon, 13 Dec 2021 09:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389504;
        bh=4HCJNBqIX3ntQXXkLc1N/WUuVyimm6/0jFxR97gMZFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV2TrHWv37M9J5z6tf3QWYyCwZ6V1h+KcQi1fbcl2DQXFezn2FaKw6LA0j0+pzRR1
         nVVuoDrxXf49xEjsvcvY8hWdLXAWi+B0X6n7/uv8ie/nE+mwEUe5sbXQWFyzw1CVeE
         nwbtufiz3lRjpSUHdOsRr0Du6uVfBRS/9GgwCkTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 114/171] RDMA/hns: Do not destroy QP resources in the hw resetting phase
Date:   Mon, 13 Dec 2021 10:30:29 +0100
Message-Id: <20211213092948.898682761@linuxfoundation.org>
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

commit b0969f83890bf8b47f5c8bd42539599b2b52fdeb upstream.

When hns_roce_v2_destroy_qp() is called, the brief calling process of the
driver is as follows:

 ......
 hns_roce_v2_destroy_qp
 hns_roce_v2_qp_modify
	   hns_roce_cmd_mbox
 hns_roce_qp_destroy

If hns_roce_cmd_mbox() detects that the hardware is being reset during the
execution of the hns_roce_cmd_mbox(), the driver will not be able to get
the return value from the hardware (the firmware cannot respond to the
driver's mailbox during the hardware reset phase).

The driver needs to wait for the hardware reset to complete before
continuing to execute hns_roce_qp_destroy(), otherwise it may happen that
the driver releases the resources but the hardware is still accessing. In
order to fix this problem, HNS RoCE needs to add a piece of code to wait
for the hardware reset to complete.

The original interface get_hw_reset_stat() is the instantaneous state of
the hardware reset, which cannot accurately reflect whether the hardware
reset is completed, so it needs to be replaced with the ae_dev_reset_cnt
interface.

The sign that the hardware reset is complete is that the return value of
the ae_dev_reset_cnt interface is greater than the original value
reset_cnt recorded by the driver.

Fixes: 6a04aed6afae ("RDMA/hns: Fix the chip hanging caused by sending mailbox&CMQ during reset")
Link: https://lore.kernel.org/r/20211123142402.26936-1-liangwenpeng@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -33,6 +33,7 @@
 #include <linux/acpi.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <net/addrconf.h>
@@ -1050,9 +1051,14 @@ static u32 hns_roce_v2_cmd_hw_resetting(
 					unsigned long instance_stage,
 					unsigned long reset_stage)
 {
+#define HW_RESET_TIMEOUT_US 1000000
+#define HW_RESET_SLEEP_US 1000
+
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hnae3_handle *handle = priv->handle;
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long val;
+	int ret;
 
 	/* When hardware reset is detected, we should stop sending mailbox&cmq&
 	 * doorbell to hardware. If now in .init_instance() function, we should
@@ -1064,7 +1070,11 @@ static u32 hns_roce_v2_cmd_hw_resetting(
 	 * again.
 	 */
 	hr_dev->dis_db = true;
-	if (!ops->get_hw_reset_stat(handle))
+
+	ret = read_poll_timeout(ops->ae_dev_reset_cnt, val,
+				val > hr_dev->reset_cnt, HW_RESET_SLEEP_US,
+				HW_RESET_TIMEOUT_US, false, handle);
+	if (!ret)
 		hr_dev->is_reset = true;
 
 	if (!hr_dev->is_reset || reset_stage == HNS_ROCE_STATE_RST_INIT ||


