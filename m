Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDD0551990
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbiFTNAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244789AbiFTM7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7261CFC8;
        Mon, 20 Jun 2022 05:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65A71614DA;
        Mon, 20 Jun 2022 12:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A65C3411C;
        Mon, 20 Jun 2022 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729807;
        bh=qrkbySgKhibtVCFL0La5dUdABQ+I8ii8SIbiNjB7t0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSXcnqPyjQDA9kC4lC2Ql+X+U6rBJT6q5Y/zCwHOQewg2Aqh7iNqOL6BvoeewjunO
         C6Uqu20pruzAWGg+kX6h5DgzxaHqEEynAFPQdNjasoOYZHoWHtEUOkQTU/LEZJ/Y6a
         OXkzGSMnljDO3LoX1JsmAo9uokuBOx4ZNQwWZfDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 072/141] net: hns3: fix PF rss size initialization bug
Date:   Mon, 20 Jun 2022 14:50:10 +0200
Message-Id: <20220620124731.667222691@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 71b215f36dca1a3d5d1c576b2099e6d7ea03047e ]

Currently hns3 driver misuses the VF rss size to initialize the PF rss size
in hclge_tm_vport_tc_info_update. So this patch fix it by checking the
vport id before initialization.

Fixes: 7347255ea389 ("net: hns3: refactor PF rss get APIs with new common rss get APIs")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index ad53a3447322..f5296ff60694 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -681,7 +681,9 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	kinfo->num_tqps = hclge_vport_get_tqp_num(vport);
 	vport->dwrr = 100;  /* 100 percent as init */
 	vport->bw_limit = hdev->tm_info.pg_info[0].bw_limit;
-	hdev->rss_cfg.rss_size = kinfo->rss_size;
+
+	if (vport->vport_id == PF_VPORT_ID)
+		hdev->rss_cfg.rss_size = kinfo->rss_size;
 
 	/* when enable mqprio, the tc_info has been updated. */
 	if (kinfo->tc_info.mqprio_active)
-- 
2.35.1



