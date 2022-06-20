Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99395551991
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbiFTNCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243823AbiFTNBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40EA1CFD4;
        Mon, 20 Jun 2022 05:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D04EB811BD;
        Mon, 20 Jun 2022 12:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5F2C3411B;
        Mon, 20 Jun 2022 12:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729832;
        bh=EwPaBTg4uRgoErXhKRZXM6RnPI0iuAxbfKZUuX7aFNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LL4WlYy/t4ask9RJWhjHjPGJk6PhWVNcIHulxszQoQqm7IkXzBTcC5E+8Lm8uP1oP
         /KAnXsF/OgNFF8Yr55bS9pJmd3Jzx1Ug0XCKe/85z18AmUyP8GxwvINm574yEJTzf4
         Leoq8P+tfbPwG+QTJfOQzuYEL4l5qSy2IGiqCCd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 070/141] net: hns3: dont push link state to VF if unalive
Date:   Mon, 20 Jun 2022 14:50:08 +0200
Message-Id: <20220620124731.606158757@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 283847e3ef6dbf79bf67083b5ce7b8033e8b6f34 ]

It's unnecessary to push link state to unalive VF, and the VF will
query link state from PF when it being start works.

Fixes: 18b6e31f8bf4 ("net: hns3: PF add support for pushing link status to VFs")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5d1615e27a1c..c8c99ab60ec1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3384,6 +3384,12 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 	link_state_old = vport->vf_info.link_state;
 	vport->vf_info.link_state = link_state;
 
+	/* return success directly if the VF is unalive, VF will
+	 * query link state itself when it starts work.
+	 */
+	if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		return 0;
+
 	ret = hclge_push_vf_link_status(vport);
 	if (ret) {
 		vport->vf_info.link_state = link_state_old;
-- 
2.35.1



