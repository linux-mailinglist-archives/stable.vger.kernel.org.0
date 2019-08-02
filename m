Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9807C7F92B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394385AbfHBNZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394379AbfHBNZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:25:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8440E20880;
        Fri,  2 Aug 2019 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752322;
        bh=UwNCHuLU4xRgKFAcl8U3LYJ9kXkzDaUADptdbLcXYiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdLDZLuXZaKYrUwKihXQFlkCWmpzG4HaAIt8hOI8uo3lMzXfNqp2/mYfFPLUHq7OY
         vSTI3+wCldSxklYXwwEmF0/C81cp42qGyA1SLv99SI9wwmdx2MRi862CSBp+YJiE7+
         /7pgP+YwLD7Ls7Vpjl7rlKq9GdVcyZ8/fgVrQ84U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>,
        Zhangguanghui <zhang.guanghui@h3c.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 26/30] scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG
Date:   Fri,  2 Aug 2019 09:24:18 -0400
Message-Id: <20190802132422.13963-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132422.13963-1-sashal@kernel.org>
References: <20190802132422.13963-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 20122994e38aef0ae50555884d287adde6641c94 ]

Retrying immediately after we've received a 'transitioning' sense code is
pretty much pointless, we should always use a delay before retrying.  So
ensure the default delay is applied before retrying.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Tested-by: Zhangguanghui <zhang.guanghui@h3c.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 09c6a16fab93f..41f5f64101630 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -53,6 +53,7 @@
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
+#define ALUA_RTPG_RETRY_DELAY		2
 
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
@@ -677,7 +678,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			pg->interval = 2;
+			pg->interval = ALUA_RTPG_RETRY_DELAY;
 			err = SCSI_DH_RETRY;
 		} else {
 			struct alua_dh_data *h;
@@ -802,6 +803,8 @@ static void alua_rtpg_work(struct work_struct *work)
 				spin_lock_irqsave(&pg->lock, flags);
 				pg->flags &= ~ALUA_PG_RUNNING;
 				pg->flags |= ALUA_PG_RUN_RTPG;
+				if (!pg->interval)
+					pg->interval = ALUA_RTPG_RETRY_DELAY;
 				spin_unlock_irqrestore(&pg->lock, flags);
 				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
 						   pg->interval * HZ);
@@ -813,6 +816,8 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags &= ~ALUA_PG_RUNNING;
+			if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
+				pg->interval = ALUA_RTPG_RETRY_DELAY;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
 			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
-- 
2.20.1

