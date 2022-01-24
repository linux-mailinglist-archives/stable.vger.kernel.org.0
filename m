Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593E449960A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345587AbiAXU6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442007AbiAXUwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:52:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0732C03540E;
        Mon, 24 Jan 2022 11:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D580B81218;
        Mon, 24 Jan 2022 19:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF00C340ED;
        Mon, 24 Jan 2022 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054326;
        bh=+lpXt2QvzgIYVVxYWVN0oM5QZUSO2Opgpdlmv+PCAI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CckU9rOTQfJekJFNT0JgZCHv4h9MnsJ/PcKu8cXijyJ/oBiub4FPfJ5yLpIDyl6C
         o5dsUyori/6GsaHEhvLAwWkWTFQ9mv94HdYdHiC95fPK/HwkS5c8s4a2ZNPrEtrbOA
         Dl4+lK4e8llBzijiMCYp05FB6LB2bkuyWGxhMnEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/563] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 24 Jan 2022 19:41:56 +0100
Message-Id: <20220124184036.549398330@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit d7dac083414eb5bb99a6d2ed53dc2c1b405224e5 ]

When updating Rx and Tx queue kobjects, the queue count should always be
updated to match the queue kobjects count. This was not done in the net
device unregistration path, fix it. Tracking all queue count updates
will allow in a following up patch to detect illegal updates.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index af59123601055..99303897b7bb7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1804,6 +1804,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
 	net_rx_queue_update_kobjects(dev, real_rx, 0);
 	netdev_queue_update_kobjects(dev, real_tx, 0);
+
+	dev->real_num_rx_queues = 0;
+	dev->real_num_tx_queues = 0;
 #ifdef CONFIG_SYSFS
 	kset_unregister(dev->queues_kset);
 #endif
-- 
2.34.1



