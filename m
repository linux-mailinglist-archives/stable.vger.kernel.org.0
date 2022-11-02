Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7D46159A6
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKBDQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiKBDPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:15:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF3D248F8
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58183B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32213C433C1;
        Wed,  2 Nov 2022 03:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358916;
        bh=t/to6hZaq3ncMU0PwNe9CuhcUWGzy41DQLQXwM2QxbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkLw6+ynEmsxNbYfcuCZ5tz9p7DfdX4IyGyPiWkvpmwWonReKIGQQ2Y5yi4vmwNxu
         lVoFOEFZIFZqHHLhp0O9gLxC8FJ98TxoJIJP7DuVK2itWAFJy6yXqJYJPRpsPmqxC6
         w2vQsIymVQxI+q3nqulZ2tAblhSi/y476pk+A4Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/91] net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
Date:   Wed,  2 Nov 2022 03:33:29 +0100
Message-Id: <20221102022056.337496963@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c0605cd6750f2db9890c43a91ea4d77be8fb4908 ]

The value of lli_credit_cnt is incorrectly assigned, fix it.

Fixes: a0337c0dee68 ("hinic: add support to set and get irq coalesce")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 799b85c88eff..bcf2476512a5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -892,7 +892,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 	if (err)
 		return -EINVAL;
 
-	interrupt_info->lli_credit_cnt = temp_info.lli_timer_cnt;
+	interrupt_info->lli_credit_cnt = temp_info.lli_credit_cnt;
 	interrupt_info->lli_timer_cnt = temp_info.lli_timer_cnt;
 
 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
-- 
2.35.1



