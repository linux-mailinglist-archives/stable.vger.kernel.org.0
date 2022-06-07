Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF24E54063C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbiFGRdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347818AbiFGRbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4E410A622;
        Tue,  7 Jun 2022 10:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C87B8220B;
        Tue,  7 Jun 2022 17:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF40C385A5;
        Tue,  7 Jun 2022 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622908;
        bh=6PvPp41sWDIFRVcwMs3dWSgt0lhHS7kXOIPuLaqjBcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTIEDBg68VAR88X7vZhksMAAWemd3RDXJwizbPxJpfGG9/wjMzQmk92EJw7yehtjO
         oe8EpJHf9ohvl8CCcSdYirc3/qmNgvbHfrG4K5XAL84Ds1ozl7j8jVl46xo/qudt1e
         BhWKVd692qzSvz4sx/VMD255gp875W2h8AtfvAzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/452] net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init
Date:   Tue,  7 Jun 2022 19:01:23 +0200
Message-Id: <20220607164915.298695412@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit 382d917bfc1e92339dae3c8a636b2730e8bb5132 ]

hinic_pf_to_mgmt_init misses destroy_workqueue in error path,
this patch fixes that.

Fixes: 6dbb89014dc3 ("hinic: fix sending mailbox timeout in aeq event work")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 819fa13034c0..027dcc453506 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -647,6 +647,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = alloc_msg_buf(pf_to_mgmt);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate msg buffers\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
@@ -654,6 +655,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = hinic_api_cmd_init(pf_to_mgmt->cmd_chain, hwif);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize cmd chains\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
-- 
2.35.1



