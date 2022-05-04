Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED951A78D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355332AbiEDRGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356114AbiEDREy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456E4FC7D;
        Wed,  4 May 2022 09:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7769B827A1;
        Wed,  4 May 2022 16:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713E8C385A5;
        Wed,  4 May 2022 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683229;
        bh=8R1bqNa1LrPBpaMM7GYTDfIzchc+vEeUxh2iMxqtLKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J05c/Gw357TGMTZRWq7IKYcl8KbG/EkUk9JsFtwN7c0b+I6HcRvP6ZTVvejyY0OCT
         yg5wubs9b6DbEL0w3FtwpL/dEoOTqbF/JCjaR8HT4Sp2nm5c/WdbdAp59khGErdfgK
         ZB0AK1vR26opXD5iyWCripkoo6l1+/U1Z2IFq2jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/177] net: hns3: modify the return code of hclge_get_ring_chain_from_mbx
Date:   Wed,  4 May 2022 18:44:47 +0200
Message-Id: <20220504153101.516125357@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

[ Upstream commit 48009e9972974c52a5f649f761862dd67bce3d13 ]

Currently, function hclge_get_ring_chain_from_mbx will return -ENOMEM if
ring_num is bigger than HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM. It is better to
return -EINVAL for the invalid parameter case.

So this patch fixes it by return -EINVAL in this abnormal branch.

Fixes: 5d02a58dae60 ("net: hns3: fix for buffer overflow smatch warning")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 65d78ee4d65a..e30bf3027375 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -175,7 +175,7 @@ static int hclge_get_ring_chain_from_mbx(
 	ring_num = req->msg.ring_num;
 
 	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
-		return -ENOMEM;
+		return -EINVAL;
 
 	for (i = 0; i < ring_num; i++) {
 		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
-- 
2.35.1



