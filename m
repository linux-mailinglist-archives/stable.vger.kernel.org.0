Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2542953CFBF
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiFCR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345847AbiFCRzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3CE44A11;
        Fri,  3 Jun 2022 10:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D787EB82189;
        Fri,  3 Jun 2022 17:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E326C385A9;
        Fri,  3 Jun 2022 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278777;
        bh=wHaTodtD45mZ8oITybG8g60oCCAN8kY0JNM8000sTLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aG9pRkjuAelzvipGcq8YUYZJd3Mca3rYgty1mMaKl8vwRIa1ZiXBlvuohEm+4Nm/
         mWAFWYH426UJi7ls3JLUAMt+f5fFiyv3Xiim9qjb5Ehg40ej29KPHuVZ9RNMmPYA2h
         mgg4oGlqsa6pSw3kPpFZ3GyEz9WFAtr+b6dhRbbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 08/75] nfc: pn533: Fix buggy cleanup order
Date:   Fri,  3 Jun 2022 19:42:52 +0200
Message-Id: <20220603173821.986074977@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit b8cedb7093b2d1394cae9b86494cba4b62d3a30a ]

When removing the pn533 device (i2c or USB), there is a logic error. The
original code first cancels the worker (flush_delayed_work) and then
destroys the workqueue (destroy_workqueue), leaving the timer the last
one to be deleted (del_timer). This result in a possible race condition
in a multi-core preempt-able kernel. That is, if the cleanup
(pn53x_common_clean) is concurrently run with the timer handler
(pn533_listen_mode_timer), the timer can queue the poll_work to the
already destroyed workqueue, causing use-after-free.

This patch reorder the cleanup: it uses the del_timer_sync to make sure
the handler is finished before the routine will destroy the workqueue.
Note that the timer cannot be activated by the worker again.

static void pn533_wq_poll(struct work_struct *work)
...
 rc = pn533_send_poll_frame(dev);
 if (rc)
   return;

 if (cur_mod->len == 0 && dev->poll_mod_count > 1)
   mod_timer(&dev->listen_timer, ...);

That is, the mod_timer can be called only when pn533_send_poll_frame()
returns no error, which is impossible because the device is detaching
and the lower driver should return ENODEV code.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a491db46e3bd..d9f6367b9993 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2787,13 +2787,14 @@ void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
+	/* delete the timer before cleanup the worker */
+	del_timer_sync(&priv->listen_timer);
+
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
 
-	del_timer(&priv->listen_timer);
-
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);
 		kfree(cmd);
-- 
2.35.1



