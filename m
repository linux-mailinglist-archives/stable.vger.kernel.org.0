Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6244681027
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbjA3OBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbjA3OBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF083B0F4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23BC1CE16AE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3071C433EF;
        Mon, 30 Jan 2023 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087172;
        bh=IL8K+OYcWsc47SLmQhZESuu9NL6hIBDus51xAMcc5M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgMuE/klIjiVn/zjoEsoY1XxZgY6kiaeodseg/ui+0fsDfx3TaP/dJGmUB8dT4BzN
         lWvbVd7z1L8r3s3mok4xLv8wWpkIjkUVcTlnLDEZPwExVn72bJdsuP115FBonQy5b0
         R1QI9J3/66D9g6RasQk6NcZ4nanfdgPiAfBAnjGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/313] Bluetooth: hci_event: Fix Invalid wait context
Date:   Mon, 30 Jan 2023 14:48:58 +0100
Message-Id: <20230130134341.446417678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit e9d50f76fe1f7f6f251114919247445fb5cb3734 ]

This fixes the following trace caused by attempting to lock
cmd_sync_work_lock while holding the rcu_read_lock:

kworker/u3:2/212 is trying to lock:
ffff888002600910 (&hdev->cmd_sync_work_lock){+.+.}-{3:3}, at:
hci_cmd_sync_queue+0xad/0x140
other info that might help us debug this:
context-{4:4}
4 locks held by kworker/u3:2/212:
 #0: ffff8880028c6530 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
 process_one_work+0x4dc/0x9a0
 #1: ffff888001aafde0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
 at: process_one_work+0x4dc/0x9a0
 #2: ffff888002600070 (&hdev->lock){+.+.}-{3:3}, at:
 hci_cc_le_set_cig_params+0x64/0x4f0
 #3: ffffffffa5994b00 (rcu_read_lock){....}-{1:2}, at:
 hci_cc_le_set_cig_params+0x2f9/0x4f0

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index faca701bce2a..0e2425eb6aa7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3838,8 +3838,11 @@ static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
 			   conn->handle, conn->link);
 
 		/* Create CIS if LE is already connected */
-		if (conn->link && conn->link->state == BT_CONNECTED)
+		if (conn->link && conn->link->state == BT_CONNECTED) {
+			rcu_read_unlock();
 			hci_le_create_cis(conn->link);
+			rcu_read_lock();
+		}
 
 		if (i == rp->num_handles)
 			break;
-- 
2.39.0



