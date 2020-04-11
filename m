Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3411A580C
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgDKXLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgDKXLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B092166E;
        Sat, 11 Apr 2020 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646697;
        bh=BoqgN4G4H9vf10CyanVHUi3Ae3h0gWob0zne/M3o2x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwhykJ1mWFcgcSgNsk1qSViIqGysKk7LJcGLLgs6wrHRbIfhG8gB+JY/30QIXJLpx
         ms4NHN7llHKpRv2DauRQa6nFQyc+6RHKKj5SDWn+5GqXpsN0XB/LPQ6colwkdGyz6o
         1E2YtH3eFnfL6qLhOARyem0ngclXVG8YSFmGF9qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/108] scsi: qla2xxx: Add fixes for mailbox command
Date:   Sat, 11 Apr 2020 19:09:26 -0400
Message-Id: <20200411230943.24951-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 345f574dac85276d1471492c6e90c57e3f90a4f3 ]

This patch fixes:

- qla2x00_issue_iocb_timeout will now return if chip is down

- only check for sp->qpair in abort handling

Link: https://lore.kernel.org/r/20200212214436.25532-24-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1ef8907314e58..9011a26710374 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1405,6 +1405,9 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
+	if (qla2x00_chip_is_down(vha))
+		return QLA_INVALID_COMMAND;
+
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1038,
 	    "Entered %s.\n", __func__);
 
@@ -1475,7 +1478,7 @@ qla2x00_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103b,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		req = vha->req;
-- 
2.20.1

