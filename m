Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0233B20F89D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbgF3Pmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:39 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43314 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389637AbgF3Pmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:39 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 00B1120A5387
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 7570ABA1D3E; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 01/10] Bluetooth: Stop sabotaging list poisoning
Date:   Tue, 30 Jun 2020 18:36:32 +0300
Message-ID: <20200630153641.21004-2-d.grigorev@omprussia.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630153641.21004-1-d.grigorev@omprussia.ru>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.3.167.34]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To LFEX09.lancloud.ru
 (fd00:f066::59)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

list_del() poisons pointers with special values, no need to overwrite them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 35c41fdbde16..1700c3dc3fe1 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1616,7 +1616,7 @@ int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user)
 
 	hci_dev_lock(hdev);
 
-	if (user->list.next || user->list.prev) {
+	if (!list_empty(&user->list)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1646,12 +1646,10 @@ void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user)
 
 	hci_dev_lock(hdev);
 
-	if (!user->list.next || !user->list.prev)
+	if (list_empty(&user->list))
 		goto out_unlock;
 
 	list_del(&user->list);
-	user->list.next = NULL;
-	user->list.prev = NULL;
 	user->remove(conn, user);
 
 out_unlock:
@@ -1666,8 +1664,6 @@ static void l2cap_unregister_all_users(struct l2cap_conn *conn)
 	while (!list_empty(&conn->users)) {
 		user = list_first_entry(&conn->users, struct l2cap_user, list);
 		list_del(&user->list);
-		user->list.next = NULL;
-		user->list.prev = NULL;
 		user->remove(conn, user);
 	}
 }
-- 
2.17.1

