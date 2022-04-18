Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45F50542D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbiDRNEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241550AbiDRNDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDD33A0F;
        Mon, 18 Apr 2022 05:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82393B80E4B;
        Mon, 18 Apr 2022 12:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08B2C385A1;
        Mon, 18 Apr 2022 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285819;
        bh=bLcI8hbjt28iQGSQ6pHqoLkLd+ORRcK4bONCyvx1t0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph3hKcSqfygvNawm7KogcSqad45+gZ+uraca4LpLHR7LFkq3JwDKwsmM38ViO7nph
         GlRDcpjegdsImQ8U8dyDbmMPn8kUz3K72yaABi8jLAq9AGsOoiatI+/xrFsn6rooHM
         VnAZngYGgmVDnmVrItpszslsEcyuav9bXtVYYfGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/63] drivers: net: slip: fix NPD bug in sl_tx_timeout()
Date:   Mon, 18 Apr 2022 14:13:32 +0200
Message-Id: <20220418121136.595236205@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
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

[ Upstream commit ec4eb8a86ade4d22633e1da2a7d85a846b7d1798 ]

When a slip driver is detaching, the slip_close() will act to
cleanup necessary resources and sl->tty is set to NULL in
slip_close(). Meanwhile, the packet we transmit is blocked,
sl_tx_timeout() will be called. Although slip_close() and
sl_tx_timeout() use sl->lock to synchronize, we don`t judge
whether sl->tty equals to NULL in sl_tx_timeout() and the
null pointer dereference bug will happen.

   (Thread 1)                 |      (Thread 2)
                              | slip_close()
                              |   spin_lock_bh(&sl->lock)
                              |   ...
...                           |   sl->tty = NULL //(1)
sl_tx_timeout()               |   spin_unlock_bh(&sl->lock)
  spin_lock(&sl->lock);       |
  ...                         |   ...
  tty_chars_in_buffer(sl->tty)|
    if (tty->ops->..) //(2)   |
    ...                       |   synchronize_rcu()

We set NULL to sl->tty in position (1) and dereference sl->tty
in position (2).

This patch adds check in sl_tx_timeout(). If sl->tty equals to
NULL, sl_tx_timeout() will goto out.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20220405132206.55291-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 8e56a41dd758..096617982998 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -471,7 +471,7 @@ static void sl_tx_timeout(struct net_device *dev)
 	spin_lock(&sl->lock);
 
 	if (netif_queue_stopped(dev)) {
-		if (!netif_running(dev))
+		if (!netif_running(dev) || !sl->tty)
 			goto out;
 
 		/* May be we must check transmitter timeout here ?
-- 
2.35.1



