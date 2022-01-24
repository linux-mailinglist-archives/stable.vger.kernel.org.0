Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE24991AD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355218AbiAXUNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379369AbiAXULV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:11:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA51C06F8E2;
        Mon, 24 Jan 2022 11:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DCC161504;
        Mon, 24 Jan 2022 19:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA3C340E5;
        Mon, 24 Jan 2022 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052807;
        bh=9aYQODP5szAojPD5WJTQP+8gls/HiWPful1vla/RVVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5sMzs0k5IrgxWb2Iu8ZgxWcC68zEGo6FZrUQm9wBXJnk4Zz4qschzkWEvThmK//L
         IVPCHZzIU+Xx6VwKFt3CY6mH76r6sd0DAWifmgLMqCfGh49fUdllGsTCI6DrQIkF59
         VQ54o4A9mp7+B0o3ZL5ac/5bqBCwb4oUiqn9uAuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/320] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 24 Jan 2022 19:42:45 +0100
Message-Id: <20220124183959.824749734@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 05b0c60bfba2b..bcad7028bbf45 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1661,6 +1661,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
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



