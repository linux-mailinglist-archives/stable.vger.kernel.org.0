Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E745120F8A0
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389636AbgF3Pml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:41 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43460 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389637AbgF3Pml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:41 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 11F9B20A539B
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 78BB9BA1D44; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 02/10] Bluetooth: Reinitialize the list after deletion for session user list
Date:   Tue, 30 Jun 2020 18:36:33 +0300
Message-ID: <20200630153641.21004-3-d.grigorev@omprussia.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630153641.21004-1-d.grigorev@omprussia.ru>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [81.3.167.34]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To LFEX09.lancloud.ru
 (fd00:f066::59)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

If the user->list is deleted with list_del(), it doesn't initialize the
entry which can cause the issue with list_empty(). According to the
comment from the list.h, list_empty() returns false even if the list is
empty and put the entry in an undefined state.

/**
 * list_del - deletes entry from list.
 * @entry: the element to delete from the list.
 * Note: list_empty() on entry does not return true after this, the entry is
 * in an undefined state.
 */

Because of this behavior, list_empty() returns false even if list is empty
when the device is reconnected.

So, user->list needs to be re-initialized after list_del(). list.h already
have a macro list_del_init() which deletes the entry and initailze it again.

Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Tested-by: Jörg Otte <jrg.otte@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1700c3dc3fe1..eb0125d1451d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1649,7 +1649,7 @@ void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user)
 	if (list_empty(&user->list))
 		goto out_unlock;
 
-	list_del(&user->list);
+	list_del_init(&user->list);
 	user->remove(conn, user);
 
 out_unlock:
@@ -1663,7 +1663,7 @@ static void l2cap_unregister_all_users(struct l2cap_conn *conn)
 
 	while (!list_empty(&conn->users)) {
 		user = list_first_entry(&conn->users, struct l2cap_user, list);
-		list_del(&user->list);
+		list_del_init(&user->list);
 		user->remove(conn, user);
 	}
 }
-- 
2.17.1

