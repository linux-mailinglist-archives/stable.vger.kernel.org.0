Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6458127D6C
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfLTOd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbfLTOaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD1C724688;
        Fri, 20 Dec 2019 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852235;
        bh=zfjn9+TFi5SJgfhQJgf9Bq1cAAuX3fYjr4XtIHkOWgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi99ViiUZavQKitICQvqFENgEgIA0j/AHOJt2CK1xqRhINZ2UPaeGbbeFazDvvBQl
         /jbhGGOPrzHF77I4rlqsOX4qAX3Gjc6j/su1z8RG+0ZqzAwBvzX0QDQR/2QeQwhMuw
         XEZBCrgl8Fv4HuDyuQuczeX6vptUvH/+6GWcchiU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Alexei Potashnik <alexei@purestorage.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/52] scsi: qla2xxx: Send Notify ACK after N2N PLOGI
Date:   Fri, 20 Dec 2019 09:29:31 -0500
Message-Id: <20191220142954.9500-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 5e6b01d84b9d20bcd77fc7c4733a2a4149bf220a ]

qlt_handle_login schedules session for deletion even if a login is in
progress. That causes login bouncing, i.e. a few logins are made before it
settles down.

Complete the first login by sending Notify Acknowledge IOCB via
qlt_plogi_ack_unref if the session is pending login completion.

Fixes: 9cd883f07a54 ("scsi: qla2xxx: Fix session cleanup for N2N")
Cc: Krishna Kant <krishna.kant@purestorage.com>
Cc: Alexei Potashnik <alexei@purestorage.com>
Link: https://lore.kernel.org/r/20191125165702.1013-11-r.bolshakov@yadro.com
Acked-by: Quinn Tran <qutran@marvell.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5bb5249bb822c..ee0d07836b832 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4804,6 +4804,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 
 	switch (sess->disc_state) {
 	case DSC_DELETED:
+	case DSC_LOGIN_PEND:
 		qlt_plogi_ack_unref(vha, pla);
 		break;
 
-- 
2.20.1

