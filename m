Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FD9541570
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357735AbiFGUfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377667AbiFGUd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B431E6FB9;
        Tue,  7 Jun 2022 11:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3443D61564;
        Tue,  7 Jun 2022 18:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A791C385A2;
        Tue,  7 Jun 2022 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626939;
        bh=uBPclYGIRXYxVUL7iSz9jVBP9HXekQiV38fKekNAEOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggXpiZNbZz8so9BxNZgRDRKZPcGI7w7S+WO2Pp+gG13y436807Qah6XnMj8wu02V1
         9R5p8OQdv+edis5WqwDYpGTQsOhZ8G8W7RkfZT3QS9zP6gHdhgtsvxrhXtU7hVqAei
         AGhA/vLtM+gMZ4Gb9s1Ab7QAJ0wl4JJt5yFlzyQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangyang Li <liyangyang20@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 518/772] RDMA/hns: Add the detection for CMDQ status in the device initialization process
Date:   Tue,  7 Jun 2022 19:01:50 +0200
Message-Id: <20220607165004.243396463@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit e8ea058edc2b225a68b307057a65599625daaebf ]

CMDQ may fail during HNS ROCEE initialization. The following is the log
when the execution fails:

  hns3 0000:bd:00.2: In reset process RoCE client reinit.
  hns3 0000:bd:00.2: CMDQ move tail from 840 to 839
  hns3 0000:bd:00.2 hns_2: failed to set gid, ret = -11!
  hns3 0000:bd:00.2: CMDQ move tail from 840 to 839
  <...>
  hns3 0000:bd:00.2: CMDQ move tail from 840 to 839
  hns3 0000:bd:00.2: CMDQ move tail from 840 to 0
  hns3 0000:bd:00.2: [cmd]token 14e mailbox 20 timeout.
  hns3 0000:bd:00.2 hns_2: set HEM step 0 failed!
  hns3 0000:bd:00.2 hns_2: set HEM address to HW failed!
  hns3 0000:bd:00.2 hns_2: failed to alloc mtpt, ret = -16.
  infiniband hns_2: Couldn't create ib_mad PD
  infiniband hns_2: Couldn't open port 1
  hns3 0000:bd:00.2: Reset done, RoCE client reinit finished.

However, even if ib_mad client registration failed, ib_register_device()
still returns success to the driver.

In the device initialization process, CMDQ execution fails because HW/FW
is abnormal. Therefore, if CMDQ fails, the initialization function should
set CMDQ to a fatal error state and return a failure to the caller.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/20220429093104.26687-1-liangwenpeng@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 ++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1e0bae136997..f3360fc6640b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -535,6 +535,11 @@ struct hns_roce_cmd_context {
 	u16			busy;
 };
 
+enum hns_roce_cmdq_state {
+	HNS_ROCE_CMDQ_STATE_NORMAL,
+	HNS_ROCE_CMDQ_STATE_FATAL_ERR,
+};
+
 struct hns_roce_cmdq {
 	struct dma_pool		*pool;
 	struct semaphore	poll_sem;
@@ -554,6 +559,7 @@ struct hns_roce_cmdq {
 	 * close device, switch into poll mode(non event mode)
 	 */
 	u8			use_events;
+	enum hns_roce_cmdq_state state;
 };
 
 struct hns_roce_cmd_mailbox {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b33e948fd060..e7039399dde5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1265,6 +1265,16 @@ static int hns_roce_cmq_csq_done(struct hns_roce_dev *hr_dev)
 	return tail == priv->cmq.csq.head;
 }
 
+static void update_cmdq_status(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hnae3_handle *handle = priv->handle;
+
+	if (handle->rinfo.reset_state == HNS_ROCE_STATE_RST_INIT ||
+	    handle->rinfo.instance_state == HNS_ROCE_STATE_INIT)
+		hr_dev->cmd.state = HNS_ROCE_CMDQ_STATE_FATAL_ERR;
+}
+
 static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_cmq_desc *desc, int num)
 {
@@ -1318,6 +1328,8 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			 csq->head, tail);
 		csq->head = tail;
 
+		update_cmdq_status(hr_dev);
+
 		ret = -EAGAIN;
 	}
 
@@ -1332,6 +1344,9 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	bool busy;
 	int ret;
 
+	if (hr_dev->cmd.state == HNS_ROCE_CMDQ_STATE_FATAL_ERR)
+		return -EIO;
+
 	if (!v2_chk_mbox_is_avail(hr_dev, &busy))
 		return busy ? -EBUSY : 0;
 
@@ -1528,6 +1543,9 @@ static void hns_roce_function_clear(struct hns_roce_dev *hr_dev)
 {
 	int i;
 
+	if (hr_dev->cmd.state == HNS_ROCE_CMDQ_STATE_FATAL_ERR)
+		return;
+
 	for (i = hr_dev->func_num - 1; i >= 0; i--) {
 		__hns_roce_function_clear(hr_dev, i);
 		if (i != 0)
@@ -2812,6 +2830,9 @@ static int v2_wait_mbox_complete(struct hns_roce_dev *hr_dev, u32 timeout,
 	mb_st = (struct hns_roce_mbox_status *)desc.data;
 	end = msecs_to_jiffies(timeout) + jiffies;
 	while (v2_chk_mbox_is_avail(hr_dev, &busy)) {
+		if (hr_dev->cmd.state == HNS_ROCE_CMDQ_STATE_FATAL_ERR)
+			return -EIO;
+
 		status = 0;
 		hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_QUERY_MB_ST,
 					      true);
-- 
2.35.1



