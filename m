Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A484D2B6556
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbgKQNZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbgKQNZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9FA82467D;
        Tue, 17 Nov 2020 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619526;
        bh=7lcMbKOxhN/Le0MESmUbQj5z7nRfEq6LZOAd40/ORv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVFgxYdrZMJd2NqKLUbQBm4iygv/lFlksFoNwJ3ZSGCB1vEPovpLd1tpLrLW4KCIN
         fXNZTgAaJ0DGNWPvp9Jk1WA1uqMTqpP8U5Q6ozHM4onH9kNe5r3doTQ6Gx85V09ATw
         2gYcbXRWgbiYhkTac34Cf715dGpTsSllXxwTNuf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Jitendra Khasdev <jitendra.khasdev@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/151] scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()
Date:   Tue, 17 Nov 2020 14:04:57 +0100
Message-Id: <20201117122124.681334317@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 5faf50e9e9fdc2117c61ff7e20da49cd6a29e0ca ]

alua_bus_detach() might be running concurrently with alua_rtpg_work(), so
we might trip over h->sdev == NULL and call BUG_ON().  The correct way of
handling it is to not set h->sdev to NULL in alua_bus_detach(), and call
rcu_synchronize() before the final delete to ensure that all concurrent
threads have left the critical section.  Then we can get rid of the
BUG_ON() and replace it with a simple if condition.

Link: https://lore.kernel.org/r/1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com
Link: https://lore.kernel.org/r/20200924104559.26753-1-hare@suse.de
Cc: Brian Bunker <brian@purestorage.com>
Acked-by: Brian Bunker <brian@purestorage.com>
Tested-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
Reviewed-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f32da0ca529e0..308bda2e9c000 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -658,8 +658,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 					rcu_read_lock();
 					list_for_each_entry_rcu(h,
 						&tmp_pg->dh_list, node) {
-						/* h->sdev should always be valid */
-						BUG_ON(!h->sdev);
+						if (!h->sdev)
+							continue;
 						h->sdev->access_state = desc[0];
 					}
 					rcu_read_unlock();
@@ -705,7 +705,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->expiry = 0;
 			rcu_read_lock();
 			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				BUG_ON(!h->sdev);
+				if (!h->sdev)
+					continue;
 				h->sdev->access_state =
 					(pg->state & SCSI_ACCESS_STATE_MASK);
 				if (pg->pref)
@@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	spin_lock(&h->pg_lock);
 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	rcu_assign_pointer(h->pg, NULL);
-	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
 		spin_lock_irq(&pg->lock);
@@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
 		kref_put(&pg->kref, release_port_group);
 	}
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
-- 
2.27.0



