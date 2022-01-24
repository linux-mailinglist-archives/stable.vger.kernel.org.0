Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C84498F19
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350787AbiAXTu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355439AbiAXTlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EE0C06176F;
        Mon, 24 Jan 2022 11:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2E16B8121A;
        Mon, 24 Jan 2022 19:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D72C340E5;
        Mon, 24 Jan 2022 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052083;
        bh=A9QrOZZOs90LBJJ2cTE2RJkFHsE+7U4j+ayQc02i0ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y19p9JZogE0hMwG3lk1sXqNowAB0lYq0xoUWVA06S1MEFHsMcDrbBw2jewb2FyBFz
         wq5stcFXxyJFbMKMVhQ+cB894mL7wBuHEJZoSCPzNh6f0/uQLEQwLK+yO+BGdyaE/1
         RfRg34Fl4O6jHFYfgpWCfkXniw5KZg2X/kr3VBi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/239] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 24 Jan 2022 19:42:59 +0100
Message-Id: <20220124183947.587473748@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index fe0d255d66c8b..e5dc04cb55992 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1616,6 +1616,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
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



