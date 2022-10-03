Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B75F29AF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiJCHX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiJCHWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:22:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF6A42ACB;
        Mon,  3 Oct 2022 00:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EE62B80E81;
        Mon,  3 Oct 2022 07:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE87C43147;
        Mon,  3 Oct 2022 07:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781402;
        bh=5P0xPnBni2NMZ7vC4rX45isOsYP7Y3Sw/60Evz320Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yud/V1ByErvgBhwzOuaFtg5w+V75tR8hss4kyyqcN8Si40EsIuBc/8ZQNyCiL+ab
         XX45eX3b7r1/Xq01ehQFbIQtBYrkADHeKuWZ9nCMX/QzUPJsigifBKhlYS8jCb3Txg
         rCv1Wtc+YVEYJPrfPPn8ihHkTdUsaTzRGit7iieE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Angus Chen <angus.chen@jaguarmicro.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 086/101] vdpa/ifcvf: fix the calculation of queuepair
Date:   Mon,  3 Oct 2022 09:11:22 +0200
Message-Id: <20221003070726.587974474@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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
index 48c4dadb0c7c..a4c1b985f79a 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -315,7 +315,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	last_avail_idx = vp_ioread16(avail_idx_addr);
 
@@ -329,7 +329,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	hw->vring[qid].last_avail_idx = num;
 	vp_iowrite16(num, avail_idx_addr);
-- 
2.35.1



