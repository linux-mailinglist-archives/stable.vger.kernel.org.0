Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402B2471AAB
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhLLOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:23:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57324 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhLLOXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:23:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF57B80D15
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19345C341C6;
        Sun, 12 Dec 2021 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639318989;
        bh=IIpH/qstyU+bigNreVyqd2CkXhlf4FqDkFYVx0heG+o=;
        h=Subject:To:Cc:From:Date:From;
        b=GmCZPftZkMnSiTRbcuhE5Qa+FV9UcO9npa90s6Pn/RJlNavjLwPed4sU80WCv2pRL
         fJcjUVH/CMD0QE2inwQnKO26AyB4sqZs6iLBe0ZO3pJbMDv4qepRwq3beT/8k5nIxv
         z+u/6HJpn40IuHa4/OHDKZ8mVVWWzw+fJTKLogj4=
Subject: FAILED: patch "[PATCH] RDMA/hns: Do not destroy QP resources in the hw resetting" failed to apply to 5.4-stable tree
To:     liyangyang20@huawei.com, jgg@nvidia.com, liangwenpeng@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:23:06 +0100
Message-ID: <163931898632104@kroah.com>
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

From b0969f83890bf8b47f5c8bd42539599b2b52fdeb Mon Sep 17 00:00:00 2001
From: Yangyang Li <liyangyang20@huawei.com>
Date: Tue, 23 Nov 2021 22:24:02 +0800
Subject: [PATCH] RDMA/hns: Do not destroy QP resources in the hw resetting
 phase

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

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ae14329c619c..bbfa1332dedc 100644
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
@@ -1050,9 +1051,14 @@ static u32 hns_roce_v2_cmd_hw_resetting(struct hns_roce_dev *hr_dev,
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
@@ -1064,7 +1070,11 @@ static u32 hns_roce_v2_cmd_hw_resetting(struct hns_roce_dev *hr_dev,
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

