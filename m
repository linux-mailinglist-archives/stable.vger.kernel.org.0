Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBE0541B37
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381317AbiFGVm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381700AbiFGVll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:41:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87052233542;
        Tue,  7 Jun 2022 12:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC2E6186B;
        Tue,  7 Jun 2022 19:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE187C385A5;
        Tue,  7 Jun 2022 19:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628822;
        bh=Q224vtITk0d/tz032JMgEBEMMV9rpIBeSBHpFkpXEq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iORRcq0z6Y3pVJGSB/LvFkYSM3Gw7A3ZZa2asvRoGwN2gJY3OOO7Vc5WiVTCricIa
         +trurr7DDGsVsv//2m6l3wJyMTUSIUPmbee/yBLLKceIfCG5pyWmxlFhdBtT31U41e
         c/EtBHtbEELygOWJB6LlDFBJoIYReJ0O3afX1dn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 469/879] net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init
Date:   Tue,  7 Jun 2022 18:59:47 +0200
Message-Id: <20220607165016.491790899@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index ebc77771f5da..4aa1f433ed24 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -643,6 +643,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = alloc_msg_buf(pf_to_mgmt);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to allocate msg buffers\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
@@ -650,6 +651,7 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	err = hinic_api_cmd_init(pf_to_mgmt->cmd_chain, hwif);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize cmd chains\n");
+		destroy_workqueue(pf_to_mgmt->workq);
 		hinic_health_reporters_destroy(hwdev->devlink_dev);
 		return err;
 	}
-- 
2.35.1



