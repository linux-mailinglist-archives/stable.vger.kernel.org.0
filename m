Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6B43C2D15
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhGJCVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232085AbhGJCVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E7B1613B5;
        Sat, 10 Jul 2021 02:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883518;
        bh=DcZXu+GUP4OjR5ggwc5CwI1EhC87n3DLDqRN/VXqW+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuC4VA24ecDlI7aTGBJdU2t+VlPAh+9giAZ+nvUAM1TziqoibUw362EiWxrKDVK8Q
         Mm/Dbodb1s+JdmOeDo7HLZ/pCfZiFnXr9CUClODrT6spxNJcdv1f+QIIMflLkzndrN
         TYGB+ZwtenTwt8VpAwv+7d3k9qMYdM8fO+kEtlCJL10obXMcxSSXX1cuSPJ7FYE3h4
         As8ChckEUPkb8fBGagitEkt2Xw3UcAyR2t9ae6wZRyeWyM4Ud671IUb6YGRr+KSgds
         xbJMEWUNHKwRs4eENhDvAr3fdjS8izBbn9Bju0Scu20WBC3P/8ASCKrxVfjfz8w82e
         Yeo+OLpU9i49A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 036/114] scsi: mpt3sas: Fix deadlock while cancelling the running firmware event
Date:   Fri,  9 Jul 2021 22:16:30 -0400
Message-Id: <20210710021748.3167666-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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
index d00aca3c77ce..79e34b5090b1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3697,6 +3697,28 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
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

