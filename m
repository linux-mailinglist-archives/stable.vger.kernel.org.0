Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A128C657FB2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiL1QH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbiL1QHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB961868E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E594B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE53C433D2;
        Wed, 28 Dec 2022 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243651;
        bh=9woX/Ix4nDg2OVr2Q8Uak1GUS/dAnI0aLXg8+CsrtEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJNkYQ0gfJu3asAFvsyjggAVZnWZfqjVOwhE4gdoJGEs1ACl9cVQFyGWvvhBgiDJG
         AIc7Fqgm6ePCrRsISY2TtyxFJQv+xRpctvr1ztMPFQw/EXWyQRSCU+SXPlHJ3DPWkn
         4Ec8LrGjc6VAnzpKIfdF53dZr1fbCbnIOvh/4psU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0541/1073] Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
Date:   Wed, 28 Dec 2022 15:35:29 +0100
Message-Id: <20221228144342.750381528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index f26ed278d9e3..67360444eee6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1817,7 +1817,7 @@ static int hci_create_cis_sync(struct hci_dev *hdev, void *data)
 			continue;
 
 		/* Check if all CIS(s) belonging to a CIG are ready */
-		if (conn->link->state != BT_CONNECTED ||
+		if (!conn->link || conn->link->state != BT_CONNECTED ||
 		    conn->state != BT_CONNECT) {
 			cmd.cp.num_cis = 0;
 			break;
-- 
2.35.1



