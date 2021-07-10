Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F923C2DF4
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhGJCZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233146AbhGJCZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A6A613B7;
        Sat, 10 Jul 2021 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883757;
        bh=1v074zr1y4wIdMNpxUqEowUJUqs4/NJN4Zf3nkxRxvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUlZUCUt/bndpVEt62q431orYD8LfUYQ4yri3X2WnalgQh7nh7DVXuUgMnN3WmhIg
         +0MBUwCF+wHjZRjdNjolgBfi5sfj+0LA8idgrN8DOylsiaSyCylZy2Qzrf8C7FJmPs
         9PzpB/jEqPIOvwZ4iRpaRvW1L3CBYkGNOjgZFc79iaGMkxLcE0fmmEH2Kx+GldQxmC
         nFGxhfSjQl3xtGNloAwNeL3GxA+0kSb534vgvp2CY44TYMhu83TTnB8tUiojHR7qMw
         H3iRjX6PhtlQQBbQfOBugqwRo+qrcyK2UI+AHnJlQT4ax/SdZhcP5PLY3JnyDQZu7b
         yjYuHMrayFHZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 032/104] scsi: mpt3sas: Fix deadlock while cancelling the running firmware event
Date:   Fri,  9 Jul 2021 22:20:44 -0400
Message-Id: <20210710022156.3168825-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit e2fac6c44ae06e58ac02181b048af31195883c31 ]

Do not cancel current running firmware event work if the event type is
different from MPT3SAS_REMOVE_UNRESPONDING_DEVICES.  Otherwise a deadlock
can be observed while cancelling the current firmware event work if a hard
reset operation is called as part of processing the current event.

Link: https://lore.kernel.org/r/20210518051625.1596742-2-suganath-prabu.subramani@broadcom.com
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ae1973878cc7..d68a3a42c3fb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3696,6 +3696,28 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 	ioc->fw_events_cleanup = 1;
 	while ((fw_event = dequeue_next_fw_event(ioc)) ||
 	     (fw_event = ioc->current_event)) {
+
+		/*
+		 * Don't call cancel_work_sync() for current_event
+		 * other than MPT3SAS_REMOVE_UNRESPONDING_DEVICES;
+		 * otherwise we may observe deadlock if current
+		 * hard reset issued as part of processing the current_event.
+		 *
+		 * Orginal logic of cleaning the current_event is added
+		 * for handling the back to back host reset issued by the user.
+		 * i.e. during back to back host reset, driver use to process
+		 * the two instances of MPT3SAS_REMOVE_UNRESPONDING_DEVICES
+		 * event back to back and this made the drives to unregister
+		 * the devices from SML.
+		 */
+
+		if (fw_event == ioc->current_event &&
+		    ioc->current_event->event !=
+		    MPT3SAS_REMOVE_UNRESPONDING_DEVICES) {
+			ioc->current_event = NULL;
+			continue;
+		}
+
 		/*
 		 * Wait on the fw_event to complete. If this returns 1, then
 		 * the event was never executed, and we need a put for the
-- 
2.30.2

