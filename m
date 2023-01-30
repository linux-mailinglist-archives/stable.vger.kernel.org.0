Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91833681178
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbjA3ONo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbjA3ONd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36997233E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA136102E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9973C433D2;
        Mon, 30 Jan 2023 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088010;
        bh=pQA/HbSrQYi/SLs7Wq695giNStFCaHnSeweNSMloVX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFcptdhPWzUX3phbebiudFdnLvGSI5BNLcRupqzBwU1HBBR+V06toDCycZ8Z6jD2m
         zNDzyMhvpklms2bbHPcntP8hB8XBOG5fN14+hC0/0/+bbP5zlidOgAJMt6XDkegXcz
         ff21ewfcrHypM08LtNQGPPX0i9oDuKCsg/mWLpqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/204] w1: fix WARNING after calling w1_process()
Date:   Mon, 30 Jan 2023 14:50:50 +0100
Message-Id: <20230130134320.069574202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 36225a7c72e9e3e1ce4001b6ce72849f5c9a2d3b ]

I got the following WARNING message while removing driver(ds2482):

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<000000002d50bfb6>] w1_process+0x9e/0x1d0 [wire]
WARNING: CPU: 0 PID: 262 at kernel/sched/core.c:9817 __might_sleep+0x98/0xa0
CPU: 0 PID: 262 Comm: w1_bus_master1 Tainted: G                 N 6.1.0-rc3+ #307
RIP: 0010:__might_sleep+0x98/0xa0
Call Trace:
 exit_signals+0x6c/0x550
 do_exit+0x2b4/0x17e0
 kthread_exit+0x52/0x60
 kthread+0x16d/0x1e0
 ret_from_fork+0x1f/0x30

The state of task is set to TASK_INTERRUPTIBLE in loop in w1_process(),
set it to TASK_RUNNING when it breaks out of the loop to avoid the
warning.

Fixes: 3c52e4e62789 ("W1: w1_process, block or sleep")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221205101558.3599162-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 8b35fae4cd61..4a2ddf730a3a 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1195,8 +1195,10 @@ int w1_process(void *data)
 		 */
 		mutex_unlock(&dev->list_mutex);
 
-		if (kthread_should_stop())
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
 			break;
+		}
 
 		/* Only sleep when the search is active. */
 		if (dev->search_count) {
-- 
2.39.0



