Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E6C3CE1D5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346475AbhGSP16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348356AbhGSPYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFA9B6113A;
        Mon, 19 Jul 2021 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710691;
        bh=XGcfWV4/3WtZAaJ8qqR2xCbqYtIF7MC75pOb2pc+MwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATBxLIkrK29IZN8+LdBCR/cRbjDyn3CTHVUYhQKrgplT/i8jD8pVgI3i9Xlpi8pHH
         Ce+OYE31wkuxGpNoGJtSz6ExUnTEhWtHg57coOoO5pol5zHsSJAHkFWi/9ygRwyxMy
         FVTMSFw7bx2/5ZZ4XjI8rwxf8fhK8EttV4M6yPlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/351] scsi: mpt3sas: Fix deadlock while cancelling the running firmware event
Date:   Mon, 19 Jul 2021 16:50:19 +0200
Message-Id: <20210719144946.919580937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a5f70f0e0287..b48f10f7cf31 100644
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



