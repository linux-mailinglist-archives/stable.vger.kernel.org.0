Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7063586A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiKWJ5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiKWJ4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:56:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAC010573
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDF21B81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA50C433C1;
        Wed, 23 Nov 2022 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197066;
        bh=pI+t2qaAQ/nsC24gNRpl5Q/MEht6VRjnyWb4HNFljxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZq9hw12xMImvIc5tR0o0UbNSAwBowfga3ZSgf1lGUXvp68EL8R9rlkG3VDvkUSrs
         3eBGZPuWtefFxJ6QjHtDIuE0Ehr1+UDmtUqNLYnT2zwfgJJKn8UpvOzGHW9Dy6O7eY
         iW4uTaiWABYs/O6X7UPfca7d1/qtwK+/mDserRkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 188/314] net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
Date:   Wed, 23 Nov 2022 09:50:33 +0100
Message-Id: <20221123084634.087951589@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit ba86af3733aece88dbcee0dfebf7e2dcfefb2be4 ]

lan966x_stats_init() calls create_singlethread_workqueue() and not
checked the ret value, which may return NULL. And a null-ptr-deref may
happen:

lan966x_stats_init()
    create_singlethread_workqueue() # failed, lan966x->stats_queue is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index fea42542be28..06811c60d598 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -716,6 +716,9 @@ int lan966x_stats_init(struct lan966x *lan966x)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(lan966x->dev));
 	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!lan966x->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
 	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
 			   LAN966X_STATS_CHECK_DELAY);
-- 
2.35.1



