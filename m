Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68D6537DA8
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiE3Niy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237468AbiE3Ngr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E682ADF0E;
        Mon, 30 May 2022 06:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8289B80DA8;
        Mon, 30 May 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3EEC36AE3;
        Mon, 30 May 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917412;
        bh=y3bhC0rUOrF3icDOfUWiGnm7BKnScQLuWa8qmBsViaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS7JqJPDuop2TRgoVTntfUNVRJuqIWlK2hxboYk/LN8/FpLf1yiRp28HbmXwRh0zE
         OJmh6Y3sHzxi45eqQ6ZhRVC9mCYZW32XQQNNo+2NSLKrf8iT9PH6ePvSstvKbbLwNf
         wL6EUtTMmJsTvOaz9pRQwqOOrBknQ5JrWu7DtDHBMHTm0m/VItx3YonwvPkjKAcWcw
         zJtZGGDSLjGRGIhGmTiHYaeT8hFXZg9qC70e1TOdxeZajeMRLeXnC5rC32jNCsKKiR
         t1zfM4FQB82dqgBMPaoVnjOFhYUPHuajGv/fflaLucobRtH9iMNg+wmNqCFXcop92Y
         C4rDcZvWQ8Qvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Xu Jianhai <zero.xu@bytedance.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 5.18 128/159] nbd: Fix hung on disconnect request if socket is closed before
Date:   Mon, 30 May 2022 09:23:53 -0400
Message-Id: <20220530132425.1929512-128-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 491bf8f236fdeec698fa6744993f1ecf3fafd1a5 ]

When userspace closes the socket before sending a disconnect
request, the following I/O requests will be blocked in
wait_for_reconnect() until dead timeout. This will cause the
following disconnect request also hung on blk_mq_quiesce_queue().
That means we have no way to disconnect a nbd device if there
are some I/O requests waiting for reconnecting until dead timeout.
It's not expected. So let's wake up the thread waiting for
reconnecting directly when a disconnect request is sent.

Reported-by: Xu Jianhai <zero.xu@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220322080639.142-1-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5a1f98494ddd..284557041336 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -947,11 +947,15 @@ static int wait_for_reconnect(struct nbd_device *nbd)
 	struct nbd_config *config = nbd->config;
 	if (!config->dead_conn_timeout)
 		return 0;
-	if (test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags))
+
+	if (!wait_event_timeout(config->conn_wait,
+				test_bit(NBD_RT_DISCONNECTED,
+					 &config->runtime_flags) ||
+				atomic_read(&config->live_connections) > 0,
+				config->dead_conn_timeout))
 		return 0;
-	return wait_event_timeout(config->conn_wait,
-				  atomic_read(&config->live_connections) > 0,
-				  config->dead_conn_timeout) > 0;
+
+	return !test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags);
 }
 
 static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
@@ -2082,6 +2086,7 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	mutex_lock(&nbd->config_lock);
 	nbd_disconnect(nbd);
 	sock_shutdown(nbd);
+	wake_up(&nbd->config->conn_wait);
 	/*
 	 * Make sure recv thread has finished, we can safely call nbd_clear_que()
 	 * to cancel the inflight I/Os.
-- 
2.35.1

