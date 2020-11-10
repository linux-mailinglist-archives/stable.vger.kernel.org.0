Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36A32ACCE3
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbgKJD6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387728AbgKJD4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9663420663;
        Tue, 10 Nov 2020 03:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980606;
        bh=fOenn9yeBaHCunCysCslJG4dwffDPlwPlsVozQjgGfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPsfTGmSMym5vNaURgAB59Tv795mGS1DhnEVAZZwz494yw8OhVLdLEFn3zw5ceXB6
         sHP7XnHEenrv2sq+4X0gFUp6ROZ7oeRAkuKALchV5LijCmJdUgohHj6aNI/8xJ8kUj
         YoJCz15/s6gE74IHuigg+kKwJbJYS/Q5ky78FxaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Brian Bunker <brian@purestorage.com>,
        Jitendra Khasdev <jitendra.khasdev@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/12] scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()
Date:   Mon,  9 Nov 2020 22:56:30 -0500
Message-Id: <20201110035633.425030-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035633.425030-1-sashal@kernel.org>
References: <20201110035633.425030-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 60c288526355a..2bc3dc6244a5e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -657,8 +657,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
@@ -704,7 +704,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->expiry = 0;
 			rcu_read_lock();
 			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				BUG_ON(!h->sdev);
+				if (!h->sdev)
+					continue;
 				h->sdev->access_state =
 					(pg->state & SCSI_ACCESS_STATE_MASK);
 				if (pg->pref)
@@ -1149,7 +1150,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	spin_lock(&h->pg_lock);
 	pg = h->pg;
 	rcu_assign_pointer(h->pg, NULL);
-	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
 		spin_lock_irq(&pg->lock);
@@ -1158,6 +1158,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
 		kref_put(&pg->kref, release_port_group);
 	}
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
-- 
2.27.0

