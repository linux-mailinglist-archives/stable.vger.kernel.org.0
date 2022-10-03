Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8999D5F2A2E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiJCHcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiJCHbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C588D4D80F;
        Mon,  3 Oct 2022 00:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3062360FC1;
        Mon,  3 Oct 2022 07:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4672BC433D6;
        Mon,  3 Oct 2022 07:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781628;
        bh=Qehyhczy34GYCAxTdZ+1feiRyWrmxMPUNWaUD+1T+aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub4X5N3lsiB2SdBtGa3MZ8YsZi8wJj7xn+HoUlgPrEKDoE6lNEYq6NmTn9wIVEbvB
         AQu1kCL/yjFEIdb9tHHQH9PfY/vyepAUwf8qUg4i0ohsOZpXnhWcGTHo5Pf30I+YIk
         sX6npY/udz9+RCQHnYsIShDHo56skMQApXQAx6b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Angus Chen <angus.chen@jaguarmicro.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/83] vdpa/ifcvf: fix the calculation of queuepair
Date:   Mon,  3 Oct 2022 09:11:30 +0200
Message-Id: <20221003070723.626652120@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Chen <angus.chen@jaguarmicro.com>

[ Upstream commit db5db1a00d0816207be3a0166fcb4f523eaf3b52 ]

The q_pair_id to address a queue pair in the lm bar should be
calculated by queue_id / 2 rather than queue_id / nr_vring.

Fixes: 2ddae773c93b ("vDPA/ifcvf: detect and use the onboard number of queues directly")
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@intel.com>
Message-Id: <20220923091013.191-1-angus.chen@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 7d41dfe48ade..5091ff9d6c93 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -327,7 +327,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	last_avail_idx = ifc_ioread16(avail_idx_addr);
 
@@ -341,7 +341,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	hw->vring[qid].last_avail_idx = num;
 	ifc_iowrite16(num, avail_idx_addr);
-- 
2.35.1



