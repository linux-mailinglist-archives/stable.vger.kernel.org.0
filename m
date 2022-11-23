Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0745A635868
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiKWJ5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiKWJ4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:56:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1648813CC8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A87C5619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D1DC433D6;
        Wed, 23 Nov 2022 09:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197070;
        bh=feMsALXz85U2vb/pvWMeb9NzVK7H6lDZiOcd7vmSaus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwNqJURNYH1rKRu8FfavzRgb2e6ZgI5BrPTLTy2+qVnJUExXfd89N6awELj2Bl6k7
         AG0DyNV2L17prGqAXKzn03N+yDD/UVQ5JI3o4IeaT5ltI5FPopcoONhhXup7CELKhI
         gHUSG/SnVgAd6d5/NtqbVQAEfwqeTtRv87fRLtDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 189/314] net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()
Date:   Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084634.119545195@linuxfoundation.org>
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

[ Upstream commit 639f5d006e36bb303f525d9479448c412b720c39 ]

sparx_stats_init() calls create_singlethread_workqueue() and not
checked the ret value, which may return NULL. And a null-ptr-deref may
happen:

sparx_stats_init()
    create_singlethread_workqueue() # failed, sparx5->stats_queue is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL. So as
sparx5_start().

Fixes: af4b11022e2d ("net: sparx5: add ethtool configuration and statistics support")
Fixes: b37a1bae742f ("net: sparx5: add mactable support")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c | 3 +++
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 6b0febcb7fa9..01f3a3a41cdb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1253,6 +1253,9 @@ int sparx_stats_init(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(sparx5->dev));
 	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
 	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
 			   SPX5_STATS_CHECK_DELAY);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 01be7bd84181..30815c0e3f76 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -657,6 +657,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-mact",
 		 dev_name(sparx5->dev));
 	sparx5->mact_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->mact_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->mact_work, sparx5_mact_pull_work);
 	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
 			   SPX5_MACT_PULL_DELAY);
-- 
2.35.1



