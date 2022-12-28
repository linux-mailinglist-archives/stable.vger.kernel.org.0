Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D50657FF9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiL1QM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiL1QL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:11:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F041A39B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F097A6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F32EC433EF;
        Wed, 28 Dec 2022 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243801;
        bh=hEywVymhDqh4o2mJYS9dU1xyxiPnAJ3GsGDziuApShQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmCkivRV+l2ajttXAvVlHttOFoeej0D36THMbHqtzCfwNaZ1c+3uEObJLPK+DkQr3
         KPC0haoVRiLjSuPXlZiAFRhNvpGzFonaB0Oo94hQSdWi9nI93czJkztQkBAWW8GqC9
         40woDvyznJw3XDziWQWYAkG76Wr69eyDHe161qUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0558/1146] Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
Date:   Wed, 28 Dec 2022 15:34:57 +0100
Message-Id: <20221228144345.326001347@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 50757a259ba78c4e938b5735e76ffec6cd0c942e ]

When attempting to connect multiple ISO sockets without using
DEFER_SETUP may result in the following crash:

BUG: KASAN: null-ptr-deref in hci_create_cis_sync+0x18b/0x2b0
Read of size 2 at addr 0000000000000036 by task kworker/u3:1/50

CPU: 0 PID: 50 Comm: kworker/u3:1 Not tainted
6.0.0-rc7-02243-gb84a13ff4eda #4373
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.0-1.fc36 04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x19/0x27
 kasan_report+0xbc/0xf0
 ? hci_create_cis_sync+0x18b/0x2b0
 hci_create_cis_sync+0x18b/0x2b0
 ? get_link_mode+0xd0/0xd0
 ? __ww_mutex_lock_slowpath+0x10/0x10
 ? mutex_lock+0xe0/0xe0
 ? get_link_mode+0xd0/0xd0
 hci_cmd_sync_work+0x111/0x190
 process_one_work+0x427/0x650
 worker_thread+0x87/0x750
 ? process_one_work+0x650/0x650
 kthread+0x14e/0x180
 ? kthread_exit+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index a6c12863a253..8aab2e882958 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1881,7 +1881,7 @@ static int hci_create_cis_sync(struct hci_dev *hdev, void *data)
 			continue;
 
 		/* Check if all CIS(s) belonging to a CIG are ready */
-		if (conn->link->state != BT_CONNECTED ||
+		if (!conn->link || conn->link->state != BT_CONNECTED ||
 		    conn->state != BT_CONNECT) {
 			cmd.cp.num_cis = 0;
 			break;
-- 
2.35.1



