Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955FA51A660
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354239AbiEDQzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354505AbiEDQyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4210947385;
        Wed,  4 May 2022 09:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4785B827A0;
        Wed,  4 May 2022 16:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BCAC385A5;
        Wed,  4 May 2022 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682979;
        bh=C3Yvy/qzZwrx37raEwVDeS3Z2P4nQvqPOYKe2HSqq5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzkMGtWyyePC2/sccrPMdS+GAZXR/YqZsEMP4u422PBcweNz9Uk+4T6g/1d82qUKo
         SC6XjegujByw14fHwJxVKztFpjtZ5kJwV0BSut29rTako7feT93o+gFAI/41GXi24r
         kPkfm5B+P9JP60q8lIkvRqxOQe6zP/j35kRLb1yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/84] drivers: net: hippi: Fix deadlock in rr_close()
Date:   Wed,  4 May 2022 18:44:53 +0200
Message-Id: <20220504152933.080098207@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit bc6de2878429e85c1f1afaa566f7b5abb2243eef ]

There is a deadlock in rr_close(), which is shown below:

   (Thread 1)                |      (Thread 2)
                             | rr_open()
rr_close()                   |  add_timer()
 spin_lock_irqsave() //(1)   |  (wait a time)
 ...                         | rr_timer()
 del_timer_sync()            |  spin_lock_irqsave() //(2)
 (wait timer to stop)        |  ...

We hold rrpriv->lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need rrpriv->lock in position (2) of thread 2.
As a result, rr_close() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417125519.82618-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hippi/rrunner.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index a4b3fce69ecd..6016e182f008 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1346,7 +1346,9 @@ static int rr_close(struct net_device *dev)
 
 	rrpriv->fw_running = 0;
 
+	spin_unlock_irqrestore(&rrpriv->lock, flags);
 	del_timer_sync(&rrpriv->timer);
+	spin_lock_irqsave(&rrpriv->lock, flags);
 
 	writel(0, &regs->TxPi);
 	writel(0, &regs->IpRxPi);
-- 
2.35.1



