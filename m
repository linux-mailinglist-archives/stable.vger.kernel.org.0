Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC93551A92E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356143AbiEDRNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357353AbiEDRKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B463B4AE0F;
        Wed,  4 May 2022 09:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE8DB827A4;
        Wed,  4 May 2022 16:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCC6C385AA;
        Wed,  4 May 2022 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683436;
        bh=lhzlZLPEEXYW9Hm9o6P8qfPtCrZcAtQtbZGZWklwKYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWsTZRF8x8SQYFbTUFbtgLNEcPqB68mQoHTlyEhCFEwYtUGDn+T6q+cmWQSfqxlYa
         gwE+VROTVvmfUn0cX8xxuuJGc/OgKS8BUjGT4qBj5GqGvnPdfByKeLGWai9N7usHFB
         3isBLXN1+8/FyzezRwj9/VacC9iQqvyypscyv5K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 116/225] net: hns3: modify the return code of hclge_get_ring_chain_from_mbx
Date:   Wed,  4 May 2022 18:45:54 +0200
Message-Id: <20220504153120.895110552@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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
index 6799d16de34b..36cbafc5f944 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -176,7 +176,7 @@ static int hclge_get_ring_chain_from_mbx(
 	ring_num = req->msg.ring_num;
 
 	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
-		return -ENOMEM;
+		return -EINVAL;
 
 	for (i = 0; i < ring_num; i++) {
 		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
-- 
2.35.1



