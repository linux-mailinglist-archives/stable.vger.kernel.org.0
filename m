Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A0A66C52E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjAPQCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjAPQCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D61710DA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39969B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9B2C433D2;
        Mon, 16 Jan 2023 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884913;
        bh=WBTYunhz8NWBUBkBPvZTdgu/H0Mtpc49kJZrVQI3NPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg+70EmEY4khnNLpFOfmUsge0Bp+ME9wpuV9sBAJ7K8tKSDwFLM58VHiRfToU9ZHy
         PaiWp6OQEjRF1YtSMTsGch6aoy9GGJw7DxnAHs7GXFX8VJAL2zoId6NxDCikR9LTik
         Letmtaf8rxqixkVqVhwltVyop9RXieRffLaE5k/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jie Wang <wangjie125@huawei.com>,
        Hao Lan <lanhao@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/183] net: hns3: fix wrong use of rss size during VF rss config
Date:   Mon, 16 Jan 2023 16:51:33 +0100
Message-Id: <20230116154810.483036507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit ae9f29fdfd827ad06c1ae8155c042245a9d00757 ]

Currently, it used old rss size to get current tc mode. As a result, the
rss size is updated, but the tc mode is still configured based on the old
rss size.

So this patch fixes it by using the new rss size in both process.

Fixes: 93969dc14fcd ("net: hns3: refactor VF rss init APIs with new common rss init APIs")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230110115359.10163-1-lanhao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 081bd2c3f289..e84e5be8e59e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3130,7 +3130,7 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 
 	hclgevf_update_rss_size(handle, new_tqps_num);
 
-	hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
+	hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,
 				   tc_offset, tc_valid, tc_size);
 	ret = hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
 					 tc_valid, tc_size);
-- 
2.35.1



