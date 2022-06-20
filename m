Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8628551C77
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbiFTNVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344677AbiFTNTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:19:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F48273C;
        Mon, 20 Jun 2022 06:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52067B811DC;
        Mon, 20 Jun 2022 13:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3073C3411B;
        Mon, 20 Jun 2022 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730472;
        bh=4qFLn4i9EC/djJiRhUWu34S6yAT/117hdjbWP984UM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiLtLE7CuCGXoVw5Wq5WP4nR8Iho40IKTStGalMNkt8bg9BM7Kksv5hQ7/TfQDJ3V
         7/zlCobGVPbTjIIMolHrk/Xc80fgInjJI+WE3wljKhCcDXbAI1/oIPpsVNcdfbY8H5
         TArkZtvr/Czlu5DiA+V9sXQu2vfYAqTHe4Ek6EXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/106] net: hns3: dont push link state to VF if unalive
Date:   Mon, 20 Jun 2022 14:51:21 +0200
Message-Id: <20220620124726.236975959@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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
index 15098570047b..24239e28e88a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3302,6 +3302,12 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
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



