Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7526ECE35
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjDXNaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjDXNaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E969D76A9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 281E061A70
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDD6C433EF;
        Mon, 24 Apr 2023 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342961;
        bh=VahnRxo7Kq5WbSP8gj2jf+/OfKsBxnlEmpy8qbtU+1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxi0nNMoTjikiRy6qqTTjslGpXIEB6vyjMrIxxFtt0fctKE06bFHO0gt+UVz+eLpn
         xvyrwGTK5r+6bYV2eycZ8ktmwGQWJaQTAaKGqdGLXJkubAb+LtBvLXzvBYj6fHzmw1
         Eg4MPWMj28pCM14cYmiyFhtjmULPNABY9pTKWnow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 024/110] cxgb4: fix use after free bugs caused by circular dependency problem
Date:   Mon, 24 Apr 2023 15:16:46 +0200
Message-Id: <20230424131137.040237149@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit e50b9b9e8610d47b7c22529443e45a16b1ea3a15 ]

The flower_stats_timer can schedule flower_stats_work and
flower_stats_work can also arm the flower_stats_timer. The
process is shown below:

----------- timer schedules work ------------
ch_flower_stats_cb() //timer handler
  schedule_work(&adap->flower_stats_work);

----------- work arms timer ------------
ch_flower_stats_handler() //workqueue callback function
  mod_timer(&adap->flower_stats_timer, ...);

When the cxgb4 device is detaching, the timer and workqueue
could still be rearmed. The process is shown below:

  (cleanup routine)           | (timer and workqueue routine)
remove_one()                  |
  free_some_resources()       | ch_flower_stats_cb() //timer
    cxgb4_cleanup_tc_flower() |   schedule_work()
      del_timer_sync()        |
                              | ch_flower_stats_handler() //workqueue
                              |   mod_timer()
      cancel_work_sync()      |
  kfree(adapter) //FREE       | ch_flower_stats_cb() //timer
                              |   adap->flower_stats_work //USE

This patch changes del_timer_sync() to timer_shutdown_sync(),
which could prevent rearming of the timer from the workqueue.

Fixes: e0f911c81e93 ("cxgb4: fetch stats for offloaded tc flower flows")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20230415081227.7463-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index dd9be229819a5..d3541159487dd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -1135,7 +1135,7 @@ void cxgb4_cleanup_tc_flower(struct adapter *adap)
 		return;
 
 	if (adap->flower_stats_timer.function)
-		del_timer_sync(&adap->flower_stats_timer);
+		timer_shutdown_sync(&adap->flower_stats_timer);
 	cancel_work_sync(&adap->flower_stats_work);
 	rhashtable_destroy(&adap->flower_tbl);
 	adap->tc_flower_initialized = false;
-- 
2.39.2



